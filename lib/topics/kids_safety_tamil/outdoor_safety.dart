import 'package:e_she_book/tamil/kids_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OutdoorSafetyTamilPage extends StatefulWidget {
  @override
  _OutdoorSafetyTamilPageState createState() => _OutdoorSafetyTamilPageState();
}

class _OutdoorSafetyTamilPageState extends State<OutdoorSafetyTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "OutdoorSafetyTamil";

  final Map<int, String> correctAnswers = {
    1: "வயது பெரியவர்கள் அல்லது குழுவுடன் இருங்கள்.",
    2: "அறிமுகமற்றவர்களிடம் பேசவே கூடாது, பின்பற்றவே கூடாது.",
    3: "பிரகாசமான உடை அணிந்து, குறுக்கு பாதையை பயன்படுத்துங்கள்.",
    4: "பாதுகாப்பான மற்றும் தெரிந்த இடங்களில் மட்டும் விளையாடுங்கள்.",
    5: "வீட்டிலிருந்து வெளியே போகும் முன் பெரியவர்களுக்கு தெரிவிக்க வேண்டும்.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "வெளியில் செல்லும் போது குழந்தைகள் என்ன செய்ய வேண்டும்?",
      "options": [
        "வயது பெரியவர்கள் அல்லது குழுவுடன் இருங்கள்.",
        "தனியாக தெரியாத இடத்தில் நடக்க வேண்டும்.",
        "மறைந்திருந்து மகிழ்ச்சியாக விளையாட வேண்டும்.",
        "யாருடைய நாயாக இருந்தாலும் பின்பற்ற வேண்டும்."
      ]
    },
    {
      "question": "அறிமுகமற்றவர்கள் பற்றி விதி என்ன?",
      "options": [
        "அறிமுகமற்றவர்களிடம் பேசவே கூடாது, பின்பற்றவே கூடாது.",
        "அவர்களிடம் உணவு கேட்க வேண்டும்.",
        "அறிமுகமற்றவர்களிடம் பரிசுகளை ஏற்க வேண்டும்.",
        "அவர்களின் வாகனத்தில் செல்ல வேண்டும்."
      ]
    },
    {
      "question": "சாலையை பாதுகாப்பாக கடக்க எப்படி?",
      "options": [
        "பிரகாசமான உடை அணிந்து, குறுக்கு பாதையை பயன்படுத்துங்கள்.",
        "எங்காவது ஓடுங்கள்.",
        "செல்போனை பயன்படுத்தி நடக்குங்கள்.",
        "வாகன நெரிசலை கவனிக்கவேண்டாம்."
      ]
    },
    {
      "question": "எங்கு விளையாடுவது பாதுகாப்பானது?",
      "options": [
        "பாதுகாப்பான மற்றும் தெரிந்த இடங்களில் மட்டும் விளையாடுங்கள்.",
        "பெரிய சாலைகளில் விளையாடுங்கள்.",
        "மரபணு கட்டிடங்களின் அருகில்.",
        "இரவிலோ அல்லது வெறிச்சோடிய இடங்களில்."
      ]
    },
    {
      "question": "வீட்டிலிருந்து வெளியே செல்லும் முன் என்ன செய்ய வேண்டும்?",
      "options": [
        "வீட்டில் உள்ள பெரியவர்களுக்கு எங்கு செல்கிறீர்கள் என்பதை தெரிவிக்க வேண்டும்.",
        "அவசியமில்லாமல் வெளியே செல்லவும்.",
        "அது ஒரு சுரPRISE ஆக இருக்கட்டும்.",
        "பிறருடைய பையை எடுத்துச் செல்லவும்."
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
              title: Text("வெளிப்புற பாதுகாப்பு - வினா"),
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
                  Navigator.pushNamed(context, '/emergency_preparedness_ta');
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("வெளிப்புற பாதுகாப்பு"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🧍 குழந்தைகள் வெளியே செல்லும் போது?", "அறிமுகமான பெரியவரோடு அல்லது குழுவுடன் இருக்க வேண்டும்.", imagePath: 'assets/kids_4.0.png'),
                  _buildQuestionAnswer("🚫 அறிமுகமற்றவர்கள் எனில்?", "அவர்களிடம் பேசக்கூடாது, பரிசுகளையும் ஏற்கக்கூடாது."),
                  _buildQuestionAnswer("🚸 சாலை கடக்கும் போது?", "பிரகாசமான உடை அணிந்து, குறுக்கு பாதையைப் பயன்படுத்த வேண்டும்.", imagePath: 'assets/kids_4.1.png'),
                  _buildQuestionAnswer("🎯 எங்கு விளையாடுவது பாதுகாப்பானது?", "வழக்கமாக பயன்படும் மற்றும் பாதுகாப்பான இடங்களில் மட்டும்."),
                  _buildQuestionAnswer("📣 வெளியே செல்லும் முன்?", "எங்கு செல்கிறோம் என்பதை வீட்டிலுள்ள பெரியவர்களுக்கு தெரிவிக்க வேண்டும்.", imagePath: 'assets/kids_4.2.png'),
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
