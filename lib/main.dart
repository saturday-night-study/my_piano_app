import 'package:flutter/material.dart';
import 'package:my_xylophone_app/home_page.dart';

void main() async {
  runApp(MaterialApp(
    home: const HomePage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        color: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
    ),
  ));
}
