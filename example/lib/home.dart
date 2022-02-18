import 'package:flutter/material.dart';
import 'package:pdfx_example/pinch.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home')),
      body: Center(
          child: IconButton(
        icon: Icon(Icons.settings, color: Colors.red,),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => PinchPage())),
      )),
    );
  }
}
