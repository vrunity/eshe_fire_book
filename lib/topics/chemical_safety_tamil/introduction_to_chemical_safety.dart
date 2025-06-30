import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/chemical_safety_tamil.dart';

class ChemicalIntroPageTamil extends StatefulWidget {
  @override
  _ChemicalIntroPageTamilState createState() => _ChemicalIntroPageTamilState();
}

class _ChemicalIntroPageTamilState extends State<ChemicalIntroPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ChemicalIntro";

  final Map<int, String> correctAnswers = {
    1: "வேலைநிலைகளில் ரசாயன ஆபத்துகளிலிருந்து ஊழியர்களைக் காப்பதற்காக.",
    2: "தோல் தொடுதல், மூச்சு இழுத்தல், உட்புகுத்தல்.",
    3: "ஆம், அது தீப்புண்கள், விஷம் மற்றும் புற்றுநோயை ஏற்படுத்தலாம்.",
    4: "பாதுகாப்பான கையாளுதல் மற்றும் அவசர நடவடிக்கைகளை அறிதலால்.",
    5: "பாதுகாப்பான மற்றும் ஆரோக்கியமான வேலைநிலையை உறுதி செய்ய."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "ரசாயன பாதுகாப்பு ஏன் முக்கியம்?",
      "options": [
        "வேலைநிலைகளில் ரசாயன ஆபத்துகளிலிருந்து ஊழியர்களைக் காப்பதற்காக.",
        "ஆவணப் பணியை அதிகரிக்க.",
        "திட்டங்களைத் தாமதப்படுத்த.",
        "பயிற்சியை கடினமாக்க."
      ]
    },
    {
      "question": "ரசாயன தாக்கங்கள் ஏற்படக்கூடிய வழிகள் என்ன?",
      "options": [
        "தோல் தொடுதல், மூச்சு இழுத்தல், உட்புகுத்தல்.",
        "தொலைபேசி மற்றும் மின்னஞ்சல்.",
        "உயர்ந்த சத்தங்களை கேட்குதல்.",
        "வெயிலும் குளிரும்."
      ]
    },
    {
      "question": "ரசாயனங்கள் தீவிர பாதிப்புகளை ஏற்படுத்துமா?",
      "options": [
        "ஆம், அது தீப்புண்கள், விஷம் மற்றும் புற்றுநோயை ஏற்படுத்தலாம்.",
        "இல்லை, எப்போதும் பாதுகாப்பானவை.",
        "தொடும்போது மட்டுமே.",
        "கலந்தால் மட்டுமே."
      ]
    },
    {
      "question": "ரசாயன ஆபத்துகளை எப்படி குறைக்கலாம்?",
      "options": [
        "அவற்றை புறக்கணிப்பதன் மூலம்.",
        "பாதுகாப்பான கையாளுதல் மற்றும் அவசர நடவடிக்கைகளை அறிதலால்.",
        "வேலையை விரைவில் செய்வதன் மூலம்.",
        "ரசாயனங்களை பயன்படுத்தாமலிருக்க."
      ]
    },
    {
      "question": "ஊழியர்கள் ரசாயன பாதுகாப்பு பயிற்சி பெறவேண்டுமா?",
      "options": [
        "பாதுகாப்பான மற்றும் ஆரோக்கியமான வேலைநிலையை உறுதி செய்ய.",
        "மதிப்பெண்களை விரைவில் பெற.",
        "வேலை இழப்பதை தவிர்க்க.",
        "நேரத்தை சேமிக்க."
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
      isCompleted = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveCompletion(bool value) async {
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
              title: Text("வினா: ரசாயன பாதுகாப்பு அறிமுகம்"),
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
                  child: Text("சமர்ப்பிக்க"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
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
      if (correctAnswers[key] == value) score++;
    });
    _saveQuizScore(score);
    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("வினா முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/hazard_communication_ta');
                },
              ),
            TextButton(
              child: Text("மீளத்தேர்வு"),
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
        title: Text("ரசாயன பாதுகாப்பு அறிமுகம்"),
        backgroundColor: Colors.teal[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ChemicalSafetyTamil()),
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
                  _buildQA("🧪 ரசாயன பாதுகாப்பு என்றால் என்ன?", "இது ரசாயனங்களை சரியாக கையாளும், பயன்படுத்தும் மற்றும் அகற்றும் முறையை குறிக்கிறது."),
                  _buildQA("📛 ஆபத்துகள்", "ரசாயனங்கள் விஷகரமானவை, எளிதில் எரியும், அரைக்கும் அல்லது எதிர்வினை செய்யக்கூடியவை.", imagePath: 'assets/chemical_1.0.png'),
                  _buildQA("📋 பயிற்சியின் முக்கியத்துவம்", "ஊழியர்கள் ரசாயன ஆபத்துகள் மற்றும் பதில்களைப் பற்றிப் படிக்க வேண்டும்."),
                  _buildQA("💼 நிர்வாகிகளின் பங்கு", "SDS, பாதுகாப்பு உபகரணங்கள் மற்றும் பயிற்சி வழங்க வேண்டும்.", imagePath: 'assets/chemical_1.1.png'),
                  _buildQA("⚠️ நோக்கம்", "ரசாயனங்கள் தொடர்பான காயங்கள் மற்றும் நோய்களைத் தவிர்ப்பது."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்க"),
              value: isCompleted,
              onChanged: (value) => _saveCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீளத் தேர்வு")),
          ],
        ),
      ),
    );
  }
}
