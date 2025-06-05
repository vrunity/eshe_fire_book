import 'package:e_she_book/tamil/kids_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyPreparednessTamilPage extends StatefulWidget {
  @override
  _EmergencyPreparednessTamilPageState createState() => _EmergencyPreparednessTamilPageState();
}

class _EmergencyPreparednessTamilPageState extends State<EmergencyPreparednessTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EmergencyPreparednessTamil";

  final Map<int, String> correctAnswers = {
    1: "ஆபத்தான சூழ்நிலைகளில் என்ன செய்ய வேண்டும் என்று தெரிந்திருத்தல்.",
    2: "அவசர எண்கள் மற்றும் வீட்டு முகவரியை மனப்பாடமாகக் கொள்ள வேண்டும்.",
    3: "தீவிபத்து அல்லது நிலநடுக்கம் போன்ற சூழ்நிலைகளில் தயாராக இருப்பதற்காக.",
    4: "அமைதியாக இருந்து பெரியவர்களின் வழிகாட்டல்களைப் பின்பற்ற வேண்டும்.",
    5: "முதல் உதவி மூலம் நிச்சயமான உதவி வரும் வரை பாதுகாப்பாக கையாள முடியும்.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "அவசர நிலை தயாராக இருப்பது என்றால் என்ன?",
      "options": [
        "ஆபத்தான சூழ்நிலைகளில் என்ன செய்ய வேண்டும் என்று தெரிந்திருத்தல்.",
        "ஆபத்தில் விளையாடுவது.",
        "நண்பர்களை அழைத்து உதவி கேட்பது.",
        "எங்கும் ஓடுவது."
      ]
    },
    {
      "question": "குழந்தைகள் என்னை மனப்பாடமாகக் கொள்ள வேண்டும்?",
      "options": [
        "அவசர எண்கள் மற்றும் வீட்டு முகவரி.",
        "கார்ட்டூன் கதாபாத்திரங்கள்.",
        "நண்பனின் பிடித்த நிறம்.",
        "சைக்கிள் ஓட்டுவது எப்படி."
      ]
    },
    {
      "question": "ஏன் பாதுகாப்பு பயிற்சி நடத்த வேண்டும்?",
      "options": [
        "தீவிபத்து அல்லது நிலநடுக்கம் போன்ற சூழ்நிலைகளில் தயாராக இருக்க.",
        "பாடசாலைக்கு போகவில்லை என்பதற்காக.",
        "சூப்பர்ஹீரோக்கள் போல நடிக்க.",
        "அதிகமாக பீதி கொள்ள."
      ]
    },
    {
      "question": "அவசர நிலைகளில் எப்படி நடந்து கொள்ள வேண்டும்?",
      "options": [
        "அமைதியாக இருந்து பெரியவர்களின் வழிகாட்டல்களை பின்பற்ற வேண்டும்.",
        "படுக்கையின் கீழே மறைவது.",
        "மிகவும் அழுதல்.",
        "கத்தி ஓடுதல்."
      ]
    },
    {
      "question": "முதல் உதவி ஏன் பயனுள்ளதாக இருக்கிறது?",
      "options": [
        "முழுமையான உதவி வரும் வரை பாதுகாப்பாக கையாள உதவும்.",
        "அதனால் நீங்கள் நவீனமாக தெரிகிறீர்கள்.",
        "அது பயனில்லை.",
        "மருத்துவர்கள் மட்டுமே தெரிந்து கொள்ளவேண்டும்."
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
              title: Text("அவசர நிலை தயார்பு வினா"),
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
          title: Text("மதிப்பீடு முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3)
              TextButton(
                child: Text("முடிக்கவும்"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => KidsSafetyTamil()),
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
        title: Text("அவசர நிலை தயார்பு"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🚨 அவசர நிலைக்கு தயாராக இருப்பது என்றால்?", "தீ, வெள்ளம், புயல் போன்ற அபாயங்களில் என்ன செய்ய வேண்டும் என்று தெரிந்து கொள்வது.", imagePath: 'assets/kids_5.0.png'),
                  _buildQuestionAnswer("📞 குழந்தைகள் என்னை மனப்பாடமாகக் கொள்ள வேண்டும்?", "தொலைபேசி எண்கள், முகவரி மற்றும் பெற்றோர் பெயர்கள்."),
                  _buildQuestionAnswer("🔥 பயிற்சி நடத்துவதன் நோக்கம்?", "அவசர சூழ்நிலைகளில் தயார் நிலையில் இருக்க உதவும்.", imagePath: 'assets/kids_5.1.png'),
                  _buildQuestionAnswer("🧠 ஆபத்தில் எப்படி நடந்து கொள்ள வேண்டும்?", "அமைதியாக இருந்து பெரியவர்களின் வழிகாட்டல்களை பின்பற்ற வேண்டும்."),
                  _buildQuestionAnswer("💊 முதல் உதவி எதற்காக?", "உதவிக்குப் முன் காயமடைந்தவர்களை பாதுகாப்பாக கையாள உதவுகிறது.", imagePath: 'assets/kids_5.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்ததாக குறிக்கவும்"),
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
