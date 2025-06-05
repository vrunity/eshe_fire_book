// signals_and_checks_ta.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/forklift_safety_tamil.dart';

class SignalsAndChecksTamilPage extends StatefulWidget {
  @override
  _SignalsAndChecksTamilPageState createState() => _SignalsAndChecksTamilPageState();
}

class _SignalsAndChecksTamilPageState extends State<SignalsAndChecksTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ForkliftSignalsTamil";

  final Map<int, String> correctAnswers = {
    1: "வளைவுகள் மற்றும் மூலைகளில் ஹார்ன் பயன்படுத்தவும்.",
    2: "ஒவ்வொரு நாளும் பிரேக், லைட் மற்றும் ஹார்ன் சரிபார்க்கவும்.",
    3: "கண்ணாடிகள் சுத்தமாகவும் சரியான கோணத்தில் இருப்பதை உறுதிசெய்யவும்.",
    4: "திரவ நிலைகள் மற்றும் டயர்கள் நிலை சரிபார்க்கவும்.",
    5: "பின்வாங்கும்போது கை சைகைகள் அல்லது உதவியாளர்களை பயன்படுத்தவும்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "எப்போது ஹார்ன் பயன்படுத்த வேண்டும்?",
      "options": [
        "இரவு நேரத்தில்",
        "வளைவுகள் மற்றும் மூலைகளில் ஹார்ன் பயன்படுத்தவும்.",
        "நண்பர்கள் அருகில்",
        "சம்பவ நேரங்களில் மட்டும்"
      ]
    },
    {
      "question": "ஒவ்வொரு நாளும் என்ன சரிபார்க்க வேண்டும்?",
      "options": [
        "வண்ணம்",
        "ஒவ்வொரு நாளும் பிரேக், லைட் மற்றும் ஹார்ன் சரிபார்க்கவும்.",
        "ஸ்டிக்கர் லேபல்கள்",
        "யூனிபார்ம்"
      ]
    },
    {
      "question": "விழிப்புடன் இயக்க என்ன உறுதிசெய்ய வேண்டும்?",
      "options": [
        "கண்ணாடி போர்வைகள்",
        "கதவுகள் திறந்திருக்க வேண்டும்",
        "கண்ணாடிகள் சுத்தமாகவும் சரியான கோணத்தில் இருப்பதை உறுதிசெய்யவும்.",
        "கண்ணாடிகள் அணியவும்"
      ]
    },
    {
      "question": "எந்த இயந்திர அம்சங்களை சரிபார்க்க வேண்டும்?",
      "options": [
        "மியூசிக் சிஸ்டம்",
        "வண்ணம் மற்றும் இருக்கை",
        "திரவ நிலைகள் மற்றும் டயர்கள் நிலை சரிபார்க்கவும்.",
        "ஜி.பி.எஸ்."
      ]
    },
    {
      "question": "இருண்ட இடங்களில் எப்படி பின்வாங்க வேண்டும்?",
      "options": [
        "தானாக பின்வாங்கவும்",
        "பின்வாங்கும்போது கை சைகைகள் அல்லது உதவியாளர்களை பயன்படுத்தவும்.",
        "சத்தமாக கத்தவும்",
        "முன்பக்கம் மட்டும் இயக்கவும்"
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
      isCompleted = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      isCompleted = value;
    });
    if (value) _showQuizDialog();
  }

  Future<void> _saveQuizScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('QuizScore_$topicName', score);
    await prefs.setBool('QuizTaken_$topicName', true);
    await prefs.setBool('Completed_$topicName', true);
    String date = DateTime.now().toIso8601String().split('T').first;
    await prefs.setString('ForkliftCourseCompletedDateTamil', date);
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
      isCompleted = true;
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
              title: Text("வினாடி வினா: சைகைகள் & தினசரி சோதனைகள்"),
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
              child: Text("முடிக்கவும்"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ForkliftSafetyTamil()),
                );
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
        title: Text("சைகைகள் மற்றும் தினசரி சோதனைகள்"),
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
                  _buildQuestionAnswer("📣 ஹார்ன் பயன்பாடு", "வளைவுகள் மற்றும் மூலைகளில் விழிப்புடன் ஹார்ன் கொடுக்கவும்."),
                  _buildQuestionAnswer("🔧 தினசரி சோதனை", "பிரேக், லைட் மற்றும் ஹார்ன் செயல்படுகிறதா என்பதை சரிபார்க்கவும்."),
                  _buildQuestionAnswer("🪞 கண்ணாடிகள்", "சுத்தமாகவும் சரியாக நிலைநிறுத்தப்பட்டதா என்பதையும் உறுதிசெய்யவும்."),
                  _buildQuestionAnswer("🛢️ திரவ மற்றும் டயர்கள்", "திரவ அளவு மற்றும் டயர் நிலை சரியாக உள்ளதா என்பதை பார்க்கவும்."),
                  _buildQuestionAnswer("👋 கைசைகைகள்", "பின்வாங்கும் போது உதவியாளர் அல்லது கைசைகைகளை பயன்படுத்தவும்."),
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
