import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/custom_button.dart';
import '../providers/auth_form_providers.dart';
import 'code_input.dart';

class JoinCodeSheet extends ConsumerWidget {
  const JoinCodeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(codeValueProvider);

    void submit() {
      if (code.length == 6) {
        Navigator.of(context).pop(code);
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Oturum Kodunu Gir', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const Gap(8),
          const Text('6 haneli sayısal kod', style: TextStyle(color: Colors.black54)),
          const Gap(20),
          const CodeInput(),
          const Gap(20),
          CustomButton(
            canSave: code.length == 6,
            color: Colors.blue,
            icon: Icons.check_circle_rounded,
            text: 'Katıl',
            onTap: submit,
          ),
        ],
      ),
    );
  }
}
