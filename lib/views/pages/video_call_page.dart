import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:temanternak/services/webrtc_service.dart';

class VideoCallPage extends StatefulWidget {
  final String token;
  final String consultationId;

  const VideoCallPage(
      {super.key, required this.token, required this.consultationId});

  @override
  State<VideoCallPage> createState() => VideoCallPageState();
}

class VideoCallPageState extends State<VideoCallPage> {
  bool isMicMuted = false;
  bool isVideoOff = false;
  bool isSpeakerOn = true;
  Duration callDuration = Duration.zero;
  late WebRTCService _webRTCService;
  final List<RTCVideoRenderer> _remoteRenderers = [];

  @override
  void initState() {
    super.initState();
    startCallTimer();
    _webRTCService = WebRTCService(
      token: widget.token,
      consultationId: widget.consultationId,
    );
    _webRTCService.initialize();
    _webRTCService.remoteRenderers.listen((renderer) {
      print('Remote renderer added');
      setState(() {
        _remoteRenderers.add(renderer);
      });
    }, onError: (error) => print('Error adding remote renderer: $error'));
  }

  void startCallTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          callDuration += const Duration(seconds: 1);
        });
        startCallTimer();
      }
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  void _handleEndCall() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF1F2C34),
            child: Center(
              child: isVideoOff
                  ? const Icon(
                      Icons.videocam_off,
                      size: 80,
                      color: Colors.white54,
                    )
                  : _remoteRenderers.isNotEmpty
                      ? RTCVideoView(_remoteRenderers.first)
                      : Container(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              NetworkImage('https://placeholder.com/50x50'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'John Doe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatDuration(callDuration),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        icon: isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                        onTap: () {
                          setState(() {
                            isSpeakerOn = !isSpeakerOn;
                          });
                        },
                      ),
                      const SizedBox(width: 24),
                      _buildControlButton(
                        icon: Icons.switch_camera_outlined,
                        onTap: () {
                          setState(() {
                            _webRTCService.switchCamera();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        icon: isVideoOff ? Icons.videocam_off : Icons.videocam,
                        onTap: () {
                          setState(() {
                            isVideoOff = !isVideoOff;
                            _webRTCService.toggleVideo();
                          });
                        },
                      ),
                      _buildControlButton(
                        icon: isMicMuted ? Icons.mic_off : Icons.mic,
                        onTap: () {
                          setState(() {
                            isMicMuted = !isMicMuted;
                            _webRTCService.toggleMute();
                          });
                        },
                      ),
                      _buildControlButton(
                        icon: Icons.call_end,
                        color: Colors.red,
                        onTap: _handleEndCall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!isVideoOff)
            Positioned(
              top: 100,
              right: 16,
              child: GestureDetector(
                onPanUpdate: (details) {},
                child: Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: RTCVideoView(_webRTCService.localRenderer),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color == Colors.white ? Colors.white.withOpacity(0.3) : color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _webRTCService.dispose();
    // for (var renderer in _remoteRenderers) {
    //   renderer.dispose();
    // }
    super.dispose();
  }
}
