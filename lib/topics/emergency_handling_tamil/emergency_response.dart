import 'package:e_she_book/topics/emergency_handling_english/post_emergency_action.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/emergency_handling_tamil.dart';

class EmergencyResponseTamil extends StatefulWidget {
  @override
  _EmergencyResponseStateTamil createState() => _EmergencyResponseStateTamil();
}

class _EmergencyResponseStateTamil extends State<EmergencyResponseTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicKey = "EmergencyResponse";

  final Map<int, String> correctAnswers = {
    1: "அவசர சேவை எண்களுக்கு அழைக்கவும்",
    2: "அமைதியாக இருந்து நடைமுறைகளைப் பின்பற்றவும்",
    3: "ஆம், அவை செயல்களை வழிநடத்த உதவுகின்றன",
    4: "ஏற்றுமதி செய்தபோது எலிவேட்டரைத் தவிர்த்து பிறருக்கு உதவி செய்யவும்",
    5: "ஜீவனை காக்கவும், சேதத்தை குறைக்கவும்"
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "அவசர நிலையில் முதலில் என்ன செய்ய வேண்டும்?",
      "options": [
        "பீதி அடையவும்",
        "அவசர சேவை எண்களுக்கு அழைக்கவும்",
        "நிகழ்வை புறக்கணிக்கவும்",
        "சிறிது ஓய்வெடுக்கவும்"
      ]
    },
    {
      "question": "அவசர நிலையில் எப்படிப் பழக வேண்டும்?",
      "options": [
        "அசைவாக ஓடவும்",
        "அமைதியாக இருந்து நடைமுறைகளைப் பின்பற்றவும்",
        "கத்தவும்",
        "உறையவும்"
      ]
    },
    {
      "question": "அவசர சைகைகள் (signs) முக்கியமா?",
      "options": [
        "இல்லை, அவை விருப்பப்படி",
        "ஆம், அவை செயல்களை வழிநடத்த உதவுகின்றன",
        "விருந்தினர்களுக்காக மட்டும்",
        "அவை குழப்பத்தை உருவாக்கும்"
      ]
    },
    {
      "question": "ஏற்றுமதியில் (evacuation) என்ன செய்ய வேண்டும்?",
      "options": [
        "எலிவேட்டர் பயன்படுத்தவும்",
        "மற்றவர்களை தள்ளவும்",
        "ஏற்றுமதியில் எலிவேட்டரைத் தவிர்த்து பிறருக்கு உதவி செய்யவும்",
        "சொந்த பொருட்களை எடுக்கத் திரும்பவும்"
      ]
    },
    {
      "question": "பதிலளிப்பு பயிற்சி ஏன் தேவை?",
      "options": [
        "நேரத்தை வீணாக்க",
        "ஜீவனை காக்கவும், சேதத்தை குறைக்கவும்",
        "வேடிக்கைக்காக",
        "மேலே உள்ள எதுவும் இல்லை"
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
              title: Text("வினாடி வினா: அவசர பதிலளிப்பு"),
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
                    MaterialPageRoute(builder: (_) => PostEmergencyActions()),
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
        title: Text("அவசர பதிலளிப்பு"),
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
                  _buildQA("அவசர நிலையில் முதலில் செய்ய வேண்டியது", "உடனே அவசர சேவை எண்களுக்கு அழைக்கவும்.", imagePath: 'assets/response_1.png'),
                  _buildQA("அவசர நிலையில் எப்படி பழக வேண்டும்", "அமைதியாக இருந்து நடைமுறைகளைப் பின்பற்றவும்."),
                  _buildQA("அவசர சைகைகள் பயனுள்ளதா?", "ஆம், அவை செயல்களை வழிநடத்த உதவுகின்றன."),
                  _buildQA("ஏற்றுமதிக்குப் போது...", "ஏற்றுமதியில் எலிவேட்டரைத் தவிர்த்து பிறருக்கு உதவி செய்யவும்.", imagePath: 'assets/response_2.png'),
                  _buildQA("பதிலளிப்பு பயிற்சி ஏன் முக்கியம்", "ஜீவனை காக்கவும், சேதத்தை குறைக்கவும்."),
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
