import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latihan_soal_app/constants/r.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();
  late CollectionReference chat;
  final user = FirebaseAuth.instance.currentUser!;
  final listViewController = ScrollController();

  @override
  void initState() {
    chat = FirebaseFirestore.instance
        .collection("room")
        .doc("kimia")
        .collection("chat");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diskusi Soal'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chat.orderBy('sent', descending: true).snapshots(),
              builder:
                  (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final listChat = snapshot.data?.docs;
                return ListView.builder(
                  reverse: true,
                  controller: listViewController,
                  itemCount: listChat?.length ?? 0,
                  itemBuilder: (context, index) {
                    final currentChat = snapshot.data?.docs[index];
                    final currentDate =
                        (currentChat?['sent'] as Timestamp?)?.toDate();

                    return Container(
                      margin: user.uid == currentChat?['uid']
                          ? const EdgeInsets.only(bottom: 15, right: 15)
                          : const EdgeInsets.only(bottom: 15, left: 15),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: user.uid == currentChat?['uid']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentChat?['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xff5200ff),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: user.uid == currentChat?['uid']
                                  ? R.appCOLORS.primaryColor
                                  : Colors.pink.withOpacity(0.1),
                              borderRadius: user.uid == currentChat?['uid']
                                  ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    )
                                  : const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                            ),
                            child: Text(
                              currentChat?['content'] ?? '',
                              style: TextStyle(
                                color: user.uid == currentChat?['uid']
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            currentDate?.day == (DateTime.now().day - 1)
                                ? "Yesterday at ${currentDate?.hour ?? ''}:${currentDate?.minute ?? ''}" //Kemarin
                                : currentDate?.hour == DateTime.now().hour
                                    ? (DateTime.now().minute -
                                                (currentDate ?? DateTime.now())
                                                    .minute) ==
                                            0
                                        ? 'now' // saat ini juga
                                        : '${DateTime.now().minute - (currentDate ?? DateTime.now()).minute}m' // sebelum 1 jam hari ini
                                    : currentDate?.day !=
                                                (DateTime.now().day - 1) &&
                                            currentDate?.month !=
                                                (DateTime.now().month)
                                        ? DateFormat('dd MMM yyy, HH:mm')
                                            .format(currentDate ??
                                                DateTime
                                                    .now()) // 2 hari sebelum hari ini
                                        : "${currentDate?.hour ?? ''}:${currentDate?.minute ?? ''}", // Hari ini
                            style: TextStyle(
                              fontSize: 10,
                              color: R.appCOLORS.greySubtitleColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
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
                              cursorColor: R.appCOLORS.primaryColor,
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

                        final chatContent = {
                          'uid': user.uid,
                          'name': user.displayName ?? '',
                          'email': user.email ?? '',
                          'photoURL': user.photoURL ?? '',
                          'content': textEditingController.text,
                          'sent': FieldValue.serverTimestamp(),
                        };

                        // Masukkin data ke Firebase Store
                        // chat.add(chatContent).whenComplete(() {
                        //   getDataFromFirebase(); // Sementara untuk stream datanya bisa bgini
                        // });
                        chat.add(chatContent).whenComplete(
                          () {
                            textEditingController.clear();
                          },
                        );
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
