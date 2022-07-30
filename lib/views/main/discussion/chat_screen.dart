import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();
  CollectionReference chat = FirebaseFirestore.instance
      .collection("room")
      .doc("kimia")
      .collection("chat");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diskusi Soal'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama User',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xff5200ff),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: const Text('Isi Pesan'),
                        ),
                        Text(
                          'Waktu kirim',
                          style: TextStyle(
                            fontSize: 10,
                            color: R.appCOLORS.greySubtitleColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0,
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0, -1),
                )
              ]),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: R.appCOLORS.greyColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      color: R.appCOLORS.primaryColor,
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: R.appCOLORS.greyColor,
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              controller: textEditingController,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(right: 10),
                                  border: InputBorder.none,
                                  hintText: 'Ketuk untuk menulis pesan..',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.camera_alt,
                              color: R.appCOLORS.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(
                      onPressed: () {
                        if (textEditingController.text.isEmpty) {
                          return;
                        }
                        final user = FirebaseAuth.instance.currentUser!;

                        final chatContent = {
                          'uid': user.uid,
                          'name': user.displayName ?? '',
                          'email': user.email ?? '',
                          'photoURL': user.photoURL ?? '',
                          'content': textEditingController.text,
                          'sent': FieldValue.serverTimestamp(),
                        };

                        // Masukkin data ke Firebase Store
                        chat.add(chatContent);

                        textEditingController.text = '';
                      },
                      icon: Icon(
                        Icons.send,
                        color: R.appCOLORS.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
