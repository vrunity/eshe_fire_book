import 'package:e_she_book/tamil/emergency_handling_tamil.dart';
import 'package:e_she_book/topics/emergency_handling_english/emergency_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyPreparednessTamil extends StatefulWidget {
  @override
  _EmergencyPreparednessStateTamil createState() => _EmergencyPreparednessStateTamil();
}

class _EmergencyPreparednessStateTamil extends State<EmergencyPreparednessTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicKey = "EmergencyPreparedness";

  final Map<int, String> correctAnswers = {
    1: "பீதி மற்றும் குழப்பத்தை குறைக்க",
    2: "அவசர வெளியீடுகள் மற்றும் நடைமுறைகள்",
    3: "அனைவரும்",
    4: "ஆம், தவிர்க்க முடியாத பயிற்சிகள் தயார்பாட்டை மேம்படுத்தும்",
    5: "விரைவான பதில் மற்றும் பாதுகாப்பை உறுதிப்படுத்த"
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "அவசரத்திற்கான தயார்ப்பு ஏன் முக்கியம்?",
      "options": [
        "பீதி மற்றும் குழப்பத்தை குறைக்க",
        "சத்தம் செய்ய",
        "பொறுப்புகளைத் தவிர்க்க",
        "நடவடிக்கையை தாமதிக்க"
      ]
    },
    {
      "question": "ஒரு அவசரத் திட்டத்தில் என்ன இருக்க வேண்டும்?",
      "options": [
        "ஊழியர்களின் பிறந்த நாட்கள்",
        "அவசர வெளியீடுகள் மற்றும் நடைமுறைகள்",
        "உணவக பட்டியல்",
        "உடை விதிமுறை"
      ]
    },
    {
      "question": "அவசரத் திட்டத்தை யாரெல்லாம் தெரிந்திருக்க வேண்டும்?",
      "options": [
        "முகாமையர்கள் மட்டும்",
        "பாதுகாப்பு பேர் மட்டும்",
        "அனைவரும்",
        "விருந்தினர்கள் மட்டும்"
      ]
    },
    {
      "question": "நிறுவனங்கள் தவிர்க்க முடியாத பயிற்சிகளை நடத்த வேண்டுமா?",
      "options": [
        "இல்லை, தேவையில்லை",
        "ஆம், தவிர்க்க முடியாத பயிற்சிகள் தயார்பாட்டை மேம்படுத்தும்",
        "வருடத்திற்கு ஒருமுறை மட்டும்",
        "ஒருபோதும் இல்லை"
      ]
    },
    {
      "question": "தயார்ப்பு பயிற்சியின் நோக்கம் என்ன?",
      "options": [
        "நேரத்தை வீணாக்க",
        "விரைவான பதில் மற்றும் பாதுகாப்பை உறுதிப்படுத்த",
        "ஊழியர்களை குழப்ப",
        "பணம் செலவழிக்க"
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
              title: Text("வினாடி வினா: அவசரத் தயார் நிலை"),
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
                    MaterialPageRoute(builder: (_) => EmergencyResponse()),
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
        title: Text("அவசரத் தயார் நிலை"),
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
                  _buildQA("ஏன் அவசரத்திற்கு தயாராக வேண்டும்?", "பீதி மற்றும் குழப்பத்தை குறைக்க."),
                  _buildQA("திட்டங்களில் என்ன சேர்க்க வேண்டும்?", "அவசர வெளியீடுகள் மற்றும் நடைமுறைகள்.", imagePath: 'assets/preparedness_1.png'),
                  _buildQA("யார் திட்டத்தை தெரிந்திருக்க வேண்டும்?", "நிறுவனத்தில் உள்ள அனைவரும்."),
                  _buildQA("பயிற்சிகள் உதவிகரமானதா?", "ஆம், தவிர்க்க முடியாத பயிற்சிகள் தயார்பாட்டை மேம்படுத்தும்."),
                  _buildQA("பயிற்சி நோக்கம்?", "விரைவான பதில் மற்றும் பாதுகாப்பை உறுதிப்படுத்த.", imagePath: 'assets/preparedness_2.png'),
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
