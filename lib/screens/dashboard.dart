import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thu_chi_ca_nhan/screens/home_screens.dart';
import 'package:thu_chi_ca_nhan/screens/login_screens.dart';
import 'package:thu_chi_ca_nhan/screens/setting_screens.dart';
import 'package:thu_chi_ca_nhan/screens/transaction_screen.dart';
import 'package:thu_chi_ca_nhan/screens/user_screens.dart';
import 'package:thu_chi_ca_nhan/widgets/navbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var isLogoutLoader = false;
  int currentIndext = 0;
  var pageViewList = [
    HomeScreens(),
    // AddScreens(),
    TransactionScreen(),
    UserScreens(),
    SettingScreens()

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(
        selectedIndex: currentIndext,
        onDestinationSelected: (int value) {
          setState(() {
            currentIndext = value;
          });
        },
      ),
      body: pageViewList[currentIndext],
    );
  }
}
