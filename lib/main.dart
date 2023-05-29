import 'package:flutter/material.dart';
import 'package:path_animation/_features.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Path Animated',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PageWithPathAnimated(),
    );
  }
}
