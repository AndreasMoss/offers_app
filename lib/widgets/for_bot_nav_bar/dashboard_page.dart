import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Dashboard Page'),
        ElevatedButton(
            onPressed: () {},
            child: const Center(child: Text('Add new offer!'))),
      ],
    );
  }
}
