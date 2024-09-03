import 'package:lecturers_appointment/generated/assets.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FooterPage extends ConsumerWidget {
  const FooterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      color: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          // Logo
          Image.asset(Assets.imagesLectLogoWhite, height: 30),
          const SizedBox(width: 20),
          const Text('© 2021 Lecturers Appointment',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
