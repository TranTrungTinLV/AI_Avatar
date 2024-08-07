import 'package:flutter/material.dart';
import 'package:generative_img_ai/HomeGenerateive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(appBarTheme: AppBarTheme),
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF001F4E),
              Color(0xFF021945),
              Color(0xFF03143E),
            ],
            stops: [0.0, 0.56, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 5.0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: Container(
                  height: 3.0,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF001F4E),
                      Color(0xFF021945),
                      Color(0xFF03143E),
                    ],
                    stops: [0.0, 0.56, 1.0],
                  ),
                ),
              ),
              toolbarHeight: 80.0,
              // shape: ShapeBorder.,
              backgroundColor: Colors.blue,

              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only()),
              title: Text(
                "Avatar AI",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              // backgroundColor: ,
            ),
            body: SafeArea(
                child: Container(
                    margin: EdgeInsets.only(top: 30),
                    child: SingleChildScrollView(child: HomeGenerateive())))),
      ),
    );
    // );
    // );
  }
}
