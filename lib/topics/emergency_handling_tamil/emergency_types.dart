import 'package:e_she_book/topics/emergency_handling_english/emergency_preparedness.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/emergency_handling_tamil.dart';

class EmergencyTypesTamil extends StatefulWidget {
  @override
  _EmergencyTypesStateTamil createState() => _EmergencyTypesStateTamil();
}

class _EmergencyTypesStateTamil extends State<EmergencyTypesTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicKey = "TypesOfEmergency";

  final Map<int, String> correctAnswers = {
    1: "வெள்ளம்",
    2: "தீ",
    3: "சரியான பதில்களை செய்ய",
    4: "வைரஸ் பரவல்",
    5: "மேலும் நல்ல தயார்ப்பை ஏற்படுத்த"
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "பின்வருவனவற்றில் எது இயற்கை பேரிடராகும்?",
      "options": [
        "மின்னணு தாக்குதல்",
        "வெள்ளம்",
        "ரசாயன உமிழ்வு",
        "எரிவாயு வெடிப்பு"
      ]
    },
    {
      "question": "பின்வருவனவற்றில் எது மனிதனால் உண்டாகும் அவசர நிலை?",
      "options": [
        "நிலநடுக்கம்",
        "சுழன்ற காற்று",
        "தீ",
        "மின்னல்"
      ]
    },
    {
      "question": "அவசர நிலைகளின் வகைகளை அறிந்து கொள்வது ஏன் முக்கியம்?",
      "options": [
        "வதந்திக்காக",
        "நடவடிக்கையை தாமதிக்க",
        "சரியான பதில்களை செய்ய",
        "ஊடகத் தகவலுக்காக"
      ]
    },
    {
      "question": "உயிரியல் அச்சுறுத்தலுக்கான எடுத்துக்காட்டு எது?",
      "options": [
        "சாலை விபத்து",
        "தீ",
        "வைரஸ் பரவல்",
        "வெள்ளம்"
      ]
    },
    {
      "question": "அவசர நிலை வகைப்பாடு எப்படி உதவுகிறது?",
      "options": [
        "அனைத்து ஆபத்தையும் தவிர்க்க",
        "வேடிக்கை நடவடிக்கைகள் வழங்க",
        "மேலும் நல்ல தயார்ப்பை ஏற்படுத்த",
        "சிறிய அபாயங்களை புறக்கணிக்க"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCompleted = prefs.getBool('Completed_$topicKey') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicKey') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicKey') ?? false;
    });
  }

  Future<void> _saveCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicKey', value);
    setState(() {
      isCompleted = value;
    });
    if (value) _showQuizDialog();
  }

  Future<void> _saveQuizScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('QuizScore_$topicKey', score);
    await prefs.setBool('QuizTaken_$topicKey', true);
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
              title: Text("வினாடி வினா: அவசர நிலை வகைகள்"),
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
                  child: Text("சமர்ப்பி"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("அனைத்து கேள்விகளுக்கும் பதில் அளிக்கவும்")),
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
          title: Text("வினாடி வினா முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} பெற்றுள்ளீர்கள்."),
          actions: [
            if (score >= 3)
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => EmergencyPreparedness()),
                  );
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
        title: Text("அவசர நிலை வகைகள்"),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => EmergencyHandlingTamil()),
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
                  _buildQA("இயற்கை பேரிடர்கள் என்றால் என்ன?", "வெள்ளம், கனமழை, சுழன்ற காற்று, நிலநடுக்கம் போன்ற நிகழ்வுகள்.", imagePath: 'assets/emergency_types_1.png'),
                  _buildQA("மனிதனால் உண்டாகும் பேரிடர்கள்?", "வெடிப்பு, தீ, ரசாயன மற்றும் உயிரியல் தாக்குதல் போன்றவை."),
                  _buildQA("அவசர நிலைகள் மனிதர்களை எப்படி பாதிக்கின்றன?", "அவை காயம், உயிரிழப்பு மற்றும் சொத்துச்சேதம், சூழல் சேதம் ஏற்படுத்தும்."),
                  _buildQA("வகைப்பாடு ஏன் முக்கியம்?", "சரியான தயார்ப்பு மற்றும் பதில் திட்டங்களை நடைமுறைப்படுத்த."),
                  _buildQA("வகைகளை புரிந்து கொள்வது எப்படி உதவும்?", "மேலும் நல்ல ஆபத்து அடையாளம், விரைவான முடிவெடுப்பு", imagePath: 'assets/emergency_types_2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) {
                _saveCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசியாக பெற்ற மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி")),
          ],
        ),
      ),
    );
  }
}
