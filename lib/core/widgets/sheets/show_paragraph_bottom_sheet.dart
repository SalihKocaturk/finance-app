import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'model_bottom_sheet.dart';

Future<String?> showParagraphBottomSheet(
  BuildContext context, {
  required String title,
  required String content,

  double? height,
}) {
  final h = height ?? MediaQuery.of(context).size.height * 0.8;

  return showMyBottomSheet(
    context,
    h,
    SafeArea(
      child: Column(
        children: [
          const Gap(3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SelectableText(
                content,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
