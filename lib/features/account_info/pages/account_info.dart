import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/localization/locale_keys.g.dart';
import 'package:expense_tracker/core/services/image_picker_service.dart';
import 'package:expense_tracker/core/widgets/custom_button.dart';
import 'package:expense_tracker/core/widgets/custom_date_picker.dart';
import 'package:expense_tracker/core/widgets/custom_text_field.dart';
import 'package:expense_tracker/core/widgets/sheets/image_picker_sheet.dart';
import 'package:expense_tracker/features/account_info/providers/form_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/user_provider.dart';

class AccountInfo extends ConsumerWidget {
  const AccountInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final XFile? imageData = ref.watch(imageFileProvider);
    final name = ref.watch(editNameProvider);
    final email = ref.watch(editEmailProvider);
    final birthDate = ref.watch(editBirthDateProvider);

    const String fallbackUrl =
        'https://media.licdn.com/dms/image/v2/D4D03AQGofiGE_BrpgA/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1718252507739?e=1757548800&v=beta&t=IxPzkLlNsqbpmeLCKCGEeem9eU7BiuErxZ9lfjx3ovE';
    final XFile? pickedFile = ref.watch(imageFileProvider);
    final String? networkUrl = ref.watch(imageUrlProvider);

    final avatarImage = ImageService().getImage(
      file: pickedFile,
      photoUrl: (pickedFile == null ? networkUrl : null) ?? fallbackUrl,
    );

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
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: avatarImage,
                    ),
                    onTap: () {
                      showImagePickerSheet(
                        context,
                        imageData != null,
                        height * 0.2,
                        onDelete: () {
                          ref.read(imageFileProvider.notifier).state = null;
                          Navigator.of(context).pop();
                        },
                        onPick: () {
                          Navigator.of(context).pop();
                          showImagePickerSheet(
                            context,
                            false,
                            height * 0.2,
                            onDelete: () {},
                            onPick: () {},
                            onGallery: () async {
                              ref.read(imageFileProvider.notifier).state = await ImageService().pickFromGallery(
                                context,
                              );
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                            onCamera: () async {
                              ref.read(imageFileProvider.notifier).state = await ImageService().pickFromCamera(context);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                          );
                        },
                        onGallery: () async {
                          ref.read(imageFileProvider.notifier).state = await ImageService().pickFromGallery(context);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        onCamera: () async {
                          ref.read(imageFileProvider.notifier).state = await ImageService().pickFromCamera(context);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                      );
                    },
                  ),
                  //edit button
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

              const Gap(30),

              CustomTextField(
                label: LocaleKeys.name.tr().capitalizeFirst(),
                hintText: LocaleKeys.name.tr().capitalizeFirst(),
                initialValue: name,
                onChanged: (value) {
                  ref.read(editNameProvider.notifier).state = value;
                },
              ),
              const Gap(20),
              CustomTextField(
                label: LocaleKeys.email.tr().capitalizeFirst(),
                hintText: LocaleKeys.email.tr().capitalizeFirst(),
                initialValue: email,
                onChanged: (value) {
                  ref.read(editEmailProvider.notifier).state = value;
                },
              ),
              const Gap(20),
              CustomDateField(
                label: LocaleKeys.date_of_birth.tr().capitalizeFirst(),
                hintText: LocaleKeys.date_of_birth.tr().capitalizeFirst(),
                initialValue: birthDate,
                onChanged: (value) {
                  ref.read(editBirthDateProvider.notifier).state = value ?? DateTime.now();
                },
              ),
              const Gap(20),

              //! Password değiştirme işlemi için önce password girişi yapılacak ve başka bir yerden çağırılması daha
              // CustomTextField(
              //   label: LocaleKeys.password.tr().capitalizeFirst(),
              //   hintText: LocaleKeys.password.tr().capitalizeFirst(),
              //   isPassword: true,
              //   onChanged: (value) {},
              // ),
              // const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: CustomButton(
                  color: Colors.blue,
                  icon: Icons.check,
                  text: "Save",
                  onTap: () async {
                    await ref.read(userProvider.notifier).save(ref);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
