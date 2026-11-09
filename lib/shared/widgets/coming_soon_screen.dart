import 'package:flutter/material.dart';

/// Temporary screen for tabs implemented in later phases.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title, required this.phase});
  final String title;
  final int phase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Planned for Phase $phase')),
    );
  }
}
