import 'package:flutter/material.dart';
import 'classes.dart'; // Import your ClassPage

class BookCoverPage extends StatelessWidget {
  const BookCoverPage({Key? key}) : super(key: key);

  void _navigateToClassPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => ClassPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: Offset(1.0, 0.0), // starts from the right
            end: Offset.zero,         // ends at original position
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detect swipe gesture (right-to-left swipe)
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          _navigateToClassPage(context);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Full-screen background image
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/fire_safety.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Icon button positioned at the center right
            Positioned(
              right: 20,
              top: MediaQuery.of(context).size.height / 2 - 24,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 48,
                  color: Colors.white,
                ),
                onPressed: () => _navigateToClassPage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
