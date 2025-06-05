// general_safety_precautions_ta.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/forklift_safety_tamil.dart';

class SafetyPrecautionsTamilPage extends StatefulWidget {
  @override
  _SafetyPrecautionsTamilPageState createState() => _SafetyPrecautionsTamilPageState();
}

class _SafetyPrecautionsTamilPageState extends State<SafetyPrecautionsTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ForkliftPrecautionsTamil";

  final Map<int, String> correctAnswers = {
    1: "பயன்பாட்டின்போது எப்போதும் seatbelt அணியவும்.",
    2: "ஒவ்வொரு முறையும் பயன்படுத்தும் முன் Forklift ஐ சரிபார்க்கவும்.",
    3: "ஏற்றம் சமநிலையாகவும் உறுதியாகவும் இருக்க வேண்டும்.",
    4: "பாதுகாப்பான வேகத்தில் ஓட்டவும், திடீர் திருப்பங்களை தவிர்க்கவும்.",
    5: "அங்கீகரிக்கப்படாத நபர்கள் இயக்கக்கூடாது."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Forklift இயக்குவதற்கு முன் முக்கியமான பாதுகாப்பு நடவடிக்கை எது?",
      "options": [
        "கண்ணாடி சரிபார்க்கவும்",
        "பயன்பாட்டின்போது எப்போதும் seatbelt அணியவும்.",
        "ஏற்றம் தொடர",
        "மொபைல் பயன்படுத்தவும்"
      ]
    },
    {
      "question": "ஒவ்வொரு நாளும் பயன்படுத்துவதற்கு முன் என்ன செய்ய வேண்டும்?",
      "options": [
        "பேட்டரி சார்ஜ் செய்யவும்",
        "அலங்கரிக்கவும்",
        "ஒவ்வொரு முறையும் பயன்படுத்தும் முன் Forklift ஐ சரிபார்க்கவும்.",
        "முன் பகுதியை வண்ணம் பூசவும்"
      ]
    },
    {
      "question": "ஏற்றங்களை எப்படிச் சமநிலையாக வைக்க வேண்டும்?",
      "options": [
        "தளர்த்தவும்",
        "இலகுவான பொருட்கள் மட்டும்",
        "ஏற்றம் சமநிலையாகவும் உறுதியாகவும் இருக்க வேண்டும்.",
        "பின்வாங்கவும்"
      ]
    },
    {
      "question": "Forklift ஓட்டுவதற்கான சிறந்த நடைமுறை எது?",
      "options": [
        "பாதுகாப்பான வேகத்தில் ஓட்டவும், திடீர் திருப்பங்களை தவிர்க்கவும்.",
        "மற்ற இயக்குநர்களுடன் போட்டியிடவும்",
        "வீல்களை தூக்கவும்",
        "எப்போதும் பின்வாங்கவும்"
      ]
    },
    {
      "question": "யார் Forklift ஐ இயக்க அனுமதிக்கப்பட வேண்டும்?",
      "options": [
        "யாரும்",
        "புதிய தொழிலாளர்கள்",
        "அங்கீகரிக்கப்படாத நபர்கள் இயக்கக்கூடாது.",
        "விருந்தினர்கள்"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadTopicStatus();
  }

  Future<void> _loadTopicStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCompleted = prefs.getBool('Completed_\$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_\$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_\$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_\$topicName', value);
    setState(() {
      isCompleted = value;
    });
    if (value) _showQuizDialog();
  }

  Future<void> _saveQuizScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('QuizScore_\$topicName', score);
    await prefs.setBool('QuizTaken_\$topicName', true);
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
    });
  }

  void _evaluateQuiz() {
    int score = 0;
    userAnswers.forEach((key, value) {
      if (correctAnswers[key] == value) {
        score++;
      }
    });
    _saveQuizScore(score);
    _showQuizResult(score);
  }

  void _showQuizDialog() {
    userAnswers.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("வினாடி வினா: பாதுகாப்பு முன்னெச்சரிக்கைகள்"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int questionIndex = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"], style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[questionIndex],
                            onChanged: (String? value) {
                              setState(() {
                                userAnswers[questionIndex] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text("சமர்ப்பிக்கவும்"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("தயவுசெய்து அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
                      );
                    } else {
                      Navigator.pop(dialogContext);
                      _evaluateQuiz();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("மதிப்பீடு முடிவுகள்"),
          content: Text("நீங்கள் ${quizQuestions.length}ல் $score மதிப்பெண் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3)
              TextButton(
                child: Text("அடுத்தது"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/signals_and_checks_ta');
                },
              ),
            TextButton(
              child: Text("மீண்டும் முயற்சிக்கவும்"),
              onPressed: () {
                Navigator.pop(context);
                _showQuizDialog();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionAnswer(String question, String answer, {String? imagePath}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imagePath, fit: BoxFit.cover, height: 180, width: double.infinity),
              ),
            if (imagePath != null) SizedBox(height: 10),
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(answer, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("பொதுவான பாதுகாப்பு முன்னெச்சரிக்கைகள்"),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ForkliftSafetyTamil()),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("✅ Seatbelt அணியவும்", "Forklift இயக்கும்போது எப்போதும் seatbelt அணியவும்."),
                  _buildQuestionAnswer("🔍 தினசரி ஆய்வு", "ஒவ்வொரு முறையும் பயன்படுத்தும் முன் ஆய்வு செய்யவும்."),
                  _buildQuestionAnswer("📦 ஏற்றத்தை உறுதியாக வைக்கவும்", "ஏற்றம் சரியான முறையில் சமநிலையாகவும் உறுதியாகவும் இருக்க வேண்டும்."),
                  _buildQuestionAnswer("🚫 வேகக்கட்டுப்பாடு", "பாதுகாப்பாக ஓட்டவும், கூட்டம் அதிகமான இடங்களில் கவனமாக இருக்கவும்."),
                  _buildQuestionAnswer("🚷 அனுமதிக்கப்பட்ட நபர்கள் மட்டுமே", "அங்கீகரிக்கப்படாத நபர்கள் Forklift ஐ இயக்கக்கூடாது."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("நிறைவு என குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) {
                _saveTopicCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சிக்கவும்")),
          ],
        ),
      ),
    );
  }
}