import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      indicatorColor: Colors.blue.shade900,
      height: 80,
      destinations: <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home, size: 40),
          selectedIcon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore, size: 40),
          selectedIcon: Icon(Icons.explore, color: Colors.white),
          label: 'Transaction',
        ),
        NavigationDestination(
            icon: Icon(Icons.account_circle, size: 40,),
            selectedIcon: Icon(Icons.account_circle, color: Colors.white),
            label: 'User'),
        NavigationDestination(
            icon: Icon(Icons.settings, size: 40,),
            selectedIcon: Icon(Icons.settings, color: Colors.white),
            label: 'User'),
      ],
    );
  }
}
