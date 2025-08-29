import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/localization/locale_keys.g.dart';
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

        Text(
          LocaleKeys.no_data.tr().capitalizeFirst(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(10),
        Text(LocaleKeys.no_transactions_found.tr().capitalizeFirst()),
      ],
    );
  }
}
