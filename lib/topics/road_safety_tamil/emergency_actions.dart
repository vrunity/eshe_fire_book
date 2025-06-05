import 'package:e_she_book/tamil/road_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class EmergencyActionsPageTamil extends StatefulWidget {
  @override
  _EmergencyActionsPageTamilState createState() => _EmergencyActionsPageTamilState();
}

class _EmergencyActionsPageTamilState extends State<EmergencyActionsPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EmergencyActionsTamil";

  final Map<int, String> correctAnswers = {
    1: "அமைதியாக இருக்கவும் மற்றும் நிலையை மதிப்பீடு செய்யவும்",
    2: "முடிந்தால் வாகனத்தை பாதுகாப்பான இடத்திற்கு நகர்த்தவும்",
    3: "நிலையில் கணிப்பு செய்ததும் உடனே அழைக்கவும்",
    4: "பாதுகாப்பு விளக்குகளை இயக்கவும்",
    5: "பயிற்சி பெற்றிருந்தால் மற்றும் பாதுகாப்பானதாக இருந்தால் மட்டும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "விபத்துக்குப் பிறகு முதல் நடவடிக்கை என்ன?",
      "options": [
        "அமைதியாக இருக்கவும் மற்றும் நிலையை மதிப்பீடு செய்யவும்",
        "ஓடிச் செல்லவும்",
        "சத்தமாக கத்தவும்",
        "மற்றவர்களை குறை கூறவும்"
      ]
    },
    {
      "question": "விபத்துக்குப் பிறகு வாகனத்தை என்ன செய்ய வேண்டும்?",
      "options": [
        "முடிந்தால் வாகனத்தை பாதுகாப்பான இடத்திற்கு நகர்த்தவும்",
        "அதை விட்டுவிட்டு செல்லவும்",
        "சாலையில் நடுவே வைக்கவும்",
        "இறக்கம் இடத்திற்கு தள்ளவும்"
      ]
    },
    {
      "question": "எப்போது அவசர சேவையை அழைக்க வேண்டும்?",
      "options": [
        "நிலையில் கணிப்பு செய்ததும் உடனே அழைக்கவும்",
        "வாகனத்தை சரிசெய்த பிறகு",
        "போலீஸ் கேட்பின் பிறகு மட்டும்",
        "பிறகு தேவைப்பட்டால்"
      ]
    },
    {
      "question": "மற்ற வாகன ஓட்டுநர்களை எவ்வாறு எச்சரிக்கலாம்?",
      "options": [
        "பாதுகாப்பு விளக்குகளை இயக்கவும்",
        "கைகளை அலைக்கவும்",
        "பொருட்களை எறியவும்",
        "முடிவில்லாமல் ஹாரன் கொடுக்கவும்"
      ]
    },
    {
      "question": "முதலுதவி எப்போது வழங்கலாம்?",
      "options": [
        "பயிற்சி பெற்றிருந்தால் மற்றும் பாதுகாப்பானதாக இருந்தால் மட்டும்",
        "எப்போதும் சிந்திக்காமல் வழங்கவும்",
        "1 மணி நேரத்திற்குப் பிறகு மட்டும்",
        "முதலுதவியை வழங்கவே கூடாது"
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
              title: Text("அவசரநிலை நடவடிக்கைகள் வினா"),
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

  void _evaluateQuiz() async {
    int score = 0;
    userAnswers.forEach((key, value) {
      if (correctAnswers[key] == value) {
        score++;
      }
    });

    await _saveQuizScore(score);

    if (score >= 3) {
      final String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('CourseCompletedOn_Road Safety', formattedDate);
      print("✅ Road Safety குறித்த பயிற்சி முடிக்கப்பட்ட தேதி: $formattedDate");
    }

    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("வினா முடிவு"),
          content: Text("மொத்த வினாக்களில் $score மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RoadSafetyTamil()),
              ),
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
        title: Text("அவசரநிலை நடவடிக்கைகள்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🚨 விபத்துக்குப் பிறகு முதற்கட்ட நடவடிக்கை என்ன?", "அமைதியாக இருந்து நிலையை மதிப்பீடு செய்யவும்.", imagePath: 'assets/road_5.0.png'),
                  _buildQuestionAnswer("🚨 வாகனத்தை எப்படி கையாள வேண்டும்?", "முடிந்தால் பாதுகாப்பான இடத்திற்கு நகர்த்தவும்."),
                  _buildQuestionAnswer("🚨 எப்போது அவசர சேவையை அழைக்க வேண்டும்?", "நிலையில் கணிப்பு செய்ததும் உடனே அழைக்கவும்.", imagePath: 'assets/road_5.1.png'),
                  _buildQuestionAnswer("🚨 மற்ற வாகன ஓட்டுநர்களுக்கு எச்சரிக்கை அளிக்கும் முறை?", "பாதுகாப்பு விளக்குகளை இயக்கவும்."),
                  _buildQuestionAnswer("🚨 முதலுதவி வழங்கும் நேரம்?", "பயிற்சி பெற்றிருந்தால் மற்றும் பாதுகாப்பானதாக இருந்தால் மட்டும்.", imagePath: 'assets/road_5.2.png'),
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
