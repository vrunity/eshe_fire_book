import 'package:e_she_book/tamil/road_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleSafetyPageTamil extends StatefulWidget {
  @override
  _VehicleSafetyPageTamilState createState() => _VehicleSafetyPageTamilState();
}

class _VehicleSafetyPageTamilState extends State<VehicleSafetyPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "VehicleSafetyTamil";

  final Map<int, String> correctAnswers = {
    1: "பிரேக், லைட்டுகள் மற்றும் டயர்கள்",
    2: "Seat belt அணிய வேண்டும்",
    3: "மதுவை தவிர்க்க வேண்டும்",
    4: "பிற வாகனங்களிலிருந்து பாதுகாப்பான தூரத்தை பராமரிக்கவும்",
    5: "திரும்பும்போது அல்லது பாதையை மாற்றும்போது",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "வாகனத்தில் எந்த பகுதிகளை அடிக்கடி சரிபார்க்க வேண்டும்?",
      "options": ["பிரேக், லைட்டுகள் மற்றும் டயர்கள்", "பெயிண்ட் மற்றும் ஸ்டிக்கர்கள்", "சீட் கவர்கள்", "மியூசிக் சிஸ்டம்"]
    },
    {
      "question": "அனைத்து பயணிகளுக்கும் என்ன அவசியம்?",
      "options": ["Seat belt அணிய வேண்டும்", "காற்றோட்டம்", "இசை கேட்க", "தொலைபேசியை பயன்படுத்த"]
    },
    {
      "question": "வாகன ஓட்டத்திற்கு முன் என்ன தவிர்க்க வேண்டும்?",
      "options": ["மதுவை தவிர்க்க வேண்டும்", "தண்ணீர் குடிக்க", "பேசிக்கொண்டு செல்ல", "Seat belt அணிய"]
    },
    {
      "question": "பாதுகாப்பாக ஓட்ட எவ்வாறு செய்ய வேண்டும்?",
      "options": ["பிற வாகனங்களிலிருந்து பாதுகாப்பான தூரத்தை பராமரிக்கவும்", "பின்னால் ஒட்டிக்கொள்கிறீர்கள்", "போட்டி ஓட்ட", "தவறான ஹாரன்"]
    },
    {
      "question": "எப்போது சிக்னல்களை பயன்படுத்த வேண்டும்?",
      "options": ["திரும்பும்போது அல்லது பாதையை மாற்றும்போது", "ரிவர்ஸில் மட்டும்", "போலீஸ் வாகனங்களை ஓட்டும்போது", "அவை தேவையில்லை"]
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
              title: Text("வாகன பாதுகாப்பு வினா"),
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
          title: Text("வினா முடிவுகள்"),
          content: Text("நீங்கள் ${quizScore} / ${quizQuestions.length} மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/emergency_actions_ta');
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => RoadSafetyTamil()),
              );
            },
          ),
          title: Text("வாகன பாதுகாப்பு குறிப்புகள்")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🚗 எப்போதும் சரிபார்க்க வேண்டிய பகுதிகள்?", "பிரேக், லைட்டுகள் மற்றும் டயர்கள்.", imagePath: 'assets/road_4.0.png'),
                  _buildQuestionAnswer("🚗 பயணிகளுக்கு அவசியமானது?", "Seat belt அணிய வேண்டும்."),
                  _buildQuestionAnswer("🚗 ஓட்டதற்கு முன் தவிர்க்க வேண்டியது?", "மதுவை தவிர்க்க வேண்டும்.", imagePath: 'assets/road_4.3.png'),
                  _buildQuestionAnswer("🚗 பாதுகாப்பாக ஓட்டுவது எப்படி?", "பிற வாகனங்களிலிருந்து பாதுகாப்பான தூரத்தை பராமரிக்கவும்."),
                  _buildQuestionAnswer("🚗 சிக்னல்களை எப்போது பயன்படுத்த வேண்டும்?", "திரும்பும்போது அல்லது பாதையை மாற்றும்போது.", imagePath: 'assets/road_4.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) {
                _saveTopicCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சி செய்யவும்"),
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
