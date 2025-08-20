import 'package:flutter/material.dart';

Future<String?> showMyBottomSheet(BuildContext context, double height, Widget widget) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    builder: (context) {
      return SizedBox(
        height: height,
        child: widget,
      );
    },
  );
}
