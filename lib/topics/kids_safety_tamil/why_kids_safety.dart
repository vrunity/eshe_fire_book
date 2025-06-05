import 'package:e_she_book/tamil/kids_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhyKidsSafetyTamilPage extends StatefulWidget {
  @override
  _WhyKidsSafetyTamilPageState createState() => _WhyKidsSafetyTamilPageState();
}

class _WhyKidsSafetyTamilPageState extends State<WhyKidsSafetyTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "KidsIntroTamil";

  final Map<int, String> correctAnswers = {
    1: "பத்திரமற்ற சூழ்நிலையில் குழந்தைகள் எப்படிப் பழகுவது என்று தெரியாமல் இருக்கலாம்.",
    2: "பாதுகாப்பு கல்வி குழந்தைகளை பாதுகாக்கும் அறிவையும் திறமையும் வழங்கும்.",
    3: "சேதங்களைத் தவிர்க்கவும், குழந்தைகளை பாதுகாப்பாக வைத்திருக்கவும்.",
    4: "ஆம், இது விபத்துகளைத் தவிர்க்க உதவுகிறது மற்றும் பாதுகாப்பான பதில்கள் தரும்.",
    5: "அவை விழிப்புணர்வையும், தன்னம்பிக்கையையும் உருவாக்குகிறது.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "ஏன் குழந்தைகள் ஆபத்துகளுக்கு மோசமாக பாதிக்கப்படுவார்கள்?",
      "options": [
        "பத்திரமற்ற சூழ்நிலையில் குழந்தைகள் எப்படிப் பழகுவது என்று தெரியாமல் இருக்கலாம்.",
        "அவர்கள் எப்போதும் சரியான முடிவுகளை எடுப்பார்கள்.",
        "அவர்கள் பாதுகாப்பு விதிகளை பின்பற்றுவார்கள்.",
        "மேலதிக உதவி தேவை இல்லை."
      ]
    },
    {
      "question": "பாதுகாப்பு கல்வியின் நோக்கம் என்ன?",
      "options": [
        "பாதுகாப்பு கல்வி குழந்தைகளை பாதுகாக்கும் அறிவையும் திறமையும் வழங்கும்.",
        "இது தேவையற்ற பாடமாகும்.",
        "இது பயமுறுத்தும்.",
        "இது பெரியவர்களுக்கே மட்டுமே."
      ]
    },
    {
      "question": "பாதுகாப்பு கல்வியை ஏன் முக்கியமாக கற்றுக்கொடுக்க வேண்டும்?",
      "options": [
        "சேதங்களைத் தவிர்க்கவும், குழந்தைகளை பாதுகாப்பாக வைத்திருக்கவும்.",
        "அவர்கள் தனியாக வீட்டில் இருக்க முடிய வேண்டும்.",
        "பள்ளி கட்டாயப்படுத்துகிறது.",
        "முக்கியமில்லை."
      ]
    },
    {
      "question": "பாதுகாப்பு கல்வி விபத்துகளைத் தவிர்க்க உதவுமா?",
      "options": [
        "ஆம், இது விபத்துகளைத் தவிர்க்க உதவுகிறது மற்றும் பாதுகாப்பான பதில்கள் தரும்.",
        "இல்லை, விபத்துகள் தவிர்க்க முடியாது.",
        "அது விதியால் நடக்கும்.",
        "மருத்துவர்கள் மட்டுமே உதவ முடியும்."
      ]
    },
    {
      "question": "பாதுகாப்பு கல்வி எப்படி உதவுகிறது?",
      "options": [
        "அவை விழிப்புணர்வையும், தன்னம்பிக்கையையும் உருவாக்குகிறது.",
        "அவை பெருமைபடுவதற்கான காரணமாகும்.",
        "அவை பெற்றோர்களை மாற்றும்.",
        "அவை வாகன ஓட்டம் கற்பிக்கும்."
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
              title: Text("குழந்தை பாதுகாப்பு வினா"),
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
                        SnackBar(content: Text("தயவுசெய்து அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
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
          title: Text("வினாத்தாள் முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3)
              TextButton(
                child: Text("அடுத்தது"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/stranger_danger_ta');
                },
              ),
            TextButton(
              child: Text("மறுபரிசோதனை"),
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
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 6),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => KidsSafetyTamil()),
            );
          },
        ),
        title: Text("ஏன் குழந்தை பாதுகாப்பு?"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🧒 குழந்தைகளுக்கு பாதுகாப்பு கல்வி ஏன் தேவை?",
                      "அவர்கள் தீவிரமான சூழ்நிலைகளில் எப்படி பதிலளிக்க வேண்டும் என்று தெரியாது.",
                      imagePath: 'assets/kids_1.0.png'),
                  _buildQuestionAnswer("🧒 பாதுகாப்பு கல்வி என்றால் என்ன?",
                      "இது குழந்தைகளை ஆபத்தான சூழ்நிலைகளிலிருந்து பாதுகாப்பதற்கான அறிவையும் திறமையும் தரும்."),
                  _buildQuestionAnswer("🧒 இது ஏன் அவசியம்?", "இது குழந்தைகளை வெளியில் மற்றும் வீட்டில் பாதுகாக்க உதவுகிறது.",
                      imagePath: 'assets/kids_1.1.png'),
                  _buildQuestionAnswer("🧒 இது விபத்துகளைத் தடுக்கும்?", "ஆம், இது விழிப்புணர்வை மேம்படுத்துகிறது."),
                  _buildQuestionAnswer("🧒 இதன் குறிக்கோள் என்ன?", "தன்னம்பிக்கை மற்றும் விழிப்புணர்வை வளர்த்தல்.",
                      imagePath: 'assets/kids_1.2.png'),
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
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மறுபரிசோதனை")),
          ],
        ),
      ),
    );
  }
}
