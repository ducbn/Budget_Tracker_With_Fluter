import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thu_chi_ca_nhan/widgets/category_list.dart';
import 'package:thu_chi_ca_nhan/widgets/tab_bar_view.dart';
import 'package:thu_chi_ca_nhan/widgets/time_line_month.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String monthYear = '';
  String category = 'All';

  @override
void initState(){
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      monthYear = DateFormat('MMM y').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thống kê"),
      ),
      body: Column(
        children: [
          TimeLineMonth(onChanged: (String? value) {
            if (value != null){
              setState(() {
                monthYear = value;
              });

            }
          },),
          CategoryList(onChanged: (String? value) {
            if(value != null){
              setState(() {
                category = value;
              });
            }
          },),
          TypeTabBar(
            category: category,
            monthYear: monthYear,),
        ],
      ),
    );
  }
}
