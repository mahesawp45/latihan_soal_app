import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProvider? userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider!.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(R.appSTRINGS.akunSayaText),
        actions: [
          TextButton(
            onPressed: () async {
              final data = await Navigator.pushNamed(
                  context, R.appRoutesTO.editProfileScreen);

              if (data == true) {
                userProvider!.getUserData();
              }
            },
            child: Text(
              R.appSTRINGS.editText,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: userProvider?.user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 60, top: 28, left: 15, right: 15),
                      decoration: BoxDecoration(
                        color: R.appCOLORS.primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(9),
                          bottomRight: Radius.circular(9),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProvider.user!.userName!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  userProvider.user!.userAsalSekolah!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            R.appASSETS.avatarICON,
                            height: 50,
                            width: 50,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 18),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            color: Colors.black.withOpacity(0.25),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            R.appSTRINGS.identitasDiriText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildIdentitasUser(
                            title: 'Nama Lengkap',
                            content: userProvider.user!.userName!,
                          ),
                          const SizedBox(height: 10),
                          _buildIdentitasUser(
                            title: 'Email',
                            content: userProvider.user!.userEmail!,
                          ),
                          const SizedBox(height: 10),
                          _buildIdentitasUser(
                            title: 'Jenis Kelamin',
                            content: userProvider.user!.userGender!,
                          ),
                          const SizedBox(height: 10),
                          _buildIdentitasUser(
                            title: 'Kelas',
                            content: userProvider.user!.kelas!,
                          ),
                          const SizedBox(height: 10),
                          _buildIdentitasUser(
                            title: 'Sekolah',
                            content: userProvider.user!.userAsalSekolah!,
                          ),
                        ],
                      ),
                    ),
                    _buildLogoutButton(context),
                    const SizedBox(height: 50),
                  ],
                );
              }),
            ),
    );
  }

  Container _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 7,
            color: Colors.black.withOpacity(0.25),
          )
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () async {
          // INI otomatis terlogout tanpa harus hapus apa" di local kaya sharedpreferences
          if (kIsWeb) {
            await GoogleSignIn(
              clientId:
                  "405198497194-dbu3ae5capuc8v6dd1446g4dekde0ud9.apps.googleusercontent.com",
              scopes: [
                'email',
                'https://www.googleapis.com/auth/contacts.readonly',
              ],
            ).signOut();
          } else {
            // ini Native
            await GoogleSignIn().signOut();
          }

          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil(
            R.appRoutesTO.loginScreen,
            (route) => false,
          );
        },
        title: Row(
          children: [
            Image.asset(
              R.appASSETS.logoutICON,
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 8),
            Text(
              R.appSTRINGS.keluarText,
              style: const TextStyle(
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _buildIdentitasUser({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: R.appCOLORS.greySubtitleColor,
            fontSize: 12,
          ),
        ),
        Text(
          content,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
