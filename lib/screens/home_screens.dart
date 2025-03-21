import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thu_chi_ca_nhan/screens/login_screens.dart';
import 'package:thu_chi_ca_nhan/widgets/add_transacetion_form.dart';
import 'package:thu_chi_ca_nhan/widgets/transactions_cards.dart';

import '../widgets/hero_card.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  var isLogoutLoader = false;
  String userName = ''; // Biến để lưu tên người dùng

  @override
  void initState() {
    super.initState();
    _getUserName(); // Lấy tên người dùng khi màn hình được tạo
  }

  // Lấy tên người dùng từ FirebaseAuth (email hoặc username tùy thuộc vào bạn đã lưu gì)
  _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;

    // Nếu người dùng đã đăng nhập
    if (user != null) {
      setState(() {
        userName = user.displayName ?? user.email?.split('@')[0] ?? 'users'; // Lấy tên người dùng hoặc phần email trước dấu "@"
      });
    }
  }

  logOut() async {
    setState(() {
      isLogoutLoader = true; // Cập nhật đúng trạng thái loading
    });
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: ((context) => LoginView())),
    );
    setState(() {
      isLogoutLoader = false;
    });
  }

  final userId = FirebaseAuth.instance.currentUser!.uid;

  _dialoBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: AddTransacetionForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: (() {
          _dialoBuilder(context);
        }),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(
          userName.isEmpty ? "Hello" : "Xin chào, $userName", // Hiển thị tên người dùng
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: isLogoutLoader
                ? CircularProgressIndicator()
                : Icon(Icons.exit_to_app),
            color: Colors.white,
            iconSize: 40,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroCard(userId: userId),
            TransactionsCard(),
            // RecentTransactionsList(),
          ],
        ),
      ),
    );
  }
}
