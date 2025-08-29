import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final int? count;
  final Color bg;
  final VoidCallback? onTap;

  const ActionCard({
    super.key,
    required this.title,
    this.icon,
    this.count,
    required this.bg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg.withAlpha(30),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            icon != null
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white),
                  )
                : Text(
                    (count ?? 0).toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

            const Gap(10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
