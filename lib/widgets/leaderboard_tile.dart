import 'package:flutter/material.dart';
import 'package:offers_app/models/regular_user.dart';
import 'package:offers_app/theme/other_colors.dart';

class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile(
      {super.key,
      required this.index,
      required this.user,
      required this.userId});

  final int index;
  final RegularUser user;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final rank = index + 1;
    return Container(
      width: 327,
      height: 64,
      decoration: BoxDecoration(
        color: userId == user.userId
            ? Theme.of(context).colorScheme.surface
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFECEFF3), // Χρώμα του border
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFFFFB900)),
          child: Center(
            child: Text(
              (index + 1).toString(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              rank == 1
                  ? '🏅 ${user.username}'
                  : rank == 2
                      ? '🥈 ${user.username}'
                      : rank == 3
                          ? '🥉 ${user.username}'
                          : user.username,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: textBlackB12),
            ),
            const Spacer(),
            Text(' ${user.points.toString()} Points'),
          ],
        ),
      ),
    );
  }
}
