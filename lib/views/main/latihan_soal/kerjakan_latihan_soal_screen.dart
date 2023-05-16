import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/helpers/user_helpers.dart';
import 'package:latihan_soal_app/models/kerjakan_soal_list.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/providers/kerjakan_soal_list_provider.dart';
import 'package:latihan_soal_app/repository/latihan_soal_api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:latihan_soal_app/views/main/latihan_soal/result_screen.dart';
import 'package:provider/provider.dart';

class KerjakanLatihanSoalScreen extends StatefulWidget {
  final String? id;
  final String? title;
  const KerjakanLatihanSoalScreen({Key? key, this.id, this.title})
      : super(key: key);

  @override
  State<KerjakanLatihanSoalScreen> createState() =>
      _KerjakanLatihanSoalScreenState();
}

class _KerjakanLatihanSoalScreenState extends State<KerjakanLatihanSoalScreen>
    with SingleTickerProviderStateMixin {
  KerjakanSoalListProvider? kerjakanSoalListProvider;

  // instansiasi tabController wkt pemanggilan API berhasil krn harus dapat data length
  TabController? _controller;

  initTab() {
    _controller = TabController(
        length: kerjakanSoalListProvider?.kerjakanSoalList?.data?.length ?? 10,
        vsync: this);
    //Tambahkan SingleTickerProviderStateMixin

    // setStatenya disini biar tombol selanjutnya ganti jadi kumpulin maksudnya biar ada perubahan layar krn tabbar ini dijalanin
    _controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    kerjakanSoalListProvider =
        Provider.of<KerjakanSoalListProvider>(context, listen: false);
    kerjakanSoalListProvider!.getDaftarSoalList(widget.id);
    initTab();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KerjakanSoalListProvider>(
        builder: (context, kerjakanSoalListProvider, child) {
      print('Ini apa => ${kerjakanSoalListProvider.kerjakanSoalList?.data}');
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? 'Tunggu..'),
        ),
        // Tombol selanjutnya atau submit
        bottomNavigationBar: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                kerjakanSoalListProvider.kerjakanSoalList != null
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: R.appCOLORS.primaryColor,
                          fixedSize: const Size(153, 33),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (_controller!.index ==
                              kerjakanSoalListProvider
                                      .kerjakanSoalList!.data!.length -
                                  1) {
                            // Masukkan ke variable biar dapet true/false
                            final result = await showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                // INI HARUS dijadikan Statefull biar pas modif bisa langsung
                                return const BottomSheetConfirm();
                              },
                            );

                            // Kirim semua jawaban latihan soal ke Backend
                            if (result == true) {
                              List<String> answers = [];
                              List<String> questionId = [];

                              // masukan semua data ke data berbentuk array/list
                              for (var element in kerjakanSoalListProvider
                                  .kerjakanSoalList!.data!) {
                                answers.add(element.studentAnswer!);
                                questionId.add(element.bankQuestionId!);
                              }

                              final payload = {
                                'user_email': UserHelpers.getUserEmail(),
                                'exercise_id': widget.id,
                                'bank_question_id': questionId,
                                'student_answer': answers,
                              };

                              print(payload);
                              final finalResult = await LatihanSoalAPI()
                                  .postInputJawaban(payload);

                              if (finalResult.status == Status.success) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ResultScreen(
                                        id: widget.id,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Submit gagal. Silahkan ulangi submit!"),
                                  ),
                                );
                              }
                            }
                          } else {
                            _controller!.animateTo(_controller!.index + 1);
                          }
                        },
                        child: Text(
                          _controller!.index ==
                                  kerjakanSoalListProvider
                                          .kerjakanSoalList!.data!.length -
                                      1
                              ? 'Kumpulin'
                              : 'Selanjutnya',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        body: kerjakanSoalListProvider.kerjakanSoalList == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  // TabBar UNTUK NOMOR
                  _buildTabNumber(kerjakanSoalListProvider),

                  // tabBar VIEW SOAL
                  _buildTabContent(kerjakanSoalListProvider),
                ],
              ),
      );
    });
  }

  Expanded _buildTabContent(KerjakanSoalListProvider kerjakanSoalListProvider) {
    return Expanded(
      child: Container(
        child: TabBarView(
          controller: _controller,
          children: List.generate(
            kerjakanSoalListProvider.kerjakanSoalList!.data!.length,
            (index) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nomor soal
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Soal nomor ${index + 1}',
                      style: TextStyle(
                        color: R.appCOLORS.greySubtitleColor,
                      ),
                    ),
                  ),

                  // Soal
                  if (kerjakanSoalListProvider
                          .kerjakanSoalList!.data![index].questionTitle !=
                      null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Html(
                        data: kerjakanSoalListProvider
                            .kerjakanSoalList!.data![index].questionTitle!,
                        style: {
                          'body': Style(
                            padding: EdgeInsets.zero,
                            fontSize: FontSize(12),
                          )
                        },
                      ),
                    ),
                  if (kerjakanSoalListProvider
                          .kerjakanSoalList?.data?[index].questionTitleImg !=
                      null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(kerjakanSoalListProvider
                          .kerjakanSoalList!.data![index].questionTitleImg!),
                    ),

                  // Opsi jawaban
                  _buildOptions(
                    kerjakanSoalList:
                        kerjakanSoalListProvider.kerjakanSoalList!,
                    index: index,
                    option: 'A',
                    answere: kerjakanSoalListProvider
                        .kerjakanSoalList!.data![index].optionA,
                    answereImg: kerjakanSoalListProvider
                        .kerjakanSoalList!.data![index].optionAImg,
                  ),
                  _buildOptions(
                    kerjakanSoalList:
                        kerjakanSoalListProvider.kerjakanSoalList!,
                    index: index,
                    option: 'B',
                    answere: kerjakanSoalListProvider
                        .kerjakanSoalList!.data![index].optionB,
                    answereImg: kerjakanSoalListProvider
                        .kerjakanSoalList!.data![index].optionBImg,
                  ),
                  _buildOptions(
                    kerjakanSoalList:
                        kerjakanSoalListProvider.kerjakanSoalList!,
                    index: index,
                    option: 'C',
                    answere: kerjakanSoalListProvider
                        .kerjakanSoalList!.data![index].optionC,
                    answereImg: kerjakanSoalListProvider
                        .kerjakanSoalList!.data![index].optionCImg,
                  ),
                  _buildOptions(
                    kerjakanSoalList:
                        kerjakanSoalListProvider.kerjakanSoalList!,
                    index: index,
                    option: 'D',
                    answere: kerjakanSoalListProvider
                        .kerjakanSoalList!.data![index].optionD,
                    answereImg: kerjakanSoalListProvider
                        .kerjakanSoalList!.data![index].optionDImg,
                  ),
                  _buildOptions(
                    kerjakanSoalList:
                        kerjakanSoalListProvider.kerjakanSoalList!,
                    index: index,
                    option: 'E',
                    answere: kerjakanSoalListProvider
                        .kerjakanSoalList!.data![index].optionE,
                    answereImg: kerjakanSoalListProvider
                        .kerjakanSoalList!.data![index].optionEImg,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildTabNumber(KerjakanSoalListProvider kerjakanSoalListProvider) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      child: TabBar(
        onTap: (value) {},
        controller: _controller,
        isScrollable: true,
        indicator: BoxDecoration(
            border: Border.all(color: R.appCOLORS.primaryColor, width: 1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(100)),
        labelColor: R.appCOLORS.primaryColor,
        unselectedLabelColor: Colors.black,
        tabs: List.generate(
          kerjakanSoalListProvider.kerjakanSoalList?.data?.length ?? 0,
          (index) => Tab(
            text: '${index + 1}',
          ),
        ),
      ),
    );
  }

  Container _buildOptions({
    required String option,
    required index,
    String? answere,
    String? answereImg,
    required KerjakanSoalList kerjakanSoalList,
  }) {
    final answereChecked =
        kerjakanSoalList.data![index].studentAnswer == option;

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: answereChecked
            ? R.appCOLORS.primaryColor.withOpacity(0.5)
            : Colors.transparent,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            kerjakanSoalList.data![index].studentAnswer = option;
          });
        },
        child: Row(
          children: [
            Text(
              '$option.',
              style: TextStyle(
                color: answereChecked ? Colors.white : Colors.black,
              ),
            ),
            Expanded(
              child: answere == null
                  ? Container()
                  : Html(
                      data: answere,
                      style: {
                        'p': Style(
                          color: answereChecked ? Colors.white : Colors.black,
                        ),
                      },
                    ),
            ),
            answereImg == null
                ? Container()
                : Expanded(
                    child: Image.network(answereImg),
                  ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetConfirm extends StatefulWidget {
  const BottomSheetConfirm({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetConfirm> createState() => _BottomSheetConfirmState();
}

class _BottomSheetConfirmState extends State<BottomSheetConfirm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        // ini buat atur ketinggian modal bottom sheetnya
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 5,
            decoration: BoxDecoration(
              color: R.appCOLORS.greySubtitleColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 15),
          Image.asset(R.appASSETS.successICON),
          const Text(
            'Kumpulkan latihan soal sekarang?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Boleh langsung kumpulin dong',
            style: TextStyle(
              color: R.appCOLORS.greySubtitleColor,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // cancel -> data false/true ini harus diisi biar bisa ditangkep showBottomModal nya
                    Navigator.pop(context, false);
                  },
                  child: const Text('Nanti Dulu'),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // no cancel
                    Navigator.pop(context, true);
                  },
                  child: const Text('Ya'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
