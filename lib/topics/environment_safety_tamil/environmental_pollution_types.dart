// lib/topics/environment_safety_tamil/environmental_pollution_types.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/environment_safety_tamil.dart';

class EnvironmentalPollutionTypesTamilPage extends StatefulWidget {
  @override
  _EnvironmentalPollutionTypesTamilPageState createState() => _EnvironmentalPollutionTypesTamilPageState();
}

class _EnvironmentalPollutionTypesTamilPageState extends State<EnvironmentalPollutionTypesTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EnvTopic3";

  final Map<int, String> correctAnswers = {
    1: "காற்று, நீர், மண், ஒலி, வெப்பம், கதிர்வீச்சு மற்றும் தனிப்பட்ட மாசுபாடு",
    2: "காற்று மாசுபாடு என்பது தீங்கு விளைவிக்கும் வாயுக்கள் காற்றில் கலப்பதே.",
    3: "மண் மாசுபாடு கழிவுகள், வேதியியல் மற்றும் மோசமான விவசாய முறைகளால் ஏற்படுகிறது.",
    4: "ஒலி மாசுபாடு என்பது அதிக சத்தம் மற்றும் குறைபாடுள்ள ஒலிகள்.",
    5: "வெப்ப மாசுபாடு என்பது தொழிற்சாலைகளில் இருந்து வெளியேறும் வெப்பத்தால் ஏற்படுகிறது."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "சுற்றுசூழல் மாசுபாட்டின் முக்கிய வகைகள் என்ன?",
      "options": [
        "காற்று, நீர், மண், ஒலி, வெப்பம், கதிர்வீச்சு மற்றும் தனிப்பட்ட மாசுபாடு",
        "வெறும் காற்று மற்றும் நீர்",
        "பிளாஸ்டிக் மற்றும் காகிதம்",
        "மழை மற்றும் வெயில்"
      ]
    },
    {
      "question": "காற்று மாசுபாடு என்றால் என்ன?",
      "options": [
        "விளையாட்டு மைதானத்தில் மாசுபாடு",
        "காற்று மாசுபாடு என்பது தீங்கு விளைவிக்கும் வாயுக்கள் காற்றில் கலப்பதே.",
        "இனிமையான வாசனை",
        "குளிர்ந்த காற்று"
      ]
    },
    {
      "question": "மண் மாசுபாடு எவ்வாறு ஏற்படுகிறது?",
      "options": [
        "அதிகமாக மரங்கள் நடுவதால்",
        "தூய்மையான விவசாயம் மூலம்",
        "மண் மாசுபாடு கழிவுகள், வேதியியல் மற்றும் மோசமான விவசாய முறைகளால் ஏற்படுகிறது.",
        "மேகமூட்டமான வானிலை"
      ]
    },
    {
      "question": "ஒலி மாசுபாடு என்றால் என்ன?",
      "options": [
        "அதிர்ச்சி தராத சத்தங்கள்",
        "வீட்டில் மெதுவான இசை",
        "ஒலி மாசுபாடு என்பது அதிக சத்தம் மற்றும் குறைபாடுள்ள ஒலிகள்.",
        "பறவைகள் கூவும் ஒலி"
      ]
    },
    {
      "question": "வெப்ப மாசுபாடு எதனால் ஏற்படுகிறது?",
      "options": [
        "ஐஸ் மூலம் குளிர்ச்சி",
        "வெப்ப மாசுபாடு என்பது தொழிற்சாலைகளில் இருந்து வெளியேறும் வெப்பத்தால் ஏற்படுகிறது.",
        "குளிர்கால மழை",
        "குளிர்காலம்"
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
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
    });
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
              title: Text("வினாடி வினா: மாசுபாட்டு வகைகள்"),
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
                        SnackBar(content: Text("தயவுசெய்து அனைத்து வினாக்களையும் பதிலளிக்கவும்")),
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

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("வினா முடிவுகள்"),
          content: Text("நீங்கள் ${quizQuestions.length} இல் $score மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3)
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/daily_and_eating_habits_ta');
                },
              ),
            TextButton(
              child: Text("மீண்டும் முயற்சி"),
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
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 6),
            Text(answer, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("மாசுபாட்டு வகைகள்"),
        backgroundColor: Colors.green[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => EnvironmentalSafetyTamil()),
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
                  _buildQuestionAnswer("🌫 காற்று மாசுபாடு என்றால் என்ன?", "தீங்கு விளைவிக்கும் வாயுக்களால் காற்று மாசுபடுகிறது.", imagePath: 'assets/env_3.0.png'),
                  _buildQuestionAnswer("💧 நீர் மாசுபாடு என்றால் என்ன?", "ஆறுகள், ஏரிகள் மற்றும் கடல்களில் தீங்கு விளைவிக்கும் பொருட்கள் கலப்பது."),
                  _buildQuestionAnswer("🌱 மண் மாசுபாடு என்றால் என்ன?", "வேதியியல் கழிவுகள் மற்றும் மோசமான விவசாய முறைகள் காரணமாக ஏற்படுவது.", imagePath: 'assets/env_3.1.png'),
                  _buildQuestionAnswer("🔊 ஒலி மாசுபாடு என்றால் என்ன?", "அதிக சத்தம் மற்றும் மனிதர்கள்/விலங்குகளுக்கு பாதிப்பை ஏற்படுத்தும் ஒலி."),
                  _buildQuestionAnswer("🔥 வெப்ப மாசுபாடு என்றால் என்ன?", "தொழிற்சாலைகளில் இருந்து வெளியேறும் வெப்பம் சுற்றுசூழலுக்கு தீங்கு விளைவிக்கிறது.", imagePath: 'assets/env_3.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிக்கப்பட்டதாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) {
                _saveTopicCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி")),
          ],
        ),
      ),
    );
  }
}
