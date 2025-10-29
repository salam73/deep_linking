import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example external link (OAuth, payment, etc.)
            // FlutterRedirectly.open('https://example.com/auth');
          },
          child: const Text("Open Redirect Flow"),
        ),
      ),
    );
  }
}
