import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/widgets/mapel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHomeUserProfile(),
              _buildHomeTopBanner(context),
              _buildHomeListMapel(),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        R.appSTRINGS.terbaruText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < 4) {
                            return Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Image.asset(R.appASSETS.homeBannerICON),
                            );
                          } else {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Image.asset(R.appASSETS.homeBannerICON),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildHomeListMapel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 21),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                R.appSTRINGS.pilihPelajaranText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, R.appRoutesTO.mapelScreen);
                },
                child: Text(
                  R.appSTRINGS.lihatSemuaText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: R.appCOLORS.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const MapelWidget(),
          const MapelWidget(),
          const MapelWidget(),
        ],
      ),
    );
  }

  Container _buildHomeTopBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 147,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: R.appCOLORS.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.55,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Text(
              textAlign: TextAlign.start,
              R.appSTRINGS.homeTopBannerText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              R.appASSETS.homeTopBannerICON,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildHomeUserProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Halo Nama User',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Selamat Datang',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            R.appASSETS.avatarICON,
            height: 35,
            width: 35,
          ),
        ],
      ),
    );
  }
}
