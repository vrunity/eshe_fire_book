import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/classes.dart'; // Ensure this is the correct import

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String statusMessage = "";

  @override
  void initState() {
    super.initState();
    // Use `addPostFrameCallback` to delay execution until the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestStoragePermission(context);
    });
    checkUserSaved(); // Check if user details are saved
  }

  /// ✅ FIX: Request storage permission only ONCE in initState
  Future<void> requestStoragePermission(BuildContext context) async {
    print("Requesting storage permission...");

    if (Platform.isAndroid) {
      // ✅ Request both permissions in a single request to prevent duplicate errors
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();

      if (statuses[Permission.storage]!.isGranted ||
          statuses[Permission.manageExternalStorage]!.isGranted) {
        print("✅ Storage permission granted.");
      } else if (statuses[Permission.storage]!.isPermanentlyDenied ||
          statuses[Permission.manageExternalStorage]!.isPermanentlyDenied) {
        print("❌ Storage permission permanently denied.");

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Storage permission is required. Please enable it in app settings.'),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () {
                  openAppSettings();
                },
              ),
            ),
          );
        }
      } else {
        print("❌ Storage permission denied.");
      }
    }
  }

  /// ✅ Check if user details are saved locally
  Future<void> checkUserSaved() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedName = prefs.getString("user_name");
      String? savedPhone = prefs.getString("user_phone");

      if (savedName != null && savedPhone != null) {
        print("✅ User exists. Fetching progress from server...");
        await fetchUserProgress(savedName, savedPhone);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClassPage()),
        );
      }
    } catch (e) {
      print("❌ Error fetching user data: $e");
    }
  }

  /// ✅ Fetch User Progress from the Database
  Future<void> fetchUserProgress(String name, String phone) async {
    final String url = "https://esheapp.in/e_she_book/get_user_progress.php"; // Ensure correct API URL

    print("🔄 Fetching user progress...");
    print("📌 Name: $name");
    print("📌 Phone: $phone");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "name": name,
          "phone": phone,
        },
      );

      print("✅ Server Response Received");
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["status"] == "success") {
          String progressData = responseData["progress"];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("user_progress", progressData);

          print("✅ User progress saved locally: $progressData");
        } else {
          print("⚠️ No progress found for this user.");
        }
      } else {
        print("❌ Error retrieving progress: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Exception occurred: $e");
    }
  }

  /// ✅ Save User Locally and on Server
  Future<void> saveUserLocally(String name, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", name);
    await prefs.setString("user_phone", phone);
    print("✅ User details saved locally: Name=$name, Phone=$phone");
  }

  /// ✅ Register or Retrieve User
  Future<void> sendDataToServer() async {
    final String url = "https://esheapp.in/e_she_book/insert_user.php"; // Your API endpoint

    print("🔄 Sending user data to server...");
    print("📌 Name: ${nameController.text.trim()}");
    print("📌 Phone: ${phoneController.text.trim()}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
        },
      );

      print("✅ Server Response Received");
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["status"] == "exists") {
          setState(() {
            statusMessage = "✅ User already exists! Fetching progress...";
          });
          await fetchUserProgress(nameController.text.trim(), phoneController.text.trim());
        } else if (responseData["status"] == "success") {
          setState(() {
            statusMessage = "✅ User added successfully!";
          });
        } else {
          setState(() {
            statusMessage = "❌ Server Error: ${responseData["message"]}";
          });
          return;
        }

        await saveUserLocally(nameController.text.trim(), phoneController.text.trim());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClassPage()),
        );
      } else {
        setState(() {
          statusMessage = "❌ Server Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "❌ Failed: $e";
      });
      print("🚨 Exception occurred: $e");
    }
  }

  void _submitDetails() {
    if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
      sendDataToServer();
    } else {
      setState(() {
        statusMessage = "❌ Please enter both name and phone number!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50, // Background color
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Logo
              Image.asset("assets/logo.png", height: 100, width: 100),

              SizedBox(height: 20),
              Text(
                'e-Learning',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),

              SizedBox(height: 20),

              // 🔹 Name Input
              TextField(
                controller: nameController,
                style: TextStyle(color: Colors.black), // Set text color to black
                decoration: InputDecoration(
                  labelText: 'Enter Your Name',
                  labelStyle: TextStyle(color: Colors.black), // Label text color
                  hintStyle: TextStyle(color: Colors.black54), // Hint text color
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.black), // Icon color
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.black), // Set text color to black
                decoration: InputDecoration(
                  labelText: 'Enter Your Phone Number',
                  labelStyle: TextStyle(color: Colors.black), // Label text color
                  hintStyle: TextStyle(color: Colors.black54), // Hint text color
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone, color: Colors.black), // Icon color
                ),
              ),
              SizedBox(height: 20),
              // 🔹 Submit Button
              ElevatedButton(
                onPressed: _submitDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                child: Text('Submit'),
              ),
              SizedBox(height: 20),

              // 🔹 Status Message
              Text(
                statusMessage,
                style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
