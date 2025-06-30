import 'package:e_she_book/topics/emergency_handling_english/emergency_types.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/emergency_handling_tamil.dart';

class IntroductionToEmergencyTamil extends StatefulWidget {
  @override
  _IntroductionToEmergencyStateTamil createState() => _IntroductionToEmergencyStateTamil();
}

class _IntroductionToEmergencyStateTamil extends State<IntroductionToEmergencyTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicKey = "IntroductionToEmergency";

  final Map<int, String> correctAnswers = {
    1: "உடனடி ஆபத்து ஏற்படும் நிலை",
    2: "பாதுகாப்பை உறுதிப்படுத்த",
    3: "வெள்ளம்",
    4: "தீ அணைக்கும் படை",
    5: "உடனடியாகவும், பயனுள்ள செயல்களை மேற்கொள்வதற்காக"
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "அவசர நிலை என்றால் என்ன?",
      "options": [
        "சிறிய பிரச்சனை",
        "பயிற்சி நடைமுறை",
        "உடனடி ஆபத்து ஏற்படும் நிலை",
        "திட்டமிட்ட நிகழ்வு"
      ]
    },
    {
      "question": "அவசர நிலைக்கு ஏன் தயாராக வேண்டும்?",
      "options": [
        "பீதி ஏற்படுத்த",
        "பாதுகாப்பை உறுதிப்படுத்த",
        "ஊடகம் கவனிக்க",
        "அலங்காரத்திற்காக"
      ]
    },
    {
      "question": "பின்வருவனவற்றில் எது இயற்கை பேரிடர்?",
      "options": [
        "எரிவாயு கசிவு",
        "மின்னணு தாக்குதல்",
        "வெள்ளம்",
        "பயங்கரவாதம்"
      ]
    },
    {
      "question": "பாதுகாப்பு பயிற்சிகளை யார் நடத்துகிறார்கள்?",
      "options": [
        "தீ அணைக்கும் படை",
        "வங்கிகள்",
        "உணவகங்கள்",
        "எவரும் இல்லை"
      ]
    },
    {
      "question": "அவசர நிலை கையாளலின் நோக்கம் என்ன?",
      "options": [
        "செயல்களை தாமதிக்க",
        "மக்களை பீதி அடையச் செய்ய",
        "உடனடியாகவும், பயனுள்ள செயல்களை மேற்கொள்வதற்காக",
        "நிகழ்வை புறக்கணிக்க"
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
              title: Text("வினாடி வினா: அவசர நிலை அறிமுகம்"),
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
                    MaterialPageRoute(builder: (_) => EmergencyTypes()),
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
        title: Text("அவசர நிலை அறிமுகம்"),
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
                  _buildQA("அவசர நிலை என்றால் என்ன?", "அவசர நிலை என்பது உடனடி ஆபத்து ஏற்படும் நிலை, இது உடல், உயிர், சொத்து அல்லது சூழல் ஆகியவற்றிற்கு ஆபத்து தரும்.", imagePath: 'assets/emergency_1.png'),
                  _buildQA("அவசர நிலைக்கு ஏன் தயாராக வேண்டும்?", "இயற்கை மற்றும் மனிதனால் ஏற்படும் பேரிடர்களில் பாதுகாப்பை உறுதிப்படுத்த."),
                  _buildQA("அவசர நிலைகளுக்கான எடுத்துக்காட்டு", "வெள்ளம், நிலநடுக்கம், வெடிப்பு, தீ, ரசாயன கசிவு போன்றவை.", imagePath: 'assets/emergency_2.png'),
                  _buildQA("பயிற்சி நிகழ்வுகளை யார் நடத்துகிறார்கள்?", "தீ அணைக்கும் படை, பாதுகாப்பு துறை மற்றும் SEED FOR SAFETY போன்ற நிறுவங்கள்."),
                  _buildQA("அவசர நிலை கையாளலின் நோக்கம்", "சேதம் அல்லது காயம் வராமல் தடுக்கும் வகையில் உடனடி மற்றும் பயனுள்ள செயல்களை எடுக்க.", imagePath: 'assets/emergency_3.png'),
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
