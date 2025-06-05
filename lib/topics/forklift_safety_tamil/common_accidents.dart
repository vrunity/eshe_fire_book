// common_accidents_ta.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/forklift_safety_tamil.dart';

class CommonAccidentsTamilPage extends StatefulWidget {
  @override
  _CommonAccidentsTamilPageState createState() => _CommonAccidentsTamilPageState();
}

class _CommonAccidentsTamilPageState extends State<CommonAccidentsTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ForkliftAccidentsTamil";

  final Map<int, String> correctAnswers = {
    1: "தூக்கப்பட்டு கவிழும் மற்றும் மோதும் விபத்துகள்",
    2: "ஏற்ற சக்தியை மீறுதல் அல்லது வேகமாக இயக்குதல்",
    3: "இயக்குநர் வெளியே தள்ளப்படுகிறார் அல்லது நொறுக்கப்படுகிறார்",
    4: "வேகம், தவறான திருப்பங்கள், சீரற்ற மேடைகள்",
    5: "எப்போதும் பாதுகாப்பு பட்டையை அணியவும்"
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "வழக்கமான ஃபோர்க்லிப்ட் விபத்துகள் எவை?",
      "options": ["சுழலும் டயர்கள்", "முடக்கப்பட்ட கண்ணாடிகள்", "தூக்கப்பட்டு கவிழும் மற்றும் மோதும் விபத்துகள்", "கூச்சல் தவிர்ப்பு"]
    },
    {
      "question": "ஃபோர்க்லிப்ட் கவிழ்வதற்கான முக்கிய காரணம் என்ன?",
      "options": ["நன்றாக ஒளிச்சூழல்", "ஏற்ற சக்தியை மீறுதல் அல்லது வேகமாக இயக்குதல்", "தீவிர இடைவேளை", "வெளி இடங்கள்"]
    },
    {
      "question": "பாதுகாப்பு பட்டை அணியவில்லை என்றால் என்ன நடக்கும்?",
      "options": ["தீவிரம் இல்லை", "இயக்குநர் வெளியே தள்ளப்படுகிறார் அல்லது நொறுக்கப்படுகிறார்", "அதிக வேகம்", "இயக்க சக்தி குறைகிறது"]
    },
    {
      "question": "கவிழ்வோட்ட ஆபத்தை அதிகரிக்க என்ன காரணம்?",
      "options": ["வேகம், தவறான திருப்பங்கள், சீரற்ற மேடைகள்", "புதிய டயர்கள்", "மின்கலம் குறைவாக உள்ளது", "தூய்மையான பங்குகள்"]
    },
    {
      "question": "பாதுகாப்புக்காக முக்கியமான உதவிக்குறிப்பு என்ன?",
      "options": ["கண்களை மூடு", "எப்போதும் பாதுகாப்பு பட்டையை அணியவும்", "வேகமாக ஓட்டு", "அறிகுறிகளை தவிர்"]
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
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
      isCompleted = true;
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
              title: Text("வினாடி வினா: பொதுவான விபத்துகள்"),
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
                        SnackBar(content: Text("தயவு செய்து அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
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
          title: Text("மதிப்பீடு முடிவு"),
          content: Text("நீங்கள் ${quizQuestions.length} வினாக்களில் $score மதிப்பெண் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/safety_precautions_ta');
                },
              ),
            TextButton(
              child: Text("மீண்டும் முயற்சி செய்க"),
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

  Widget _buildQA(String question, String answer, {String? imagePath}) {
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
        title: Text("பொதுவான விபத்துகள்"),
        backgroundColor: Colors.deepOrange,
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
                  _buildQA("🚧 கவிழ்ச்சி மற்றும் மோதல்கள்", "அதிக ஏற்றம் அல்லது கூர்மையான திருப்பங்கள் காரணமாக கவிழ்ச்சி ஏற்படலாம்.", imagePath: 'assets/forklift_3.0.png'),
                  _buildQA("⚠ இயக்குநர் வெளியே தள்ளப்படுதல்", "பாதுகாப்பு பட்டை இல்லாமல் இருந்தால் இயக்குநர் கவிழ்ச்சியின் போது வெளியே தள்ளப்படலாம்."),
                  _buildQA("📦 தவறான சரக்குகள்", "தவறாக சுமத்தப்பட்ட அல்லது மிகப் பெரிய சரக்குகள் விழும் ஆபத்தை ஏற்படுத்தும்."),
                  _buildQA("🔊 சத்த ஒலி பாதிப்பு", "சத்தமுள்ள இடங்களில் அறிகுறிகளை கேட்க முடியாததால் விபத்து வாய்ப்பு அதிகரிக்கிறது."),
                  _buildQA("✅ பாதுகாப்பு பட்டை", "கவிழ்ச்சியின் போது காயங்களைத் தவிர்க்க பாதுகாப்பு பட்டையை அணிய வேண்டும்.", imagePath: 'assets/forklift_3.1.png'),
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
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி செய்க")),
          ],
        ),
      ),
    );
  }
}
