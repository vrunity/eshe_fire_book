// center_of_gravity_ta.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/forklift_safety_tamil.dart';

class CenterOfGravityTamilPage extends StatefulWidget {
  @override
  _CenterOfGravityTamilPageState createState() => _CenterOfGravityTamilPageState();
}

class _CenterOfGravityTamilPageState extends State<CenterOfGravityTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "CenterOfGravityTamil";

  final Map<int, String> correctAnswers = {
    1: "பொருளின் எடை சமநிலையிலிருக்கும் இடம்.",
    2: "பொருள் கவிழாமல் பாதுகாப்பாக இயக்கப்படுவதற்காக.",
    3: "முன்பக்க சக்கரங்கள் மற்றும் பின்சக்கர மையம் மூலம் உருவாகும் முக்கோணம்.",
    4: "முன் காணப்படும் பல்லங்கள் முதல் பொருளின் சமநிலை வரை உள்ள தொலைவு.",
    5: "இது மீறப்பட்டால், பாதுகாப்பு பாதிக்கப்படும்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Forklift-இல் 'மைய செங்குத்துத்தொகை' என்றால் என்ன?",
      "options": [
        "பொருளின் மேல் பகுதி",
        "ஓட்டுனர் உட்காரும் இடம்",
        "பொருளின் எடை சமநிலையிலிருக்கும் இடம்.",
        "சக்கரங்கள் இடமாற்றம்"
      ]
    },
    {
      "question": "மைய செங்குத்துத்தொகையை புரிந்து கொள்வது ஏன் முக்கியம்?",
      "options": [
        "அலங்கரிக்க",
        "வேகமாக தூக்க",
        "பொருள் கவிழாமல் பாதுகாப்பாக இயக்கப்படுவதற்காக.",
        "எரிபொருள் சேமிக்க"
      ]
    },
    {
      "question": "முக்கிய நிலைத்தன்மை முக்கோணம் என்றால் என்ன?",
      "options": [
        "பல்லங்கள் மற்றும் தூண்",
        "ஓட்டுனர் அறை",
        "முன்பக்க சக்கரங்கள் மற்றும் பின்சக்கர மையம் மூலம் உருவாகும் முக்கோணம்.",
        "பேட்டரி மற்றும் இயந்திரம்"
      ]
    },
    {
      "question": "Forklift-இல் Load center என்றால் என்ன?",
      "options": [
        "பொருளின் எடை",
        "பல்லத்தின் நீளம்",
        "உயரத்தின் அளவு",
        "முன் காணப்படும் பல்லங்கள் முதல் பொருளின் சமநிலை வரை உள்ள தொலைவு."
      ]
    },
    {
      "question": "Load center மீறினால் என்ன ஆகும்?",
      "options": [
        "வேகமாக ஓடலாம்",
        "அதிக எடை தூக்கலாம்",
        "இது மீறப்பட்டால், பாதுகாப்பு பாதிக்கப்படும்.",
        "மிருதுவான ஓட்டம்"
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
    await prefs.setBool('Completed_$topicName', true);
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
      isCompleted = true;
    });
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

  void _showQuizDialog() {
    userAnswers.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("வினாடி வினா: மையச் செங்குத்துத்தொகை & நிலைத்தன்மை"),
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
                        SnackBar(content: Text("தயவு செய்து அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
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

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("மதிப்பீடு முடிவுகள்"),
          content: Text("நீங்கள் ${quizQuestions.length}ல் $score மதிப்பெண் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/common_accidents_ta');
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
        title: Text("மைய செங்குத்துத்தொகை & நிலைத்தன்மை"),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ForkliftSafetyTamil()),
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
                  _buildQA("⚖️ மைய செங்குத்துத்தொகை என்றால் என்ன?", "பொருளின் எடை சமமாக இருக்கும் புள்ளி.", imagePath: 'assets/forklift_2.0.png'),
                  _buildQA("🔺 நிலைத்தன்மை முக்கோணம் என்றால்?", "முன்புற சக்கரங்கள் மற்றும் பின்சக்கர மையம் மூலமாக உருவாகும் முக்கோணம்."),
                  _buildQA("📏 Load center என்றால்?", "பல்லத்தின் முன்பகுதியிலிருந்து பொருளின் செங்குத்துத்தொகை வரை உள்ள தொலைவு.", imagePath: 'assets/forklift_2.1.png'),
                  _buildQA("🚫 Load center-ஐ மீறினால்?", "Forklift நிலைத்தன்மையிழக்க மற்றும் கவிழ வாய்ப்பு அதிகரிக்கும்."),
                  _buildQA("📦 ஏன் நிலைத்தன்மை முக்கியம்?", "பாதுகாப்பான செயல்பாட்டை உறுதி செய்யும்.", imagePath: 'assets/forklift_2.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("நிறைவு என குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) {
                _saveCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சிக்கவும்")),
          ],
        ),
      ),
    );
  }
}
