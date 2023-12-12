// cafe_list_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cafe_list.dart';
import 'cafe_item_widget.dart';

class CafeListWidget extends StatelessWidget {
  final Function(Map<String, dynamic> cafeData) onCafeSelected;

  CafeListWidget({required this.onCafeSelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<CafeList>(
      builder: (context, cafeList, child) {
        if (cafeList.cafes.isNotEmpty) {
          // Show the list of cafes
          return ListView.builder(
            itemCount: cafeList.cafes.length,
            itemBuilder: (context, index) {
              return CafeItemWidget(
                cafe: cafeList.cafes[index],
                onCafeSelected: onCafeSelected,
              );
            },
          );
        } else {
          // Show a message when there are no cafes
          return Center(
            child: Text(
              'No cafes available. Add a new cafe!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }
      },
    );
  }
}


