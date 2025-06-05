import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/construction_safety_tamil.dart';

class PersonalProtectiveTamilPage extends StatefulWidget {
  @override
  _PersonalProtectiveTamilPageState createState() => _PersonalProtectiveTamilPageState();
}

class _PersonalProtectiveTamilPageState extends State<PersonalProtectiveTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "PPEUsageTa";

  final Map<int, String> correctAnswers = {
    1: "PPE என்பது தனிப்பட்ட பாதுகாப்பு உபகரணங்கள் ஆகும்.",
    2: "தலையணை, கையுறை, பாதுகாப்பு காலணிகள், கண்ணாடி, முகமூடி.",
    3: "ஆபத்துகளில் இருந்து காயங்களை குறைக்க.",
    4: "ஆம், இது தொழிலாளர்களை பாதுகாக்கிறது.",
    5: "வேலை இடத்திற்கு செல்லும் முன்பும் வேலை செய்யும் போதும்.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "PPE என்றால் என்ன?",
      "options": [
        "PPE என்பது தனிப்பட்ட பாதுகாப்பு உபகரணங்கள் ஆகும்.",
        "பவர் பிளான்ட் எக்யூப்மெண்ட்.",
        "முக்கிய திட்டம் தேவைகள்.",
        "மேலே எந்த ஒன்றும் அல்ல."
      ]
    },
    {
      "question": "PPE உட்பட்ட பொருட்கள் எவை?",
      "options": [
        "தலையணை, கையுறை, பாதுகாப்பு காலணிகள், கண்ணாடி, முகமூடி.",
        "கண்ணாடி மற்றும் தலைக்கவசம்.",
        "பெல்ட் மற்றும் டை.",
        "பேக் மற்றும் உணவு பெட்டி."
      ]
    },
    {
      "question": "PPE ஏன் அணிய வேண்டும்?",
      "options": [
        "ஆபத்துகளில் இருந்து காயங்களை குறைக்க.",
        "புதிதாகச் சிக்காக இருக்க.",
        "ஃபேஷனுக்கு.",
        "விருப்பமானது மட்டுமே."
      ]
    },
    {
      "question": "PPE கட்டுமானத்தில் தேவையா?",
      "options": [
        "ஆம், இது தொழிலாளர்களை பாதுகாக்கிறது.",
        "மழைக்காலங்களில் மட்டும்.",
        "இரவு வேலைக்கு மட்டும்.",
        "வேண்டாம், விருப்பம்தான்."
      ]
    },
    {
      "question": "PPE எப்போது அணிய வேண்டும்?",
      "options": [
        "வேலை இடத்திற்கு செல்லும் முன்பும் வேலை செய்யும் போதும்.",
        "உணவு இடைவேளையில் மட்டும்.",
        "மேலாளர் இருப்பின்போதுதான்.",
        "பதிவுசெய்த பிறகு மட்டும்."
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
              title: Text("PPE பாதுகாப்பு வினா-விலைகள்"),
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
                        SnackBar(content: Text("அனைத்து வினாக்களுக்கும் பதிலளிக்கவும்.")),
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
          title: Text("மதிப்பெண் முடிவு"),
          content: Text("நீங்கள் பெற்ற மதிப்பெண்: $score / ${quizQuestions.length}."),
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
                  Navigator.pushNamed(context, '/tools_handling_ta');
                },
              ),
            TextButton(
              child: Text("மீளமுயற்சி"),
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
              MaterialPageRoute(builder: (_) => ConstructionSafetyTamil()),
            );
          },
        ),
        title: Text("PPE - பாதுகாப்பு சாதனங்கள்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🧤 PPE என்றால் என்ன?", "தொழிலாளர்களை பாதுகாக்கும் தனிப்பட்ட பாதுகாப்பு சாதனங்கள்.", imagePath: 'assets/construction_2.0.png'),
                  _buildQuestionAnswer("🦺 உதாரணங்கள் என்ன?", "ஹெல்மெட், கையுறை, பூட்ஸ், கண்ணாடி, ஹார்னஸ்."),
                  _buildQuestionAnswer("⚠️ ஏன் அணிய வேண்டும்?", "காயங்களை தவிர்க்கவும் ஆபத்தை குறைக்கவும்.", imagePath: 'assets/construction_2.1.png'),
                  _buildQuestionAnswer("📌 இது கட்டாயமா?", "ஆம், சட்டத்தால் கட்டாயம் மற்றும் பாதுகாப்புக்கு அவசியம்."),
                  _buildQuestionAnswer("🕒 எப்போது அணிய வேண்டும்?", "வேலைக்கு முன்பும் நடக்கும் போதும்.", imagePath: 'assets/construction_2.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்துவிட்டேன் என குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) {
                _saveTopicCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீளமுயற்சி")),
          ],
        ),
      ),
    );
  }
}
