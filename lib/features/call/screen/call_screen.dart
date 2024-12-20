import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_project_template/configs/agoraConfig.dart';
// import 'package:flutter_project_template/features/call/controller/call_controller.dart';
// import 'package:flutter_project_template/models/call.dart';
import 'package:provider/provider.dart';
import 'package:video_call/configs/agoraConfig.dart';
import 'package:video_call/features/call/controller/call_controller.dart';
import 'package:video_call/models/call.dart';

class CallScreen extends StatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;

  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'https://whatsapp-clone-rrr.herokuapp.com';

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      // agoraEventHandlers: RtcEngineEventHandler,
      // agoraEventHandlers: AgoraRtcEventHandlers(),
      // agoraRtmClientEventHandler: AgoraRtmClientEventHandler(),
      // agoraRtmChannelEventHandler: AgoraRtmChannelEventHandler(),

      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
    //  try {
    //   await client!.initialize();
    //   print("Agora initialized successfully");
    // } catch (e) {
    //   print("Failed to initialize Agora: $e");
    // }

  }

  @override
  Widget build(BuildContext context) {
    // Access CallController using Provider
    final callController = Provider.of<CallController>(context, listen: false);

    return Scaffold(
      body: client == null
          // ? const Loader()
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: IconButton(
                      onPressed: () async {
                        // Leave the Agora channel
                        await client!.engine.leaveChannel();

                        // End the call using the CallController
                        callController.endCall(
                          widget.call.callerId,
                          widget.call.receiverId,
                          context,
                        );

                        // Navigate back
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.call_end, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
