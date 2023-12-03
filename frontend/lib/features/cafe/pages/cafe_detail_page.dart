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
        child: _buildDetailCard(context),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailTile('Cafe Name', cafe.name),
          _buildDetailTile('Address', cafe.address),
          _buildDetailTile('Number', cafe.number),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
