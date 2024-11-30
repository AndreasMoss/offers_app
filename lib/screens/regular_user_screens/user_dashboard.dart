import 'package:flutter/material.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:offers_app/widgets/user_log_tile.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 95.0, bottom: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: textBlackB12),
          ),
          const SizedBox(height: 12),
          const UserLogTile()
        ],
      ),
    );
  }
}
