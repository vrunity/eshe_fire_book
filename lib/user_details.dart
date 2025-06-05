import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/classes.dart'; // Ensure this is the correct import

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String statusMessage = "";

  @override
  void initState() {
    super.initState();
    checkUserSaved(); // Check if user data is saved locally
  }

  // Check if user details are already saved
  Future<void> checkUserSaved() async {
    try {
      print("DEBUG: Checking SharedPreferences...");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedName = prefs.getString("user_name");
      String? savedPhone = prefs.getString("user_phone");

      print("DEBUG: Saved Name: $savedName");
      print("DEBUG: Saved Phone: $savedPhone");

      if (savedName != null && savedPhone != null) {
        print("DEBUG: User found in local storage. Redirecting...");
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ClassPage()),
          );
        });
      } else {
        print("DEBUG: No saved user found.");
      }
    } catch (e) {
      print("DEBUG: SharedPreferences error - $e");
    }
  }

  // Save user details in SharedPreferences
  Future<void> saveUserLocally(String name, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", name);
    await prefs.setString("user_phone", phone);
    print("DEBUG: User details saved locally -> Name: $name, Phone: $phone");
  }

  // Function to send data to PHP server and navigate
  Future<void> sendDataToServer() async {
    final String url = "https://esheapp.in/e_she_book/insert_user.php"; // Replace with your PHP URL

    print("DEBUG: Sending data to server...");
    print("Name: ${nameController.text.trim()}");
    print("Phone: ${phoneController.text.trim()}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",  // Ensure correct content type
        },
        body: {
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
        },
      );

      print("DEBUG: Response received.");
      print("DEBUG: Status Code -> ${response.statusCode}");
      print("DEBUG: Response Body -> ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["status"] == "exists") {
          setState(() {
            statusMessage = "✅ User already exists! Redirecting...";
          });
          print("DEBUG: User already exists.");
        } else if (responseData["status"] == "success") {
          setState(() {
            statusMessage = "✅ User added successfully!";
          });
          print("DEBUG: User added successfully.");
        } else {
          setState(() {
            statusMessage = "❌ Server Error: ${responseData["message"]}";
          });
          print("DEBUG: Server Error -> ${responseData["message"]}");
          return;
        }

        // Save user details locally
        await saveUserLocally(nameController.text.trim(), phoneController.text.trim());

        // Navigate to ClassPage after success or existing user
        Future.delayed(Duration(seconds: 1), () {
          print("DEBUG: Navigating to ClassPage...");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ClassPage()),
          );
        });
      } else {
        setState(() {
          statusMessage = "❌ Server Error: ${response.statusCode}";
        });
        print("DEBUG: Server Error - Status Code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        statusMessage = "❌ Failed: $e";
      });
      print("DEBUG: Exception occurred - $e");
    }
  }

  void _submitDetails() {
    print("DEBUG: Submit button clicked.");
    print("Entered Name: ${nameController.text}");
    print("Entered Phone: ${phoneController.text}");

    if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
      sendDataToServer();
    } else {
      setState(() {
        statusMessage = "❌ Please enter both name and phone number!";
      });
      print("DEBUG: Input fields are empty.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Your Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Your Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Text(
              statusMessage,
              style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
