import 'package:flutter/material.dart';

import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/views/main/latihan_soal/home_screen.dart';
import 'package:latihan_soal_app/views/main/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _pageController = PageController();

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, R.appRoutesTO.chatScreen);
        },
        child: Stack(
          children: [
            Positioned(
                top: 12,
                left: 7.5,
                child: Image.asset(R.appASSETS.discussICON, height: 45)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigation(context),
      // INI DIPAKE BIAR BISA 1 Page banyak tampilan
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }

  Container _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            // topLeft: Radius.circular(20),
            // topRight: Radius.circular(20),
            ),
        child: BottomAppBar(
          color: Colors.white,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                BottomNavigationMainMenuButton(
                  title: 'Home',
                  child: Image.asset(
                    index == 0
                        ? R.appASSETS.homeICON
                        : R.appASSETS.homeUnActiveICON,
                    height: 20,
                  ),
                  onTap: () {
                    index = 0;
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                    setState(() {});
                  },
                ),
                BottomNavigationMainMenuButton(
                    title: 'Diskusi',
                    onTap: () {
                      Navigator.pushNamed(context, R.appRoutesTO.chatScreen);
                    }),
                BottomNavigationMainMenuButton(
                  title: 'Profile',
                  child: Image.asset(
                    index == 1
                        ? R.appASSETS.profileICON
                        : R.appASSETS.profileUnActiveICON,
                    height: 20,
                  ),
                  onTap: () {
                    index = 1;
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavigationMainMenuButton extends StatelessWidget {
  final String title;
  final Widget? child;
  final Function()? onTap;

  const BottomNavigationMainMenuButton({
    Key? key,
    required this.title,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: child == null ? null : onTap,
            child: Column(
              children: [
                child ?? Container(height: 20),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
