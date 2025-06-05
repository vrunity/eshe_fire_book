import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeadProtectionPage extends StatefulWidget {
  @override
  _HeadProtectionPageState createState() => _HeadProtectionPageState();
}

class _HeadProtectionPageState extends State<HeadProtectionPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "HeadProtection";

  final Map<int, String> correctAnswers = {
    1: "தலைக்கு விழும் பொருட்கள் அல்லது மோதி ஏற்படும் காயங்களில் இருந்து பாதுகாப்பதற்காக",
    2: "கடினத் தொப்பிகள்",
    3: "உறைதல் மற்றும் ஊடுருவல் எதிர்ப்பு வழங்க",
    4: "அபாயம் உள்ள பகுதிகளில் எப்போதும் அணிய வேண்டும்",
    5: "பிளவுகள், குழிகள் அல்லது சேதங்களை சோதித்து, சேதமடைந்தால் மாற்றவும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "தலை பாதுகாப்பு ஏன் முக்கியம்?",
      "options": [
        "பிரமிப்பான தோற்றத்திற்கு",
        "தலைக்கு விழும் பொருட்கள் அல்லது மோதி ஏற்படும் காயங்களில் இருந்து பாதுகாப்பதற்காக",
        "தூசியிலிருந்து முடியை பாதுகாக்க",
        "தொப்பி அணிவதை தவிர்க்க"
      ]
    },
    {
      "question": "தலை பாதுகாப்பிற்கு பயன்படுத்தப்படும் உபகரணம் எது?",
      "options": [
        "கண்ணாடிகள்",
        "காது மடிப்பான்",
        "கடினத் தொப்பிகள்",
        "முகமூடி"
      ]
    },
    {
      "question": "கடினத் தொப்பியின் அமைப்பின் நோக்கம் என்ன?",
      "options": [
        "அழகாக தோன்ற",
        "கருவிகளை சேமிக்க",
        "உறைதல் மற்றும் ஊடுருவல் எதிர்ப்பு வழங்க",
        "அதை கனமாக்க"
      ]
    },
    {
      "question": "எப்போது கடினத் தொப்பிகள் அணிய வேண்டும்?",
      "options": [
        "ஆய்வின்போது மட்டும்",
        "மதிய உணவின் போது",
        "அபாயம் உள்ள பகுதிகளில் எப்போதும் அணிய வேண்டும்",
        "அலுவலக அறைகளில் மட்டும்"
      ]
    },
    {
      "question": "கடினத் தொப்பிகளை எப்படி பராமரிக்க வேண்டும்?",
      "options": [
        "அவற்றை அடிக்கடி வர்ணம் பூசுங்கள்",
        "பிளவுகள், குழிகள் அல்லது சேதங்களை சோதித்து, சேதமடைந்தால் மாற்றவும்",
        "அதை இருக்கையாக பயன்படுத்தவும்",
        "சூரியக்கதிரில் வைத்திருங்கள்"
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
    if (value) {
      _showQuizDialog();
    }
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
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("தலை பாதுகாப்பு வினாடி வினா"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"], style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[index],
                            onChanged: (String? value) {
                              setState(() {
                                userAnswers[index] = value!;
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
                        SnackBar(content: Text("தயவுசெய்து அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
                      );
                    } else {
                      Navigator.of(context).pop();
                      _evaluateQuiz();
                    }
                  },
                )
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
          content: Text("நீங்கள் ${quizQuestions.length} இலிருந்து $score மதிப்பெண் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/eye_protection_page');
                },
              ),
            TextButton(
              child: Text("மீண்டும் முயற்சி செய்யவும்"),
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

  Widget _buildQuestionAnswer(String question, String answer, {String? imagePath}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
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
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
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
          title: Text("தலை பாதுகாப்பு")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🪖 தலை பாதுகாப்பு முக்கியம் ஏன்?", "தலை காயங்கள் மிகவும் தீவிரமானவை மற்றும் விழும் பொருட்கள் அல்லது மோதி ஏற்படலாம்.", imagePath: 'assets/ppe_2.0.png'),
                  _buildQuestionAnswer("🪖 தலை பாதுகாப்பிற்கான பி.பி.இ உபகரணம் எது?", "கடினத் தொப்பிகள் அல்லது ஹெல்மெட்கள் தாக்கங்களிலிருந்து மற்றும் விழும் பொருட்களிலிருந்து பாதுகாக்கின்றன."),
                  _buildQuestionAnswer("🪖 தலை பாதுகாப்பை எப்படி பராமரிக்க வேண்டும்?", "பிளவுகள், குழிகள் அல்லது சேதங்களை அடிக்கடி பரிசோதிக்கவும். பெரும் தாக்கத்திற்குப் பிறகு தொப்பியை மாற்றவும்.", imagePath: 'assets/ppe_2.1.png'),
                  _buildQuestionAnswer("🪖 தலை பாதுகாப்பு எங்கு அவசியம்?", "கட்டிடம் கட்டும் இடங்கள், தொழிற்சாலைகள், களஞ்சியங்கள் மற்றும் மேலே அபாயம் உள்ள பகுதிகளில்."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினாடி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சி செய்யவும்"),
              )
          ],
        ),
      ),
    );
  }
}
