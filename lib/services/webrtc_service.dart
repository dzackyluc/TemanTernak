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
  final Set<String> _connectedPeers = {};

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

  void _cleanupPeerConnection(String socketId) {
    // Close and remove peer connection
    _peers[socketId]?.close();
    _peers.remove(socketId);

    // Dispose and remove renderer
    _remoteRenderers[socketId]?.dispose();
    _remoteRenderers.remove(socketId);

    // Remove from connected peers set
    _connectedPeers.remove(socketId);
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

      // Clean up existing connection if any
      if (_peers.containsKey(socketId)) {
        _cleanupPeerConnection(socketId);
      }

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

    _socket.on('user-disconnected', (data) {
      final socketId = data[0];
      _cleanupPeerConnection(socketId);
    });

    _socket.on('offer', (data) async {
      final offer = data[0];
      final socketId = data[1];
      final userId = data[2];
      final isMuted = data[3];
      final isVideoOn = data[4];

      // Clean up existing connection if any
      if (_peers.containsKey(socketId)) {
        _cleanupPeerConnection(socketId);
      }

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
        try {
          await peerConnection.addCandidate(RTCIceCandidate(
              candidate['candidate'],
              candidate['sdpMid'],
              candidate['sdpMLineIndex']));
        } catch (e) {
          print('Error adding ICE candidate: $e');
        }
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
    peerConnection.onTrack = (event) async {
      if (!_connectedPeers.contains(socketId)) {
        _connectedPeers.add(socketId);

        final renderer = RTCVideoRenderer();
        await renderer.initialize();
        renderer.srcObject = event.streams[0];
        _remoteRenderers[socketId] = renderer;
        remoteRenderersController.add(renderer);
      }
    };

    peerConnection.onConnectionState = (state) {
      print('Peer connection state for $socketId: $state');
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          print('Connected to peer: $socketId');
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          _cleanupPeerConnection(socketId);
          break;
        default:
          break;
      }
    };

    _peers[socketId] = peerConnection;
    return peerConnection;
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = !_isMuted;
    });
    _socket.emit('user-muted', [_isMuted]);
  }

  void toggleVideo() {
    _isVideoOn = !_isVideoOn;
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = _isVideoOn;
    });
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

    // Clean up all peer connections
    _peers.keys.toList().forEach(_cleanupPeerConnection);
    _peers.clear();
    _connectedPeers.clear();

    localRenderer.dispose();
    _localStream?.dispose();
    remoteRenderersController.close();
  }
}
