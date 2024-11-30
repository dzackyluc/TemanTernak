import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:temanternak/services/storage_service.dart';
import 'package:temanternak/views/pages/video_call_page.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  final consultationId;

  ChatPage({super.key, required this.consultationId});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late io.Socket socket;
  bool _isConnected = false;
  StorageService storageService = StorageService();
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _consultationData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final token = await storageService.getData('token');
      final response = await http.get(
        Uri.parse('https://api.temanternak.h14.my.id/users/my'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _userData = json.decode(response.body)['data'];
        });
        await _fetchConsultationData();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _fetchConsultationData() async {
    try {
      final token = await storageService.getData('token');
      final response = await http.get(
        Uri.parse(
            'https://api.temanternak.h14.my.id/bookings/${widget.consultationId}/consultations'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _consultationData = json.decode(response.body)['data'];
        });
        if (_consultationData!['token'] != null) {
          _isConnected = true;
          _initializeSocket();
        } else {
          setState(() {
            _isConnected = false;
            _initializeSocket();
          });
        }
      }
    } catch (e) {
      print('Error fetching consultation data: $e');
    }
  }

  void _initializeSocket() async {
    final token = await storageService.getData('token');
    socket = io.io('https://realtime.temanternak.h14.my.id/', {
      'extraHeaders': {
        'authorization': 'bearer ${_consultationData!['token']}',
      },
      'transports': ['websocket'],
    });

    _setupSocketListeners();
    socket.emit('join-room', [token, widget.consultationId]);
  }

  void _setupSocketListeners() {
    socket.on('user-connected', _handleUserConnected);
    socket.on('receiveMessage', _handleReceiveMessage);
    socket.on('previousMessages', _handlePreviousMessages);
  }

  void _handleUserConnected(data) {
    print('User connected: $data');
  }

  void _handleReceiveMessage(dynamic message) {
    setState(() {
      _messages.add(ChatMessage(
        text: message['message'],
        isMe: message['userId'] == _userData?['id'],
        userName: _getUserName(message['userId']),
      ));
    });
  }

  void _handlePreviousMessages(dynamic messages) {
    setState(() {
      _messages.addAll(
        (messages as List)
            .map((msg) => ChatMessage(
                  text: msg['message'],
                  isMe: msg['userId'].toString() == _userData?['id'].toString(),
                  userName: _getUserName(msg['userId']),
                ))
            .toList(),
      );
    });
  }

  String _getUserName(dynamic userId) {
    String userIdString = userId.toString();

    if (userIdString == _userData?['id'].toString()) {
      return _userData?['name'];
    } else {
      return _consultationData?['veterinarianNameAndTitle'] ?? 'Veterinarian';
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      socket.emit('sendMessage', {'message': _controller.text});
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blue[100],
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _consultationData?['veterinarianNameAndTitle'] ??
                        'Waiting....',
                    style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.video_call, color: Colors.blueGrey[800]),
              onPressed: () {
                if (_consultationData!['token'] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoCallPage(
                        consultationId: _consultationData!['id'],
                        token: _consultationData!['token'],
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dokter belum terhubung'),
                    ),
                  );
                }
              }),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.blueGrey[800]),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100, 80, 0, 0),
                items: [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Hapus Semua"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Laporkan"),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  // Handle menu selection
                  print("Selected option: $value");
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          if (_isConnected) _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue[100] : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message.text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Type a message',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: Colors.blue[200],
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String userName;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.userName,
  });
}
