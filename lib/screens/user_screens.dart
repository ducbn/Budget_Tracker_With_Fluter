import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreens extends StatelessWidget {
  const UserScreens({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy userId từ Firebase Auth để xác định người dùng
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin người dùng', style: TextStyle(fontSize: 24, color: Colors.white)), // Tăng kích thước chữ của title
        backgroundColor: Colors.blue.shade900,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // Lấy dữ liệu người dùng từ Firestore
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Không tìm thấy thông tin người dùng'));
          } else {
            // Lấy dữ liệu từ Firestore
            var userData = snapshot.data!;
            String username = userData['username'];
            String email = userData['email'];
            String phone = userData['phone'];
            double remainingAmount = (userData['remainingAmount'] as num).toDouble();
            double totalCredit = (userData['totalCredit'] as num).toDouble();
            double totalDebit = (userData['totalDebit'] as num).toDouble();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar người dùng
                    Center(
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.blue.shade900,
                        child: Icon(Icons.account_circle, size: 100, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Thông tin cá nhân
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.person, color: Colors.blue.shade900),
                              title: Text(
                                'Tên người dùng',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Tăng kích thước chữ
                              ),
                              subtitle: Text(username, style: TextStyle(fontSize: 16)), // Tăng kích thước chữ
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.email, color: Colors.blue.shade900),
                              title: Text(
                                'Email',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Tăng kích thước chữ
                              ),
                              subtitle: Text(email, style: TextStyle(fontSize: 16)), // Tăng kích thước chữ
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.phone, color: Colors.blue.shade900),
                              title: Text(
                                'Số điện thoại',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Tăng kích thước chữ
                              ),
                              subtitle: Text(phone, style: TextStyle(fontSize: 16)), // Tăng kích thước chữ
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Thông tin tài chính
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.account_balance_wallet, color: Colors.blue.shade900),
                              title: Text(
                                'Số dư còn lại',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Tăng kích thước chữ
                              ),
                              subtitle: Text('\$${remainingAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)), // Tăng kích thước chữ
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.attach_money, color: Colors.green),
                              title: Text(
                                'Tổng thu nhập',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Tăng kích thước chữ
                              ),
                              subtitle: Text('\$${totalCredit.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)), // Tăng kích thước chữ
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.remove, color: Colors.red),
                              title: Text(
                                'Tổng chi tiêu',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Tăng kích thước chữ
                              ),
                              subtitle: Text('\$${totalDebit.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)), // Tăng kích thước chữ
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
