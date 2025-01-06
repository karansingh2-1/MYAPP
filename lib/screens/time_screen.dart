import 'package:flutter/material.dart';

class TimeScreen extends StatelessWidget {
  const TimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time'),
      ),
      body: const Center(
        child: Text('Time Screen Content'),
      ),
    );
  }
}
