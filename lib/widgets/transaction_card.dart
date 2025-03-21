import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:thu_chi_ca_nhan/utils/icons_list.dart';

class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.data,
  });

  final dynamic data;
  final appIcons = AppIcons(); // Đổi var -> final để tối ưu bộ nhớ

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    String formatedDate = DateFormat('d MMM hh:mma').format(date) ;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 10),
              color: Colors.grey,
              blurRadius: 10.0,
              spreadRadius: 4.0,
            )
          ],
        ),
        child: ListTile(
          minVerticalPadding: 12,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: data['type'] == 'credit'
                  ?Colors.green.withOpacity(0.2)
                  :Colors.red.withOpacity(0.2)
            ),
            child: Center(
              child: FaIcon(
                appIcons.getExpenseCategoryIcon('${data['category']}'),
                  color: data['type'] == 'credit'
                      ?Colors.green
                      :Colors.red
                // size: 20,
                // color: Colors.green.shade700,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  '${data['title']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                "${data['type'] == 'credit'? '+':'-'} \$${data['amount']}",
                style:  TextStyle(
                  color:
                  data['type'] == 'credit'
                      ?Colors.green
                      :Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Căn trái nội dung
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Balance",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    "\$ ${data['remainingAmount']}",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 4), // Tạo khoảng cách để đẹp hơn
               Text(
                formatedDate,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
