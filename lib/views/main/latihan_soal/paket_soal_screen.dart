import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/models/paket_soal_list.dart';
import 'package:latihan_soal_app/repository/latihan_soal_api.dart';
import 'package:latihan_soal_app/views/main/latihan_soal/kerjakan_latihan_soal_screen.dart';

class PaketSoalScreen extends StatefulWidget {
  final String? id;

  const PaketSoalScreen({Key? key, this.id}) : super(key: key);

  @override
  State<PaketSoalScreen> createState() => _PaketSoalScreenState();
}

class _PaketSoalScreenState extends State<PaketSoalScreen> {
  PaketSoalList? paketSoalList;

  getPaketSoal() async {
    final mapelResult = await LatihanSoalAPI().getPaketSoal(widget.id);

    if (mapelResult.status == Status.success) {
      paketSoalList = PaketSoalList.fromJson(mapelResult.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getPaketSoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paket Soal'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                R.appSTRINGS.pilihPaketSoalText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Kalau pakai Grid, List view yang ada didalam sebuah widget harus di wrap pakai expanded
            Expanded(
              child: paketSoalList == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Center(
                        child: Wrap(
                          children: List.generate(
                            paketSoalList?.data?.length ?? 0,
                            (index) {
                              return GestureDetector(
                                onTap: () async {
                                  final data = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          KerjakanLatihanSoalScreen(
                                        id: paketSoalList!
                                            .data![index].exerciseId,
                                        title: paketSoalList!
                                            .data![index].exerciseTitle,
                                      ),
                                    ),
                                  );

                                  if (data == true) {
                                    getPaketSoal();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: PaketSoalWidget(
                                    data: paketSoalList!.data![index],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaketSoalWidget extends StatelessWidget {
  final PaketSoalData data;

  const PaketSoalWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              R.appASSETS.noteICON,
              width: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.exerciseTitle ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${data.jumlahDone}/${data.jumlahSoal} Paket Soal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 9,
              color: R.appCOLORS.greySubtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
