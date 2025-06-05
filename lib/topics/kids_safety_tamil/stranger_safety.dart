import 'package:e_she_book/tamil/kids_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StrangerSafetyTamilPage extends StatefulWidget {
  @override
  _StrangerSafetyTamilPageState createState() => _StrangerSafetyTamilPageState();
}

class _StrangerSafetyTamilPageState extends State<StrangerSafetyTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "StrangerSafetyTamil";

  final Map<int, String> correctAnswers = {
    1: "ஒரு குழந்தை அறிமுகமில்லாத அல்லது நம்பமுடியாத நபர்",
    2: "மறுக்கவும் விலகவும் செல்லவும்",
    3: "தெரிந்த பெரியவரிடம் கூறவும்",
    4: "அவசரகாலத்தில் நம்பத்தகுந்த நபரை உறுதிப்படுத்த",
    5: "கத்தி ஓடிச் செல்லவும் உதவி கோரவும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "அறிமுகமில்லாத நபர் யார்?",
      "options": [
        "ஒரு குழந்தை அறிமுகமில்லாத அல்லது நம்பமுடியாத நபர்",
        "ஒரு பள்ளி நண்பர்",
        "ஒரு ஆசிரியர்",
        "ஒரு அண்டையவர்"
      ]
    },
    {
      "question": "அறிமுகமில்லாத நபர் பரிசு கொடுத்தால் என்ன செய்ய வேண்டும்?",
      "options": [
        "மறுக்கவும் விலகவும் செல்லவும்",
        "நன்றி சொல்லவும்",
        "அமைதியாக ஏற்கவும்",
        "பெற்றோர்களிடம் காட்ட செல்லவும்"
      ]
    },
    {
      "question": "ஒரு அறிமுகமில்லாத நபர் அழைத்தால் என்ன செய்ய வேண்டும்?",
      "options": [
        "தெரிந்த பெரியவரிடம் கூறவும்",
        "விரைவாக சென்று விடவும்",
        "அவர்களின் நாயைப் பெற உதவவும்",
        "முதலில் பணம் கேட்கவும்"
      ]
    },
    {
      "question": "குடும்ப ரகசிய குறியீடு என்ன?",
      "options": [
        "அவசரகாலத்தில் நம்பத்தகுந்த நபரை உறுதிப்படுத்த",
        "வீட்டின் கதவை திறக்க",
        "விளையாட்டுக்காக",
        "தொலைபேசியைத் திறக்க"
      ]
    },
    {
      "question": "அறிமுகமில்லாத நபர் பிடிக்க முயற்சித்தால் என்ன செய்வது?",
      "options": [
        "கத்தி ஓடிச் செல்லவும் உதவி கோரவும்",
        "அமைதியாக நின்று கொள்ளவும்",
        "அவருடன் அமைதியாக சென்று விடவும்",
        "அவருடன் பேசவும்"
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
              title: Text("அறிமுகமில்லாத நபர் பாதுகாப்பு - வினா விடை"),
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
                        SnackBar(content: Text("அனைத்து வினாக்களுக்கும் பதிலளிக்கவும்")),
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
          title: Text("மதிப்பீட்டு முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/home_safety_ta');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF4500), Color(0xFF5B0000)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("அறிமுகமில்லாத நபர் பாதுகாப்பு"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🧒 அறிமுகமில்லாத நபர் யார்?", "குழந்தைக்கு தெரியாத நபர் அல்லது நம்ப முடியாத நபர்.", imagePath: 'assets/kids_2.1.png'),
                  _buildQuestionAnswer("🎁 பரிசுகள் கொடுத்தால்?", "மறுக்கவும் மற்றும் நம்பத்தகுந்த பெரியவரிடம் கூறவும்."),
                  _buildQuestionAnswer("🚫 அறிமுகமில்லாத நபர் அழைத்தால்?", "தெரிந்த பெரியவரிடம் உடனடியாக கூறவும்.", imagePath: 'assets/kids_2.0.png'),
                  _buildQuestionAnswer("🔑 குடும்ப ரகசியக் குறியீடு?", "நம்பத்தகுந்த நபர்களை உறுதிப்படுத்த பயன்படும் ரகசிய வார்த்தை."),
                  _buildQuestionAnswer("🏃 பயப்படும்போது என்ன செய்ய வேண்டும்?", "கத்தி ஓடிச் செல்லவும் மற்றும் உதவி கோரவும்.", imagePath: 'assets/kids_2.2.png'),
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
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சிக்கவும்"),
              ),
          ],
        ),
      ),
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
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              ),
            if (imagePath != null)
              SizedBox(height: 12),
            Text(
              question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 6),
            Text(
              answer,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
