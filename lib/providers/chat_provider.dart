import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  TextEditingController? textEditingController;
  late CollectionReference chat;

  User? user;

  initChat() async {
    user = FirebaseAuth.instance.currentUser!;
    chat = FirebaseFirestore.instance
        .collection("room")
        .doc("kimia")
        .collection("chat");

    textEditingController = TextEditingController();
    notifyListeners();
  }
}
