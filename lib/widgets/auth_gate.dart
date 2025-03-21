import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thu_chi_ca_nhan/screens/dashboard.dart';
import 'package:thu_chi_ca_nhan/screens/login_screens.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
        return LoginView();
        }
        return Dashboard();
      }
    );
  }
}
