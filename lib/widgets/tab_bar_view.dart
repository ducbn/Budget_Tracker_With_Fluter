import 'package:flutter/material.dart';
import 'package:thu_chi_ca_nhan/widgets/transaction_list.dart';

class TypeTabBar extends StatelessWidget {
  const TypeTabBar({super.key, required this.category, required this.monthYear});
  final String category;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: "Thu nhập"),
                Tab(text: "Chi tiêu"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TransactionList(
                    category: category, // Truy cập widget.category
                    monthYear: monthYear, // Truy cập widget.monthYear
                    type: 'credit',
                  ),
                  TransactionList(
                    category: category,
                    monthYear: monthYear,
                    type: 'debit',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
