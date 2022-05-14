import 'package:flutter/material.dart';
import 'package:my_xylophone_app/orientation_util.dart';
import 'package:my_xylophone_app/xylophone_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    OrientationUtil.setPortrait();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Xylophone"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => XylophonePage()),
            );
          },
          child: Text("Go Xylophone!"),
        ),
      ),
    );
  }
}
