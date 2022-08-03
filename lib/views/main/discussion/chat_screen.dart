import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latihan_soal_app/constants/r.dart';

class ChatScreen extends StatefulWidget {
  final String? id;

  const ChatScreen({Key? key, this.id}) : super(key: key);

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

                    return currentChat == null
                        ? Container(
                            margin: const EdgeInsets.only(
                              bottom: 15,
                              right: 15,
                              left: 15,
                            ),
                            color: R.appCOLORS.primaryColor,
                          )
                        : Container(
                            margin: const EdgeInsets.only(
                                bottom: 15, right: 15, left: 30),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              crossAxisAlignment: user.uid == currentChat['uid']
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentChat['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xff5200ff),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: user.uid == currentChat['uid']
                                        ? R.appCOLORS.primaryColor
                                        : Colors.pink.withOpacity(0.1),
                                    borderRadius: user.uid == currentChat['uid']
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
                                  child: currentChat['type'] == 'file'
                                      ? Image.network(
                                          currentChat['file_url'],
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(Icons.warning),
                                            );
                                          },
                                        )
                                      : Text(
                                          currentChat['content'] ?? '',
                                          style: TextStyle(
                                            color:
                                                user.uid == currentChat['uid']
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                ),
                                Text(
                                  currentDate == null
                                      ? 'mengirim..'
                                      : currentDate.day ==
                                                  (DateTime.now().day - 1) &&
                                              currentDate.month <=
                                                  DateTime.now().month &&
                                              currentDate.year <=
                                                  DateTime.now().year
                                          ? "Kemarin pada ${currentDate.hour}:${currentDate.minute}" //Kemarin
                                          : currentDate.hour ==
                                                  DateTime.now().hour
                                              ? (DateTime.now().minute -
                                                          (currentDate)
                                                              .minute) ==
                                                      0
                                                  ? 'sekarang' // saat ini juga
                                                  : '${DateTime.now().minute - (currentDate).minute}m' // sebelum 1 jam hari ini
                                              : currentDate.day <=
                                                          (DateTime.now().day -
                                                              2) ||
                                                      currentDate.day !=
                                                              (DateTime.now()
                                                                      .day -
                                                                  2) &&
                                                          currentDate.month <=
                                                              (DateTime.now()
                                                                  .month) &&
                                                          currentDate.year <=
                                                              DateTime.now()
                                                                  .year
                                                  ? DateFormat(
                                                          'dd MMM yyy, HH:mm')
                                                      .format(
                                                          currentDate) // 2 hari atau lebih sebelum hari ini
                                                  : "${currentDate.hour}:${currentDate.minute}", // Hari ini
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
                            onTap: () async {
                              final imgResult = await ImagePicker().pickImage(
                                source: ImageSource.camera,
                                imageQuality: 30,
                                maxHeight: 500,
                                maxWidth: 500,
                              );

                              if (imgResult != null) {
                                // ubah data Xfile ke File biar bisa dikirim ke Firebase
                                File file = File(imgResult.path);

                                // ambil nama file di local
                                // final name = imgResult.path.split('/');

                                final room = widget.id ?? 'kimia';

                                final String ref =
                                    'chats/$room/${user.uid}/${imgResult.name}';

                                // Masukkan data/foto ke FirebaseStore
                                final imgResUpload = await FirebaseStorage
                                    .instance
                                    .ref()
                                    .child(ref)
                                    .putFile(file);

                                final url =
                                    await imgResUpload.ref.getDownloadURL();

                                final chatContent = {
                                  'uid': user.uid,
                                  'name': user.displayName ?? '',
                                  'email': user.email ?? '',
                                  'photoURL': user.photoURL ?? '',
                                  'ref': ref,
                                  'type': 'file',
                                  'file_url': url,
                                  'content': textEditingController.text,
                                  'sent': FieldValue.serverTimestamp(),
                                };

                                chat.add(chatContent).whenComplete(
                                  () {
                                    textEditingController.clear();
                                  },
                                );
                              }
                            },
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
                          'ref': null,
                          'type': 'text',
                          'file_url': null,
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
