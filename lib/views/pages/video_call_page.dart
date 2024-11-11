import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sip_ua/sip_ua.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  VideoCallPageState createState() => VideoCallPageState();
}

class VideoCallPageState extends State<VideoCallPage>
    implements SipUaHelperListener {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final SIPUAHelper _sipHelper = SIPUAHelper();
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  Call? _currentCall;

  @override
  void initState() {
    super.initState();
    initializeRenderer();
    initializeSip();
    _initializeLocalMedia();
  }

  Future<void> initializeRenderer() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    setState(() {}); // Trigger a rebuild to reflect changes in UI
  }

  void initializeSip() {
    UaSettings settings = UaSettings();
    settings.webSocketUrl = 'ws://sip.temanternak.h14.my.id:9099/ws';
    settings.uri =
        'sip:hasan-ismail-abdulmalik-at_3o9xx@sip.temanternak.h14.my.id';
    settings.authorizationUser = 'hasan-ismail-abdulmalik-at_3o9xx';
    settings.password = 'Kbi86CxI';
    settings.displayName = 'hasan-ismail-abdulmalik-at_3o9xx';
    settings.userAgent = 'Dart SIP Client v0.1.0';
    settings.transportType = TransportType.WS;

    _sipHelper.start(settings);
    _sipHelper.addSipUaHelperListener(this);
  }

  Future<void> _initializeLocalMedia() async {
    try {
      // Get user media (camera and microphone)
      _localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': true,
      });
      setState(() {
        _localRenderer.srcObject = _localStream;
      }); // Rebuild to show the local video feed
    } catch (e) {
      print("Error initializing local media: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _localRenderer.srcObject != null
                ? RTCVideoView(
                    _localRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            child: _remoteRenderer.srcObject != null
                ? RTCVideoView(
                    _remoteRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    print('Registration State: ${state.state}');
    if (state.state == RegistrationStateEnum.REGISTERED) {
      Future.delayed(const Duration(seconds: 3), () {
        _makeCall();
      });
    }
  }

  void _makeCall() {
    const String targetUri = 'sip:budiarie@sip.temanternak.h14.my.id';
    _sipHelper.call(targetUri);
  }

  @override
  void callStateChanged(Call call, CallState state) async {
    _currentCall = call;

    switch (state.state) {
      case CallStateEnum.STREAM:
        var remoteStreams = call.peerConnection?.getRemoteStreams();
        if (remoteStreams != null && remoteStreams.isNotEmpty) {
          print('Remote stream found ${remoteStreams.first?.id}');
          setState(() {
            _remoteStream = remoteStreams.first;
            _remoteRenderer.srcObject = _remoteStream;
          });
          // call.peerConnection?.addStream(_localStream!);
          // call.peerConnection?.addTrack(_localStream!.getAudioTracks().first);
          if (_localStream != null) {
            for (var track in _localStream!.getTracks()) {
              call.peerConnection?.addTrack(track, _localStream!);
              print('Track added: ${track.kind}');
            }
          } else {
            print('Local stream is null');
          }
        }
        break;
      case CallStateEnum.ENDED:
        setState(() {
          _localRenderer.srcObject = null;
          _remoteRenderer.srcObject = null;
        });
        break;
      default:
        break;
    }
  }

  @override
  void transportStateChanged(TransportState state) {
    print('Transport State: ${state.state}');
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    print('New SIP MESSAGE: ${msg.request}');
  }

  @override
  void onNewNotify(Notify ntf) {
    print('New SIP NOTIFY: ${ntf.request}');
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _sipHelper.removeSipUaHelperListener(this);
    _sipHelper.stop();
    super.dispose();
  }

  @override
  void onNewReinvite(ReInvite event) {
    // TODO: implement onNewReinvite
  }
}
