import 'package:flutter/material.dart';

class PhoneSuggestionsPage extends StatelessWidget {
  const PhoneSuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Suggestions'),
      ),
      body: const Center(
        child: Text('Suggestions for your phone will appear here.'),
      ),
    );
  }
}
