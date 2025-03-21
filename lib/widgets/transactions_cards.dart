import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thu_chi_ca_nhan/widgets/category_dropdown.dart';
import 'package:thu_chi_ca_nhan/widgets/transaction_card.dart';

class TransactionsCard extends StatelessWidget {
  TransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Các giao dịch",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              )
            ],
          ),
          RecentTransactionsList()
        ],
      ),
    );
  }
}

class RecentTransactionsList extends StatefulWidget {
  RecentTransactionsList({super.key});

  @override
  _RecentTransactionsListState createState() =>
      _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("transactions")
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Đã xảy ra lỗi');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Đang tải...");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Không có giao dịch nào."));
        }

        var data = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var cardData = data[index];

            return Dismissible(
              key: Key(cardData.id),
              background: Container(
                color: Colors.blue,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.edit, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  _showEditDialog(context, cardData);
                  return false; // Không xóa khi sửa
                } else if (direction == DismissDirection.endToStart) {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Xóa giao dịch?"),
                        content: Text("Bạn có chắc muốn xóa giao dịch này không?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("Hủy"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("Xóa"),
                          ),
                        ],
                      );
                    },
                  );
                }
                return false;
              },
              onDismissed: (direction) async {
                double amount = (cardData['amount'] as num).toDouble(); // ✅ Chuyển đổi đúng
                String monthYear = cardData['monthyear'];

                // Lấy dữ liệu tổng tiền từ Firestore
                var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
                double remainingAmount = (userDoc['remainingAmount'] as num).toDouble(); // ✅ Chuyển đổi đúng
                double totalDebit = (userDoc['totalDebit'] as num).toDouble(); // ✅ Chuyển đổi đúng
                double totalCredit = (userDoc['totalCredit'] as num).toDouble(); // ✅ Chuyển đổi đúng

                // Xóa giao dịch trong Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection("transactions")
                    .doc(cardData.id)
                    .delete();

                // Cập nhật lại tổng số tiền (bao gồm cả totalCredit)
                if (cardData['type'] == 'credit') {
                  // Nếu là giao dịch Credit, trừ số tiền từ totalCredit và remainingAmount
                  await FirebaseFirestore.instance.collection('users').doc(userId).update({
                    'remainingAmount': remainingAmount - amount,
                    'totalCredit': totalCredit - amount, // Cập nhật lại totalCredit
                  });
                } else if (cardData['type'] == 'debit') {
                  // Nếu là giao dịch Debit, trừ số tiền từ totalDebit và remainingAmount
                  await FirebaseFirestore.instance.collection('users').doc(userId).update({
                    'remainingAmount': remainingAmount + amount,
                    'totalDebit': totalDebit - amount, // Cập nhật lại totalDebit
                  });
                }

                // Sau khi xóa, gọi lại setState() để làm mới UI
                setState(() {});
              },
              child: TransactionCard(data: cardData),
            );
          },
        );
      },
    );
  }

  // Hộp thoại chỉnh sửa giao dịch
  void _showEditDialog(BuildContext context, DocumentSnapshot cardData) {
    TextEditingController titleController = TextEditingController(text: cardData['title']);
    TextEditingController amountController = TextEditingController(text: cardData['amount'].toString());
    String category = cardData['category'];
    String type = cardData['type'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chỉnh sửa giao dịch"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Tên giao dịch"),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: "Số tiền"),
                keyboardType: TextInputType.number,
              ),
              CategoryDropdown(
                cattype: category,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                },
              ),
              DropdownButtonFormField(
                  value: type,
                  items: [
                    DropdownMenuItem(
                      child: Text('Thu nhập'),
                      value: 'credit',
                    ),
                    DropdownMenuItem(
                      child: Text('Chi tiêu'),
                      value: 'debit',
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        type = value;
                      });
                    }
                  }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                double newAmount = double.tryParse(amountController.text) ?? 0.0;
                double oldAmount = (cardData['amount'] as num).toDouble(); // ✅ Chuyển đổi đúng
                String monthYear = cardData['monthyear'];

                // Lấy dữ liệu tổng tiền
                var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
                double remainingAmount = (userDoc['remainingAmount'] as num).toDouble(); // ✅ Chuyển đổi đúng
                double totalDebit = (userDoc['totalDebit'] as num).toDouble(); // ✅ Chuyển đổi đúng
                double totalCredit = (userDoc['totalCredit'] as num).toDouble(); // ✅ Chuyển đổi đúng

                // Nếu loại giao dịch thay đổi (credit <-> debit)
                if (cardData['type'] == 'credit' && type == 'debit') {
                  // Chuyển từ credit sang debit, cập nhật tổng số tiền
                  await FirebaseFirestore.instance.collection('users').doc(userId).update({
                    'remainingAmount': remainingAmount - oldAmount - newAmount,
                    'totalCredit': totalCredit - oldAmount,
                    'totalDebit': totalDebit + newAmount,
                  });
                } else if (cardData['type'] == 'debit' && type == 'credit') {
                  // Chuyển từ debit sang credit, cập nhật tổng số tiền
                  await FirebaseFirestore.instance.collection('users').doc(userId).update({
                    'remainingAmount': remainingAmount + oldAmount + newAmount,
                    'totalDebit': totalDebit - oldAmount,
                    'totalCredit': totalCredit + newAmount,
                  });
                } else {
                  // Nếu loại giao dịch không thay đổi, chỉ cần cập nhật lại số tiền
                  await FirebaseFirestore.instance.collection('users').doc(userId).update({
                    'remainingAmount': remainingAmount - oldAmount + newAmount,
                    'totalDebit': totalDebit - oldAmount + newAmount,
                    'totalCredit': totalCredit - oldAmount + newAmount,
                  });
                }

                // Cập nhật giao dịch trong Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection("transactions")
                    .doc(cardData.id)
                    .update({
                  'title': titleController.text,
                  'amount': newAmount,
                  'category': category,
                  'type': type, // Cập nhật loại giao dịch
                });

                setState(() {}); // Cập nhật UI
                Navigator.pop(context); // Đóng hộp thoại
              },
              child: Text("Lưu"),
            ),
          ],
        );
      },
    );
  }
}
