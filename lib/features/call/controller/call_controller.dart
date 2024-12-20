import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart'; // Use provider package
import 'package:uuid/uuid.dart';
import 'package:video_call/features/call/repository/call_repository.dart';
import 'package:video_call/models/call.dart';

class CallController {
  final CallRepository callRepository;

  CallController({
    required this.callRepository,
  });

  Stream<DocumentSnapshot> callStream(String userId) => callRepository.callStream(userId);

  
  // Stream<DocumentSnapshot> callStream(String userId) {
  //   return FirebaseFirestore.instance
  //       .collection('calls')
  //       .doc(userId)
  //       .snapshots();
  // }

  void makeCall(
    BuildContext context,
    String receiverName,
    String receiverUid,
    String receiverProfilePic,
    String currentUserId,
    String currentUserName,
    String currentUserProfilePic,
    bool isGroupChat,
  ) {
    print("$receiverName, $receiverUid, $receiverProfilePic, $currentUserId, $currentUserName, $currentUserProfilePic, $isGroupChat");
    String callId = const Uuid().v1();

    Call senderCallData = Call(
      callerId: currentUserId,
      callerName: currentUserName,
      callerPic: currentUserProfilePic,
      receiverId: receiverUid,
      receiverName: receiverName,
      receiverPic: receiverProfilePic,
      callId: callId,
      hasDialled: true,
    );

    Call receiverCallData = Call(
      callerId: currentUserId,
      callerName: currentUserName,
      callerPic: currentUserProfilePic,
      receiverId: receiverUid,
      receiverName: receiverName,
      receiverPic: receiverProfilePic,
      callId: callId,
      hasDialled: false,
    );

    if (isGroupChat) {
      // Implement group call logic if needed
    } else {
      callRepository.makeCall(senderCallData, context, receiverCallData);
    }
  }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) {
    callRepository.endCall(callerId, receiverId, context);
  }
}

final callControllerProvider = Provider<CallController>(create: (context) {
  final callRepository = Provider.of<CallRepository>(context, listen: false);
  return CallController(callRepository: callRepository);
});
