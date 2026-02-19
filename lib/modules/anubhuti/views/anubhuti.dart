import 'package:flutter/material.dart';

class Anubhuti extends StatelessWidget {
  const Anubhuti({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anubhuti')),
      body: Container(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Send Message'),
        icon: const Icon(Icons.send),
      ),
    );
  }
}
