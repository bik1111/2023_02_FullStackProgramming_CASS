import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/models/cafe.dart';

class CafeItemWidget extends StatelessWidget {
  final Cafe cafe;
  final void Function()? onAddPressed;

  CafeItemWidget({Key? key, required this.cafe, this.onAddPressed, required Function(Map<String, dynamic> cafeData) onCafeSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          cafe.name ?? 'N/A',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주소: ${cafe.address ?? 'N/A'}'),
            Text('전화번호: ${cafe.number ?? 'N/A'}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: onAddPressed,
        ),
      ),
    );
  }
}
