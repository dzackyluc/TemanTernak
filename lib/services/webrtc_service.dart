import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  MediaStream? _localStream;
  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
    ]
  };

  Future<MediaStream> getUserMedia() async {
    final mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    return _localStream!;
  }

  Future<RTCPeerConnection> createPeerConnection(
      Map<String, dynamic> configuration) async {
    final configuration = _iceServers;
    final peerConnection = await createPeerConnection(configuration);

    peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      // Handle ICE candidate
    };

    peerConnection.onAddStream = (MediaStream stream) {
      // Handle remote stream
    };

    if (_localStream != null) {
      peerConnection.addStream(_localStream!);
    }

    return peerConnection;
  }
}
