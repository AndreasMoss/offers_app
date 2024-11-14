import 'package:flutter/material.dart';
import 'package:offers_app/theme/colors_for_text.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
      child: Column(
        children: [
          Text(
            'My Profile',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: textBlackB12),
          ),
        ],
      ),
    );
  }
}
