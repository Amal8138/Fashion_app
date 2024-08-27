import 'package:flutter/material.dart';
Widget buildProfileField(String label, String value, {bool multiline = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
}

Widget productDetails(String value , Color giveClr) {
  return Text(value,
  style:   TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: giveClr,
    overflow: TextOverflow.ellipsis
  ),
  );
}