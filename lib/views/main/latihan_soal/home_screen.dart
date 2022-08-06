import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/helpers/preference_helpers.dart';
import 'package:latihan_soal_app/models/banner_list.dart';
import 'package:latihan_soal_app/models/mapel_list.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/models/user_by_email.dart';
import 'package:latihan_soal_app/repository/latihan_soal_api.dart';
import 'package:latihan_soal_app/views/main/latihan_soal/paket_soal_screen.dart';
import 'package:latihan_soal_app/widgets/mapel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapelList? mapelList;
  BannerList? bannerList;

  getMapel() async {
    final mapelResult = await LatihanSoalAPI().getMapel();

    if (mapelResult.status == Status.success) {
      mapelList = MapelList.fromJson(mapelResult.data!);
      setState(() {});
    }
  }

  getBanner() async {
    final bannerResult = await LatihanSoalAPI().getBanner();

    if (bannerResult.status == Status.success) {
      bannerList = BannerList.fromJson(bannerResult.data!);
      setState(() {});
    }
  }

  setUpFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // Get token untuk test FCM
    final tokenFcm = await FirebaseMessaging.instance.getToken();

    print(tokenFcm);

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  UserData? user;

  getUserData() async {
    user = await PreferenceHelpers().getUserData();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getMapel();
    getBanner();
    setUpFCM();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHomeUserProfile(),
              _buildHomeTopBanner(context),
              _buildHomeListMapel(mapelList),
              SizedBox(
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
                    bannerList == null
                        ? const SizedBox(
                            height: 70,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(bottom: 100),
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: bannerList?.data?.length ?? 4,
                              itemBuilder: (BuildContext context, int index) {
                                final currentBanner = bannerList!.data![index];

                                if (index <
                                    ((bannerList?.data?.length ?? 4) - 1)) {
                                  return Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                          currentBanner.eventImage ?? ''),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                          currentBanner.eventImage ?? ''),
                                    ),
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

  Container _buildHomeListMapel(MapelList? mapelList) {
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
                  Navigator.pushNamed(
                    context,
                    R.appRoutesTO.mapelScreen,
                    arguments: mapelList!.data,
                  );
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
          mapelList == null
              ? const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  //ini Kalau Listview Column harus di isi shrinkWrap true, physic biar engga error krn ScrollView/Listview
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      mapelList.data!.length > 3 ? 3 : mapelList.data!.length,
                  itemBuilder: (context, index) {
                    final currentMapel = mapelList.data![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaketSoalScreen(id: currentMapel.courseId),
                          ),
                        );
                      },
                      child: MapelWidget(
                        totalDone: currentMapel.jumlahDone ?? 0,
                        totalPacket: currentMapel.jumlahMateri ?? 0,
                        title: currentMapel.courseName ?? '',
                      ),
                    );
                  })
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
              children: [
                Text(
                  'Halo ${user!.userName ?? ""}👋',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
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
