import 'package:flutter/material.dart';

import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/helpers/preference_helpers.dart';
import 'package:latihan_soal_app/helpers/user_helpers.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/models/user_by_email.dart';
import 'package:latihan_soal_app/providers/user_provider.dart';
import 'package:latihan_soal_app/repository/auth_api.dart';
import 'package:latihan_soal_app/widgets/gender_field_select.dart';
import 'package:latihan_soal_app/widgets/login_button.dart';
import 'package:latihan_soal_app/widgets/register_text_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

enum Gender { lakiLaki, perempuan }

class _RegisterScreenState extends State<RegisterScreen> {
  String? gender;

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

  List<String> allKelasSLTA = ['10', '11', '12'];

  String? selectedKelas;

  TextEditingController schoolNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  initDataUser() {
    emailController.text = UserHelpers.getUserEmail() ?? '';
    fullNameController.text = UserHelpers.getUserDisplayName() ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 50),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              blurRadius: 20,
              spreadRadius: 5,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 10),
            ),
          ]),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Yuk isi data diri',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          Consumer<UserProvider>(builder: (context, userProvider, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: LoginButton(
              backgroundColor: R.appCOLORS.primaryColor,
              borderColor: R.appCOLORS.primaryColor,
              child: Text(
                R.appSTRINGS.daftarText,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final jsonDataUser = {
                  'email': emailController.text,
                  'nama_lengkap': fullNameController.text,
                  'nama_sekolah': schoolNameController.text,
                  'kelas': selectedKelas,
                  'gender': gender,
                  'foto': UserHelpers.getUserPhotoURL(),
                };

                // Post data user ke API
                final result = await AuthAPI().postRegister(jsonDataUser);

                if (result.status == Status.success) {
                  // Cek apakah statusnya == 1 sesuai response API?
                  final registerResult =
                      UserByEmail.fromJson(result.data ?? {});

                  if (registerResult.status == 1) {
                    // Simpan ke local data user yang telah register
                    await PreferenceHelpers().setUserData(registerResult.data!);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      R.appRoutesTO.mainScreen,
                      (route) => false,
                    );
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
        );
      }),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Consumer<UserProvider>(builder: (context, userProvider, child) {
                return RegisterTextField(
                  enabled: false,
                  labelText: 'Email',
                  hintText: 'contoh : hatchibee@email.com',
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                );
              }),
              const SizedBox(height: 20),
              Consumer<UserProvider>(builder: (context, userProvider, child) {
                return RegisterTextField(
                  labelText: 'Nama Lengkap',
                  hintText: 'contoh : Hatchi Bee',
                  controller: fullNameController,
                  textInputAction: TextInputAction.next,
                );
              }),
              const SizedBox(height: 20),
              Text(
                'Jenis Kelamin',
                style: R.appTEXTSTLES.labelTextStyle,
              ),
              const SizedBox(height: 5),
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
              Text(
                'Kelas',
                style: R.appTEXTSTLES.labelTextStyle,
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: R.appCOLORS.greyBorderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: R.appCOLORS.blackLabelTextColor),
                    hint: Text(
                      'pilih kelas',
                      style: TextStyle(
                        color: R.appCOLORS.greyHintTextColor,
                      ),
                    ),
                    value: selectedKelas == '' ? null : selectedKelas,
                    items: allKelasSLTA
                        .map(
                          (classSLTA) => DropdownMenuItem<String>(
                            value: classSLTA,
                            child: Text(classSLTA),
                          ),
                        )
                        .toList(),
                    onChanged: (newClassSLTA) {
                      setState(() {
                        selectedKelas = newClassSLTA;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RegisterTextField(
                labelText: 'Nama Sekolah',
                hintText: 'nama sekolah',
                controller: schoolNameController,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
