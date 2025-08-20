import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Colors.black,
        ),
        SvgPicture.asset(
          'assets/images/inbox-empty.svg',
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),
        const Gap(10),

        const Text(
          "No Data",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(10),
        const Text("No Transactions Found"),
      ],
    );
  }
}
