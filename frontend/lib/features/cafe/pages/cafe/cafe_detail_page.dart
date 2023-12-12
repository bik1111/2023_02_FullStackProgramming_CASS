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
      body: _buildDetailListView(context),
    );
  }

  Widget _buildDetailListView(BuildContext context) {
    return ListView(
      children: [
        Image.asset('assets/jpg/cafe.jpg', height: 300), // Use custom image as a header
        _buildDetailTile(context, Icons.local_cafe, '카페 명', cafe.name),
        _buildDetailTile(context, Icons.location_on, '주소', cafe.address),
        _buildDetailTile(context, Icons.phone, '연락처', cafe.number),
      ],
    );
  }

  Widget _buildDetailTile(BuildContext context, IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.green), // Set the color to green
      title: Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: TextStyle(fontSize: 16)),
    );
  }
}
