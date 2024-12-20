import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_project_template/features/call/controller/call_controller.dart';
// import 'package:flutter_project_template/features/call/screen/call_screen.dart';
// import 'package:flutter_project_template/features/call/screens/call_screen.dart';
// import 'package:flutter_project_template/models/call.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_call/features/call/controller/call_controller.dart';
import 'package:video_call/models/call.dart';

class CallPickupScreen extends StatefulWidget {
  final Widget scaffold;
  const CallPickupScreen({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  State<CallPickupScreen> createState() => _CallPickupScreenState();
}

class _CallPickupScreenState extends State<CallPickupScreen> {
  @override
  void initState() {
    super.initState();
    // getUserId();
  }
  // getUserId() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var user = localStorage.getString("user");
  //   setState(() {
  //     user_id = jsonDecode(user!)['id'];
  //     username = jsonDecode(user)['username'];
  //     phoneNumber = jsonDecode(user)['phone'];
  //   });
  // }

  var user_id;
  var username;
  var phoneNumber;

  @override
  Widget build(BuildContext context) {
    // Access the CallController using Provider
    final callController = Provider.of<CallController>(context, listen: false);

    return StreamBuilder<DocumentSnapshot>(
      // stream: callController.callStream,

      stream: callController.callStream(user_id),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          Call call =
              Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialled) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 50),
                    CircleAvatar(
                      backgroundImage: NetworkImage(call.callerPic ?? "No pic"),
                      radius: 60,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      call.callerName,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 75),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            // End the call
                            callController.endCall(
                              call.callerId,
                              call.receiverId,
                              context,
                            );
                          },
                          icon: const Icon(
                            Icons.call_end,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {
                            // Accept the call and navigate to the CallScreen
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => CallScreen(
                            //       channelId: call.callId,
                            //       call: call,
                            //       isGroupChat: false,
                            //     ),
                            //   ),
                            // );
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return widget.scaffold;
      },
    );
  }
}
