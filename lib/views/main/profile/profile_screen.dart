import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(R.appSTRINGS.akunSayaText),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              R.appSTRINGS.editText,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      children: const [
                        Text(
                          'Nama User',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Nama Sekolah User',
                          style: TextStyle(
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
              margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 18),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 18),
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
                    content: 'Nama User',
                  ),
                  const SizedBox(height: 10),
                  _buildIdentitasUser(
                    title: 'Email',
                    content: 'Email User',
                  ),
                  const SizedBox(height: 10),
                  _buildIdentitasUser(
                    title: 'Jenis Kelamin',
                    content: 'Jenis Kelamin User',
                  ),
                  const SizedBox(height: 10),
                  _buildIdentitasUser(
                    title: 'Jenis Kelamin',
                    content: 'Jenis Kelamin User',
                  ),
                  const SizedBox(height: 10),
                  _buildIdentitasUser(
                    title: 'Kelas',
                    content: 'Kelas User',
                  ),
                  const SizedBox(height: 10),
                  _buildIdentitasUser(
                    title: 'Sekolah',
                    content: 'Sekolah User',
                  ),
                ],
              ),
            ),
            _buildLogoutButton(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Container _buildLogoutButton() {
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
        onTap: () {},
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
