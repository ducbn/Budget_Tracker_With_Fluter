import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thu_chi_ca_nhan/screens/dashboard.dart';
import 'package:thu_chi_ca_nhan/services/db.dart';

class AuthService{
  var db = Db();
  createUser(data, context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      await db.addUser(data, context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => Dashboard())),
      );
    }
    catch (e) {
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Sign up Failed"),
          content: Text(e.toString()),
        );
      });
    }
  }
  login(data, context) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data['email'],
          password: data ['password']);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => Dashboard())),
      );
    }
    catch(e){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Login Error "),
          content: Text(e.toString()),
        );
      });
    }
  }
}