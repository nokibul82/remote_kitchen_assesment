import 'package:flutter/material.dart';

class AnotherScreen extends StatelessWidget {
  const AnotherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          "Welcome to Another Screen",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    ));
  }
}
