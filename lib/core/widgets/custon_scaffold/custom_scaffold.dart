import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final bool isLoading;
  final String? errorMessage;

  const CustomScaffold({
    super.key,
    required this.body,
    this.title,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }

    return Scaffold(
      appBar: title != null ? AppBar(title: Text(title!)) : null,
      body: Stack(
        children: [
          body,
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
