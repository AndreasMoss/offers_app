import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/screens/business_screens/business_dashboard.dart';
import 'package:offers_app/screens/regular_user_screens/user_dashboard.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userType = ref.read(userTypeProvider).value;

    return userType == 'business'
        ? const BusinessDashboard()
        : const UserDashboard();
  }
}
