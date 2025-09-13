

import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("cubiz"),),
      body: SingleChildScrollView(
        child: Container(
          child: Center(child: Text("Ok top"),),
        ),
      ),
    );
  }
}