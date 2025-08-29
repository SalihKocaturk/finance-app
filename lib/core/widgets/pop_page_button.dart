import 'package:flutter/material.dart';

class CustomAppbarButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  const CustomAppbarButton({super.key, this.icon = Icons.arrow_back, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(icon),
          color: Colors.black,
          onPressed: () {
            if (onTap != null) {
              onTap!();
            } else {
              Navigator.of(context).pop();
            }
          },
          padding: const EdgeInsets.all(4.0),
          iconSize: 23,
        ),
      ),
    );
  }
}
