import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'model_bottom_sheet.dart';

Future<String?> showLogoutBottomSheet(
  BuildContext context,
  VoidCallback onComfirmButtonTap,
  VoidCallback onCancelButtonTap,
  double height,
) {
  return showMyBottomSheet(
    context,
    height,
    Padding(
      padding: const EdgeInsetsGeometry.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/reminder.svg'),
          const Text(
            "Do You Want To Logout?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Gap(30),

          Row(
            children: [
              Expanded(
                //! burayı widgetlaştırmam lazım
                child: TextButton(
                  child: const Text(
                    "No",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  onPressed: () => onCancelButtonTap(),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 0,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Log out"),
                  onPressed: () => onComfirmButtonTap(),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
