import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class WebRTCService {
  final String token;
  final String consultationId;

  late io.Socket _socket;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final StreamController<RTCVideoRenderer> remoteRenderersController =
      StreamController<RTCVideoRenderer>.broadcast();

  final Map<String, RTCPeerConnection> _peers = {};
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};

  MediaStream? _localStream;
  bool _isMuted = false;
  bool _isVideoOn = true;

  WebRTCService({
    required this.token,
    required this.consultationId,
  });

  Stream<RTCVideoRenderer> get remoteRenderers =>
      remoteRenderersController.stream;

  Future<void> initialize() async {
    await localRenderer.initialize();
    await _getLocalStream();
    _initializeSocket();
  }

  Future<void> _getLocalStream() async {
    Map<String, dynamic> audioConstraints = {
      'echoCancellation': true,
      'noiseSuppression': false,
      'autoGainControl': true,
      'sampleRate': 48000,
      'channelCount': 2,
    };

    final constraints = {
      'audio': audioConstraints,
      'video': {
        'mandatory': {
          'minWidth': '1280',
          'minHeight': '720',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
      }
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(constraints);
      localRenderer.srcObject = _localStream;
    } catch (e) {
      print('Error getting local stream: $e');
    }
  }

  void _initializeSocket() {
    _socket = io.io(
        'https://realtime.temanternak.h14.my.id/',
        io.OptionBuilder()
            .setExtraHeaders({'authorization': 'bearer $token'})
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    _socket.connect();

    _socket.on('connect', (_) {
      print('Socket connected');
      _socket.emit('join-room', [token, consultationId]);
    });

    _socket.on('user-connected', (data) async {
      final socketId = data[0];
      final userId = data[1];
      final peerConnection = await _createPeerConnection(socketId);
      final offer = await peerConnection.createOffer();
      await peerConnection.setLocalDescription(offer);

      _socket.emit('offer', [
        offer.toMap(),
        consultationId,
        socketId,
        _isMuted,
        _isVideoOn,
        token
      ]);
    });

    _socket.on('offer', (data) async {
      final offer = data[0];
      final socketId = data[1];
      final userId = data[2];
      final isMuted = data[3];
      final isVideoOn = data[4];

      final peerConnection = await _createPeerConnection(socketId);
      await peerConnection.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']));

      final answer = await peerConnection.createAnswer();
      await peerConnection.setLocalDescription(answer);

      _socket.emit('answer',
          [answer.toMap(), consultationId, socketId, _isMuted, _isVideoOn]);
    });

    _socket.on('answer', (data) async {
      final answer = data[0];
      final socketId = data[1];
      final isMuted = data[2];
      final isVideoOn = data[3];

      final peerConnection = _peers[socketId];
      if (peerConnection != null) {
        await peerConnection.setRemoteDescription(
            RTCSessionDescription(answer['sdp'], answer['type']));
      }
    });

    _socket.on('ice-candidate', (data) async {
      final candidate = data[0];
      final socketId = data[1];
      final peerConnection = _peers[socketId];
      if (peerConnection != null) {
        await peerConnection.addCandidate(RTCIceCandidate(
            candidate['candidate'],
            candidate['sdpMid'],
            candidate['sdpMLineIndex']));
      }
    });
  }

  Future<RTCPeerConnection> _createPeerConnection(String socketId) async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {
          'urls': 'turn:sip.temanternak.h14.my.id:3478',
          'username': 'temanternak',
          'credential': '123123'
        }
      ]
    };

    final peerConnection = await createPeerConnection(configuration);

    // Add local stream tracks
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        peerConnection.addTrack(track, _localStream!);
      });
    }

    // Handle ICE candidates
    peerConnection.onIceCandidate = (candidate) {
      _socket
          .emit('ice-candidate', [candidate.toMap(), consultationId, socketId]);
    };

    // Handle incoming tracks
    peerConnection.onTrack = (event) {
      final renderer = RTCVideoRenderer();
      renderer.initialize().then((_) {
        renderer.srcObject = event.streams[0];
        _remoteRenderers[socketId] = renderer;
        remoteRenderersController.add(renderer);
      });
    };

    _peers[socketId] = peerConnection;
    return peerConnection;
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = !_isMuted;
    });
    // Notify socket about mute status
    _socket.emit('user-muted', [_isMuted]);
  }

  void toggleVideo() {
    _isVideoOn = !_isVideoOn;
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = _isVideoOn;
    });
    // Notify socket about video status
    _socket.emit('user-video-toggled', [_isVideoOn]);
  }

  Future<void> switchCamera() async {
    final videoTrack = _localStream?.getVideoTracks().firstOrNull;
    if (videoTrack != null) {
      await Helper.switchCamera(videoTrack);
    }
  }

  void dispose() {
    _socket.disconnect();

    _peers.forEach((_, peerConnection) {
      peerConnection.close();
    });
    _peers.clear();

    localRenderer.dispose();
    _remoteRenderers.forEach((_, renderer) {
      renderer.dispose();
    });

    _localStream?.dispose();
    remoteRenderersController.close();
  }
}
