import 'package:expense_tracker/core/widgets/custom_date_picker.dart';
import 'package:expense_tracker/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/providers/user_provider.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final u = userAsync.valueOrNull;
    print(u);
    final ImagePicker picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leadingWidth: 120,
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.all(4.0),
                  iconSize: 23,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                GestureDetector(
                  child: const CircleAvatar(
                    radius: 65,
                    backgroundImage: NetworkImage(
                      'https://media.licdn.com/dms/image/v2/D4D03AQGofiGE_BrpgA/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1718252507739?e=1757548800&v=beta&t=IxPzkLlNsqbpmeLCKCGEeem9eU7BiuErxZ9lfjx3ovE',
                    ),
                  ),
                  onTap: () async {
                    final file = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1024,
                      imageQuality: 85,
                    );
                  },
                ),
                //-- edit button
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF00C2FF),
                          Color(0xFF6C63FF),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            const Text("Profile Photo"),
            const Gap(10),

            CustomTextField(
              initialValue: (!userAsync.isLoading && !userAsync.hasError) ? (u?.name ?? "") : "",
              label: "Name",
              hintText: "Your Name",
              onChanged: (value) {},
            ),
            const Gap(20),

            CustomDateField(
              label: "Birthday",
              hint: "Your Birthday",
              onChanged: (value) {},
            ),
            const Gap(20),

            CustomTextField(
              label: "Email",
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            const Gap(20),
            //--Save Button
            Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF00C2FF),
                    Color(0xFF6C63FF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(18),
                    blurRadius: 14,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
