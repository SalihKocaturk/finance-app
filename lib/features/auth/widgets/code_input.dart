import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_form_providers.dart';

class CodeInput extends ConsumerWidget {
  const CodeInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(codeValueProvider);

    return Column(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              final char = i < code.length ? code[i] : '';
              final focused = code.length == i;
              return SizedBox(
                width: 48,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: focused ? Colors.blue : Colors.grey.shade300,
                      width: focused ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    char,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }),
          ),
        ),

        Offstage(
          offstage: true,
          child: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: (v) {
              ref.read(codeValueProvider.notifier).state = v;
            },
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}
