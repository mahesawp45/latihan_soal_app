import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String? id;

  const ChatScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatProvider? chatProvider;

  final listViewController = ScrollController();

  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider!.initChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diskusi Soal'),
      ),
      body: Consumer<ChatProvider>(builder: (context, chatProvider, child) {
        return Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: chatProvider.chat
                    .orderBy('sent', descending: true)
                    .snapshots(),
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
                              height: 100,
                              width: 100,
                              color: R.appCOLORS.primaryColor,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _buildChatWidget(
                              currentChat, context, currentDate, chatProvider);
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
                                autofocus: false,
                                keyboardType: TextInputType.multiline,
                                controller: chatProvider.textEditingController,
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
                                      'chats/$room/${chatProvider.user?.uid}/${imgResult.name}';

                                  // Masukkan data/foto ke FirebaseStore
                                  final imgResUpload = await FirebaseStorage
                                      .instance
                                      .ref()
                                      .child(ref)
                                      .putFile(file);

                                  final url =
                                      await imgResUpload.ref.getDownloadURL();

                                  final chatContent = {
                                    'uid': chatProvider.user?.uid,
                                    'name':
                                        chatProvider.user?.displayName ?? '',
                                    'email': chatProvider.user?.email ?? '',
                                    'photoURL':
                                        chatProvider.user?.photoURL ?? '',
                                    'ref': ref,
                                    'type': 'file',
                                    'file_url': url,
                                    'content': chatProvider
                                        .textEditingController?.text,
                                    'sent': FieldValue.serverTimestamp(),
                                    'is_deleted': false,
                                  };

                                  chatProvider.chat
                                      .add(chatContent)
                                      .whenComplete(
                                    () {
                                      chatProvider.textEditingController
                                          ?.clear();
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
                          if (chatProvider
                              .textEditingController!.text.isEmpty) {
                            return;
                          }

                          final chatContent = {
                            'uid': chatProvider.user?.uid,
                            'name': chatProvider.user?.displayName ?? '',
                            'email': chatProvider.user?.email ?? '',
                            'photoURL': chatProvider.user?.photoURL ?? '',
                            'ref': null,
                            'type': 'text',
                            'file_url': null,
                            'content': chatProvider.textEditingController?.text,
                            'sent': FieldValue.serverTimestamp(),
                            'is_deleted': false,
                          };

                          // Masukkin data ke Firebase Store
                          // chat.add(chatContent).whenComplete(() {
                          //   getDataFromFirebase(); // Sementara untuk stream datanya bisa bgini
                          // });
                          // chat.add(chatContent).whenComplete(
                          //   () {
                          //     textEditingController.clear();
                          //   },
                          // );
                          chatProvider.textEditingController?.clear();
                          chatProvider.chat.add(chatContent);
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
        );
      }),
    );
  }

  GestureDetector _buildChatWidget(QueryDocumentSnapshot<Object?> currentChat,
      BuildContext context, DateTime? currentDate, ChatProvider? chatProvider) {
    return GestureDetector(
      // Untuk nampilin salin/hapus pesan
      onLongPress: () {
        currentChat['is_deleted']
            ? null
            : showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (currentChat['content'] != '')
                            ListTile(
                              title: const Text('Salin'),
                              onTap: () {
                                FlutterClipboard.copy(
                                        currentChat['content'] ?? '')
                                    .then((value) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(milliseconds: 800),
                                      content: Text('Text telah disalin!'),
                                    ),
                                  );
                                });
                              },
                            ),
                          if (chatProvider?.user?.uid == currentChat['uid'])
                            ListTile(
                              title: const Text('Hapus'),
                              onTap: () {
                                String id = currentChat.id;
                                chatProvider?.chat.doc(id).update({
                                  'is_deleted': true,
                                }).then(
                                  (value) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(milliseconds: 800),
                                        content:
                                            Text('Pesan berhasil dihapus!'),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 5,
          bottom: 10,
          right: chatProvider?.user?.uid == currentChat['uid'] ? 15 : 30,
          left: chatProvider?.user?.uid == currentChat['uid'] ? 30 : 15,
        ),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: chatProvider?.user?.uid == currentChat['uid']
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
            _buildBaloonChat(currentChat, chatProvider),
            _buildChatsTime(currentDate, chatProvider),
          ],
        ),
      ),
    );
  }

  Container _buildBaloonChat(
      QueryDocumentSnapshot<Object?> currentChat, ChatProvider? chatProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: currentChat['is_deleted']
          ? BoxDecoration(
              color: chatProvider?.user?.uid == currentChat['uid']
                  ? R.appCOLORS.primaryColor.withOpacity(0.2)
                  : Colors.pink.withOpacity(0.1),
              borderRadius: chatProvider?.user?.uid == currentChat['uid']
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
            )
          : BoxDecoration(
              color: chatProvider?.user?.uid == currentChat['uid']
                  ? R.appCOLORS.primaryColor
                  : Colors.pink.withOpacity(0.1),
              borderRadius: chatProvider?.user?.uid == currentChat['uid']
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
      child: currentChat['type'] == 'file' && currentChat['is_deleted'] == false
          ? _buildImageChat(currentChat, chatProvider)
          : _buildTextChat(currentChat, chatProvider),
    );
  }

  Text _buildChatsTime(DateTime? currentDate, ChatProvider? chatProvider) {
    // BARU BANGET
    if (currentDate == null) {
      return Text(
        'mengirim..',
        style: TextStyle(
          fontSize: 10,
          color: R.appCOLORS.greySubtitleColor,
        ),
      );

      // KEMARIN
    } else if (currentDate.day == (DateTime.now().day - 1) &&
        currentDate.month <= DateTime.now().month &&
        currentDate.year <= DateTime.now().year) {
      return Text(
        "Kemarin pada ${currentDate.hour}:${currentDate.minute}",
        style: TextStyle(
          fontSize: 10,
          color: R.appCOLORS.greySubtitleColor,
        ),
      );

      // SEKARANG
    } else if (currentDate.hour == DateTime.now().hour &&
        (DateTime.now().minute - (currentDate).minute) == 0) {
      return Text(
        'sekarang',
        style: TextStyle(
          fontSize: 10,
          color: R.appCOLORS.greySubtitleColor,
        ),
      );

      // 1 jam sebelum SEKARANG
    } else if (currentDate.hour == DateTime.now().hour &&
        currentDate.day == DateTime.now().day) {
      return Text(
        '${DateTime.now().minute - (currentDate).minute}m',
        style: TextStyle(
          fontSize: 10,
          color: R.appCOLORS.greySubtitleColor,
        ),
      );

      //
    } else if (currentDate.day < DateTime.now().day &&
        currentDate.day != DateTime.now().day - 2 &&
        currentDate.month <= (DateTime.now().month) &&
        currentDate.year <= DateTime.now().year) {
      return Text(
        DateFormat('dd MMM yyy, HH:mm').format(currentDate),
        style: TextStyle(
          fontSize: 10,
          color: R.appCOLORS.greySubtitleColor,
        ),
      );
    } else {
      return Text(
        "${currentDate.hour}:${currentDate.minute}",
        style: TextStyle(
          fontSize: 10,
          color: R.appCOLORS.greySubtitleColor,
        ),
      );
    }
  }

  Image _buildImageChat(
      QueryDocumentSnapshot<Object?> currentChat, ChatProvider? chatProvider) {
    return Image.network(
      currentChat['file_url'],
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.warning),
        );
      },
    );
  }

  Text _buildTextChat(
      QueryDocumentSnapshot<Object?> currentChat, ChatProvider? chatProvider) {
    return Text(
      currentChat['is_deleted']
          ? "Pesan telah dihapus"
          : currentChat['content'],
      style: currentChat['is_deleted']
          ? TextStyle(
              color: R.appCOLORS.greySubtitleColor,
              fontStyle: FontStyle.italic,
            )
          : TextStyle(
              color: chatProvider?.user?.uid == currentChat['uid']
                  ? Colors.white
                  : Colors.black,
            ),
    );
  }
}
