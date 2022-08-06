import 'package:flutter/material.dart';

import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/helpers/preference_helpers.dart';
import 'package:latihan_soal_app/helpers/user_helpers.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/models/user_by_email.dart';
import 'package:latihan_soal_app/repository/auth_api.dart';
import 'package:latihan_soal_app/widgets/gender_field_select.dart';
import 'package:latihan_soal_app/widgets/login_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

enum Gender { lakiLaki, perempuan }

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> allKelasSLTA = ['10', '11', '12'];
  List<String> allGender = ['Laki-laki', 'Perempuan'];

  onTapGender(Gender genderInput) {
    switch (genderInput) {
      case Gender.lakiLaki:
        gender = 'Laki-laki';
        break;
      case Gender.perempuan:
        gender = 'Perempuan';
        break;
    }
    setState(() {});
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController schoolNameController = TextEditingController();
  String? gender;
  String? kelas;
  String? selectedKelas;

  UserData? user;

  initDataUser() async {
    user = await PreferenceHelpers().getUserData();

    if (user != null) {
      emailController.text = user!.userEmail!;
      fullNameController.text = user!.userName!;
      schoolNameController.text = user!.userAsalSekolah!;
      gender = user!.userGender!;
      kelas = user!.kelas!;
      setState(() {});
    }
  }

  @override
  void initState() {
    initDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: R.appCOLORS.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Akun',
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: LoginButton(
            radius: 8,
            backgroundColor: R.appCOLORS.primaryColor,
            borderColor: R.appCOLORS.primaryColor,
            child: Text(
              R.appSTRINGS.perbaharuiAkun,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              final jsonDataUser = {
                'email': emailController.text,
                'nama_lengkap': fullNameController.text,
                'nama_sekolah': schoolNameController.text,
                'gender': gender,
                'kelas': selectedKelas ?? kelas,
                'foto': UserHelpers.getUserPhotoURL(),
              };

              print(jsonDataUser);

              // Post data user ke API
              final result = await AuthAPI().postUpdateUser(jsonDataUser);

              if (result.status == Status.success) {
                // Cek apakah statusnya == 1 sesuai response API?
                final registerResult = UserByEmail.fromJson(result.data ?? {});

                if (registerResult.status == 1) {
                  // Simpan ke local data user yang telah register
                  await PreferenceHelpers().setUserData(registerResult.data!);

                  // diisi true biar bisa ditangkep data yg berubah disini ke page yg dituju
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        registerResult.message ?? '',
                      ),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      R.appSTRINGS.pesanErrorRegisText,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Diri',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildEditProfileTextField(
                      controller: fullNameController,
                      hintText: 'Nama Lengkap',
                      labelText: 'Nama Lengkap',
                    ),
                    _buildEditProfileTextField(
                      controller: emailController,
                      labelText: 'Email',
                      hintText: 'hatchibee@gmail.com',
                    ),
                    Row(
                      children: [
                        GenderFieldSelect(
                          gender: 'Laki-Laki',
                          onPressed: () {
                            onTapGender(Gender.lakiLaki);
                          },
                          bgColor: gender == 'Laki-laki'
                              ? R.appCOLORS.primaryColor
                              : Colors.white,
                          textColor: gender == 'Laki-laki'
                              ? Colors.white
                              : R.appCOLORS.blackLabelTextColor,
                        ),
                        GenderFieldSelect(
                          gender: 'Perempuan',
                          onPressed: () {
                            onTapGender(Gender.perempuan);
                          },
                          bgColor: gender == 'Perempuan'
                              ? Colors.pink.shade600
                              : Colors.white,
                          textColor: gender == 'Perempuan'
                              ? Colors.white
                              : R.appCOLORS.blackLabelTextColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDropDownForm(
                      labelText: 'Kelas',
                      data: allKelasSLTA,
                      value: kelas ?? '',
                    ),
                    const SizedBox(height: 20),
                    _buildEditProfileTextField(
                      controller: schoolNameController,
                      labelText: 'Sekolah',
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Column _buildDropDownForm({
    required String labelText,
    String? hintText,
    required List<String> data,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: R.appCOLORS.greyTextColor,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: const BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: Icon(Icons.keyboard_arrow_down,
                  color: R.appCOLORS.blackLabelTextColor),
              hint: Text(
                hintText ?? '',
                style: TextStyle(
                  color: R.appCOLORS.greyHintTextColor,
                ),
              ),
              value: selectedKelas ?? value,
              items: data
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedKelas = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _buildEditProfileTextField(
      {required String labelText,
      String? hintText,
      required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: R.appCOLORS.greyTextColor,
          ),
        ),
        TextField(
          controller: controller,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hintText,
            focusColor: R.appCOLORS.primaryColor,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
