import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../custom_button.dart';
import 'model_bottom_sheet.dart';

Future<void> showImagePickerSheet(
  BuildContext context,
  bool isImageAdded,
  double height, {
  required VoidCallback onDelete,
  required VoidCallback onPick,
  required VoidCallback onGallery,
  required VoidCallback onCamera,
}) {
  return showMyBottomSheet(
    context,
    height,
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              color: isImageAdded ? Colors.red : Colors.blue,
              icon: isImageAdded ? Icons.delete : Icons.photo_library,
              text: isImageAdded ? 'Delete image' : 'Pick image from gallery',
              onTap: isImageAdded ? onDelete : onGallery,
            ),
          ),
          const Gap(12),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              color: isImageAdded ? Colors.blue : Colors.blue,
              icon: isImageAdded ? Icons.add_photo_alternate : Icons.photo_camera,
              text: isImageAdded ? 'Pick image' : 'Pick image from camera',
              onTap: isImageAdded ? onPick : onCamera,
            ),
          ),
        ],
      ),
    ),
  );
}
