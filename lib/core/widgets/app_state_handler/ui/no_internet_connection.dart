import 'package:flutter/material.dart';

class NoInternetConnections extends StatelessWidget {
  const NoInternetConnections({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection'),
          duration: Duration(seconds: 2),
        ),
      );
    });

    return const SizedBox.shrink();
  }
}