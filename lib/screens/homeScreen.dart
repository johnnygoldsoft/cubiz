import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.lightGreen,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white60,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.map, size: 30),
                            SizedBox(width: 20),
                            Text("Lomé", style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage("lib/images/salle2f.jpg"),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.yellow,
                  child: Column(
                    children: [
                      Text("Tous vos variete de cube a porter de main ..."),
                      Row(children: [Text("ce ezo ")]),
                    ],
                  ),
                ),
                Center(child: Text("Ok top")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
