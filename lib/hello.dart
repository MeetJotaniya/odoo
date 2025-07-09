import "package:flutter/material.dart";

class Hello extends StatelessWidget {
  const Hello({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello world"),
      ),
      body: Column(
        children: [
          Center(
            child : Text("Hello World" , style: TextStyle(fontSize: 40),)
          ),
          Center(
            child: Text("Jane baylaaaaa" , style: TextStyle(fontSize: 45),),
          )
        ],
      ),
    );
  }
}
