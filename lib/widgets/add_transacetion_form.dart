import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thu_chi_ca_nhan/utils/appvaildator.dart';
import 'package:thu_chi_ca_nhan/widgets/category_dropdown.dart';
import 'package:uuid/uuid.dart';

class AddTransacetionForm extends StatefulWidget {
  const AddTransacetionForm({super.key});

  @override
  State<AddTransacetionForm> createState() => _AddTransacetionFormState();
}

class _AddTransacetionFormState extends State<AddTransacetionForm> {
  var type = "credit";
  var category = "Others";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appvalidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      var amount = int.parse(amountEditController.text);
      DateTime date = DateTime.now();

      var id = uid.v4();
      String monthyear = DateFormat('MMM y').format(date);
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      double remainingAmount = userDoc['remainingAmount'];
      double totalCredit = userDoc['totalCredit'];
      double totalDebit = userDoc['totalDebit'];
      // int remainingAmount = userDoc['remainingAmount'];
      // int totalCredit = userDoc['totalCredit'];
      // int totalDebit = userDoc['totalDebit'];


      if (type == 'credit') {
        remainingAmount += amount;
        totalCredit += amount;
      } else {
        remainingAmount -= amount;
        totalDebit += amount;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        "remainingAmount": remainingAmount,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "updatedAt": timestamp,
      });

      var data = {
        "id": id,
        "title": titleEditController.text,
        "amount": amount,
        "type": type,
        "timestamp": timestamp,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "remainingAmount": remainingAmount,
        "monthyear": monthyear,
        "category": category
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection("transactions").doc(id).set(data);
      Navigator.pop(context);
      //await authservice.login(data, context);
      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appvalidator.isEmptyCheck,
              decoration: InputDecoration(labelText: 'Tên'),
            ),
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appvalidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'số tiền'),
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
                value: 'credit',
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
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () {
                  if (isLoader == false) {
                    _submitForm();
                  }
                },
                child: isLoader
                    ? Center(child: CircularProgressIndicator())
                    : Text("Save"))
          ],
        ),
      ),
    );
  }
}
