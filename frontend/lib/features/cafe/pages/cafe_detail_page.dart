// cafe_detail_page.dart

import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/models/cafe.dart';

class CafeDetailPage extends StatelessWidget {
  final Cafe cafe;

  CafeDetailPage({required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cafe Name: ${cafe.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Address: ${cafe.address}'),
            SizedBox(height: 8),
            Text('Number: ${cafe.number}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
