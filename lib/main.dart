import 'package:flutter/material.dart';
import 'package:e_she_book/welcome.dart';

void main() {
  runApp(FireSafetyApp());
}

class FireSafetyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fire Safety Class',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF2F2F2), // ✅ Light Background
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFF0000),
          elevation: 5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: FireSafetyBackground(child: Welcome()),
    );
  }
}

// ✅ Background with **Fully Visible Logo**
class FireSafetyBackground extends StatelessWidget {
  final Widget child;
  FireSafetyBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ Light Background
        Container(
          color: Color(0xFFF2F2F2),
        ),

        // ✅ Fully Visible Logo (No Transparency, No Blending)
        Positioned(
          top: 100, // Adjust position if needed
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/logo.png',
            width: 200,  // ✅ Adjust size
            height: 200,
            fit: BoxFit.contain,
          ),
        ),

        // ✅ App Content
        child,
      ],
    );
  }
}

