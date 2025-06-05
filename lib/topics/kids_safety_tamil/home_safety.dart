import 'package:e_she_book/tamil/kids_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSafetyTamilPage extends StatefulWidget {
  @override
  _HomeSafetyTamilPageState createState() => _HomeSafetyTamilPageState();
}

class _HomeSafetyTamilPageState extends State<HomeSafetyTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "HomeSafetyTamil";

  final Map<int, String> correctAnswers = {
    1: "கூரிய பொருட்கள் மற்றும் ரசாயனங்களை எட்டாத இடத்தில் வைக்க வேண்டும்.",
    2: "மின் சாக்கெட்டுகளோடு விளையாடக்கூடாது.",
    3: "அடுக்கு ஓவென்கள் வேலை செய்யும் போது அருகில் செல்லக் கூடாது.",
    4: "உடனடியாக பெரியவரிடம் தகவல் கூற வேண்டும்.",
    5: "உள்ளே இருப்பதும், மின் ஸ்விட்ச்களைத் தொடாமல் இருப்பதும் பாதுகாப்பு.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "கூரிய சாதனங்கள் மற்றும் ரசாயனங்களை எப்படி கையாள வேண்டும்?",
      "options": [
        "கூரிய பொருட்கள் மற்றும் ரசாயனங்களை எட்டாத இடத்தில் வைக்க வேண்டும்.",
        "குழந்தைகளுக்கு அருகில் வைக்க வேண்டும்.",
        "விளையாட பயன்படுத்த வேண்டும்.",
        "வெளியே திறந்தவையாக வைக்க வேண்டும்."
      ]
    },
    {
      "question": "மின் சாக்கெட்டுகளைப் பற்றி எதை தவிர்க்க வேண்டும்?",
      "options": [
        "மின் சாக்கெட்டுகளோடு விளையாடக்கூடாது.",
        "தண்ணீரோடு தொடவும்.",
        "பிளக் செய்து பார்வையிடவும்.",
        "பென்சிலால் அழுத்தவும்."
      ]
    },
    {
      "question": "அடுப்புறையில் குழந்தைகள் எப்படி இருக்க வேண்டும்?",
      "options": [
        "வயசானவர்கள் சமைக்கும் போது அருகில் இருக்கக்கூடாது.",
        "வெப்பமான பாத்திரங்களைத் தொட வேண்டும்.",
        "அடுப்பை இயக்க வேண்டும்.",
        "பிளேட் மற்றும் கத்தியை விளையாடப் பயன்படுத்த வேண்டும்."
      ]
    },
    {
      "question": "மின் கம்பி உடைந்தால் என்ன செய்ய வேண்டும்?",
      "options": [
        "உடனடியாக பெரியவரிடம் தகவல் கூற வேண்டும்.",
        "தொட்டு சரிபார்க்க வேண்டும்.",
        "நாமே சரி செய்ய முயற்சிக்க வேண்டும்.",
        "புறக்கணிக்கலாம்."
      ]
    },
    {
      "question": "புயல் அல்லது மின் தடைகள் ஏற்பட்டால் என்ன செய்ய வேண்டும்?",
      "options": [
        "உள்ளே இருப்பதும், மின் ஸ்விட்ச்களைத் தொடாமல் இருப்பதும் பாதுகாப்பு.",
        "வெளியே ஓட வேண்டும்.",
        "அனைத்து சாதனங்களையும் இயக்க வேண்டும்.",
        "அனைத்து ஃபேன்களையும் இயக்க வேண்டும்."
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
              title: Text("வீட்டு பாதுகாப்பு - வினா விடை"),
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
                  Navigator.pushNamed(context, '/outdoor_safety_ta');
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
        title: Text("வீட்டு பாதுகாப்பு"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🏠 கூரிய அல்லது ஹார்ம் பொருட்கள்?", "கத்தி, கத்தரிக்கோல், ரசாயனங்களை பாதுகாப்பாக வைக்க வேண்டும்.", imagePath: 'assets/kids_3.0.png'),
                  _buildQuestionAnswer("⚡ மின் பாதுகாப்பு?", "ஈரக் கைகளால் ஸ்விட்ச்களைத் தொடக்கூடாது."),
                  _buildQuestionAnswer("🔥 சமையலறை பாதுகாப்பு?", "அடுப்புகள் இயங்கும் போது அருகில் செல்லக் கூடாது.", imagePath: 'assets/kids_3.1.png'),
                  _buildQuestionAnswer("🧯 எதாவது உடைந்தால்?", "தொடாமல், உடனே பெரியவரிடம் தெரிவிக்க வேண்டும்."),
                  _buildQuestionAnswer("🌧️ மின்னல் அல்லது மின்தடை ஏற்பட்டால்?", "அனைத்து மின் சாதனங்களிலிருந்தும் விலகி அமைதியாக இருக்க வேண்டும்.", imagePath: 'assets/kids_3.2.png'),
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
