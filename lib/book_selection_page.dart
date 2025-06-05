import 'package:e_she_book/english/bbs_safety_english.dart';
import 'package:e_she_book/english/construction_safety_english.dart';
import 'package:e_she_book/english/electrical_safety_english.dart';
import 'package:e_she_book/english/emergency_handling_english.dart';
import 'package:e_she_book/english/environment_safety_english.dart';
import 'package:e_she_book/english/fire_safety_english.dart';
import 'package:e_she_book/english/first_aid_english.dart';
import 'package:e_she_book/english/forklift_safety_english.dart';
import 'package:e_she_book/english/kids_safety_english.dart';
import 'package:e_she_book/english/ppe_english.dart';
import 'package:e_she_book/english/road_safety_english.dart';
import 'package:e_she_book/tamil/bbs_safety_tamil.dart';
import 'package:e_she_book/tamil/construction_safety_tamil.dart';
import 'package:e_she_book/tamil/electrical_safety_tamil.dart';
import 'package:e_she_book/tamil/environment_safety_tamil.dart';
import 'package:e_she_book/tamil/fire_safety_tamil.dart';
import 'package:e_she_book/tamil/first_aid_tamil.dart';
import 'package:e_she_book/tamil/forklift_safety_tamil.dart';
import 'package:e_she_book/tamil/kids_safety_tamil.dart';
import 'package:e_she_book/tamil/ppe_tamil.dart';
import 'package:e_she_book/topics/electrical_safety_tamil/electrical_intro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/welcome.dart';
import 'package:e_she_book/tamil/road_safety_tamil.dart';


class BookSelectionPage extends StatelessWidget {
  const BookSelectionPage({super.key});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Welcome()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6F00), Color(0xFFB71C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          '📚 Select Your Book',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildBookCard(context, "🔥 Fire Safety\n(English)", Icons.local_fire_department, fire_safety_english()),
            _buildBookCard(context, "🔥 Fire Safety\n(Tamil)", Icons.local_fire_department_outlined, fire_safety_tamil()),
            _buildBookCard(context, "⛑️ First Aid\n(English)", Icons.medical_services, firstaid_english()),
            _buildBookCard(context, "⛑️ First Aid\n(Tamil)", Icons.health_and_safety, firstaid_tamil()),
            _buildBookCard(context, "🛡️ PPE\n(English)", Icons.security, ppe_english()),
            _buildBookCard(context, "🛡️ PPE\n(Tamil)", Icons.security, ppe_tamil()),
            _buildBookCard(context, " Electrical Safety\n(English)", Icons.electric_bolt_outlined, ElectricalSafetyEnglish()),
            _buildBookCard(context, " Electrical Safety\n(Tamil)", Icons.electric_bolt_outlined, ElectricalSafetyTamil()),
            _buildBookCard(context, "🚦 Road Safety\n(English)", Icons.directions_car, RoadSafetyEnglish()), // ✅ Added Road Safety English Book
            _buildBookCard(context, "🚦 Road Safety\n(Tamil)", Icons.directions_car_filled_outlined, RoadSafetyTamil()), // ✅ Added Road Safety Tamil Book
            _buildBookCard(context, "👶 Kids Safety\n(English)", Icons.child_care, KidsSafetyEnglish()),
            _buildBookCard(context, "👶 Kids Safety\n(Tamil)", Icons.child_care, KidsSafetyTamil()),
            _buildBookCard(context, "🏗 Construction Safety\n(English)", Icons.construction, ConstructionSafetyEnglish()),
            _buildBookCard(context, "🏗 Construction Safety\n(Tamil)", Icons.construction, ConstructionSafetyTamil()),
            _buildBookCard(context, "🌱 Environment & Energy\n(English)", Icons.eco, EnvironmentalSafety()),
            _buildBookCard(context, "🌱 Environment & Energy\n(Tamil)", Icons.eco_outlined, EnvironmentalSafetyTamil()),
            _buildBookCard(context, "🚧 Forklift Safety\n(English)", Icons.local_shipping, ForkliftSafetyEnglish()),
            _buildBookCard(context, "🚧 Forklift Safety\n(Tamil)", Icons.local_shipping, ForkliftSafetyTamil()),
            _buildBookCard(context, "📘 BBS Safety\n(English)", Icons.menu_book, BBSSafetyEnglish()),
            _buildBookCard(context, "📘 BBS Safety\n(Tamil)", Icons.menu_book, BbsSafetyTamil()),
            _buildBookCard(context, "🚨 Emergency Handling\n(English)", Icons.warning_amber, EmergencyHandlingEnglish()),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, String title, IconData icon, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
