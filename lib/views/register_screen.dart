import 'package:flutter/material.dart';

import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/widgets/gender_field_select.dart';
import 'package:latihan_soal_app/widgets/login_button.dart';
import 'package:latihan_soal_app/widgets/register_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

enum Gender { lakiLaki, perempuan }

class _RegisterScreenState extends State<RegisterScreen> {
  String gender = '';

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

  List<String> allClassSLTA = ['10', '11', '12'];

  String selectedClass = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController schoolController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                offset: const Offset(0, 0),
              )
            ],
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: LoginButton(
            backgroundColor: R.appCOLORS.primaryColor,
            borderColor: R.appCOLORS.primaryColor,
            child: Text(
              R.appSTRINGS.daftarText,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                R.appRoutesTO.mainScreen,
                (route) => false,
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              RegisterTextField(
                labelText: 'Email',
                hintText: 'contoh : hatchibee@email.com',
                controller: emailController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              RegisterTextField(
                labelText: 'Nama Lengkap',
                hintText: 'contoh : Hatchi Bee',
                controller: fullNameController,
                textInputAction: TextInputAction.next,
              ),
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
                    value: selectedClass == '' ? null : selectedClass,
                    items: allClassSLTA
                        .map(
                          (classSLTA) => DropdownMenuItem<String>(
                            value: classSLTA,
                            child: Text(classSLTA),
                          ),
                        )
                        .toList(),
                    onChanged: (newClassSLTA) {
                      setState(() {
                        selectedClass = newClassSLTA!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RegisterTextField(
                labelText: 'Nama Sekolah',
                hintText: 'nama sekolah',
                controller: schoolController,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
