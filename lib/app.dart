import 'package:flutter/material.dart';
import 'package:promotional/pages/promotions.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PromotionalPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
