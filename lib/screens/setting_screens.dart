import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingScreens extends StatefulWidget {
  const SettingScreens({super.key});

  @override
  _SettingScreensState createState() => _SettingScreensState();
}

class _SettingScreensState extends State<SettingScreens> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? _email;
  String? _phone;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            _email = user.email;
            _phone = userDoc['phone'];
            _username = userDoc['username'];
          });
        } else {
          _showErrorSnackBar('Không tìm thấy tài liệu người dùng.');
        }
      } catch (e) {
        _showErrorSnackBar('Lỗi khi tải dữ liệu người dùng: $e');
      }
    } else {
      _showErrorSnackBar('Không có người dùng hiện tại.');
    }
  }

  _updateEmail(String newEmail) async {
    try {
      User? user = _auth.currentUser;
      await user?.updateEmail(newEmail);
      await user?.reload();
      user = _auth.currentUser;
      setState(() {
        _email = user?.email;
      });
      _showSuccessSnackBar('Email đã được cập nhật thành công');
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        _showErrorSnackBar('Yêu cầu xác thực lại để thay đổi email.');
      } else {
        _showErrorSnackBar('Cập nhật email thất bại: $e');
      }
    }
  }

  _updatePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      await user?.updatePassword(newPassword);
      _showSuccessSnackBar('Mật khẩu đã được cập nhật thành công');
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        _showErrorSnackBar('Yêu cầu xác thực lại để thay đổi mật khẩu.');
      } else {
        _showErrorSnackBar('Cập nhật mật khẩu thất bại: $e');
      }
    }
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cài đặt tài khoản', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.blue.shade900),
                      title: Text('Thông tin cá nhân'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thông tin cá nhân'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Tên người dùng: $_username'),
                                  Text('Email: $_email'),
                                  Text('Số điện thoại: $_phone'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Đóng'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.blue.shade900),
                      title: Text('Đổi email'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showEmailDialog();
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.lock, color: Colors.blue.shade900),
                      title: Text('Đổi mật khẩu'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showPasswordDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  _showEmailDialog() {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đổi email'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email mới'),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                String newEmail = emailController.text;
                if (newEmail.isNotEmpty) {
                  _updateEmail(newEmail);
                  Navigator.pop(context);
                }
              },
              child: Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }

  _showPasswordDialog() {
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đổi mật khẩu'),
          content: TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Mật khẩu mới'),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                String newPassword = passwordController.text;
                if (newPassword.isNotEmpty) {
                  _updatePassword(newPassword);
                  Navigator.pop(context);
                }
              },
              child: Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }
}
