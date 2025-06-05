// forklift_intro_ta.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/forklift_safety_tamil.dart';

class ForkliftIntroTamilPage extends StatefulWidget {
  @override
  _ForkliftIntroTamilPageState createState() => _ForkliftIntroTamilPageState();
}

class _ForkliftIntroTamilPageState extends State<ForkliftIntroTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ForkliftIntroTamil";

  final Map<int, String> correctAnswers = {
    1: "பொருட்களை பாதுகாப்பாக தூக்கி நகர்த்த பயன்படுத்தப்படுகிறது.",
    2: "ஏனெனில் இது ஒரு கனமான மற்றும் சக்திவாய்ந்த உபகரணமாகும்.",
    3: "மிகவும் தீவிரமான காயம் அல்லது சேதம் ஏற்படலாம்.",
    4: "கையேடுகளை படிக்கவும், பயிற்சி எடுக்கவும், விதிகளை பின்பற்றவும்.",
    5: "ஆமாம், குறிப்பாக கூட்டம் அதிகமான இடங்களில்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "பொருளின் முக்கிய நோக்கம் என்ன?",
      "options": [
        "விளையாட்டு", "சமைத்தல்", "பொருட்களை பாதுகாப்பாக தூக்கி நகர்த்த பயன்படுத்தப்படுகிறது.", "மக்களை நகர்த்த" ]
    },
    {
      "question": "ஏன் பாதுகாப்பு முக்கியம்?",
      "options": [
        "இது எளிதானது", "வெறும் வேடிக்கை", "ஏனெனில் இது ஒரு கனமான மற்றும் சக்திவாய்ந்த உபகரணமாகும்.", "சத்தம் அதிகம்"]
    },
    {
      "question": "தவறாக பயன்படுத்தினால் என்ன நடக்கும்?",
      "options": [
        "பறக்கும்", "மிகவும் தீவிரமான காயம் அல்லது சேதம் ஏற்படலாம்.", "வேகமாக இயக்கலாம்", "நிறுத்திவிடும்"]
    },
    {
      "question": "பாதுகாப்பாக இயக்க எப்படிச் செய்க?",
      "options": [
        "வேகமாக ஓட்டு", "பயிற்சியை தவிர்த்து", "கையேடுகளை படிக்கவும், பயிற்சி எடுக்கவும், விதிகளை பின்பற்றவும்.", "எல்லா பொத்தான்களையும் அழுத்தவும்"]
    },
    {
      "question": "பணியிடத்தில் இது முக்கியமா?",
      "options": [
        "இல்லை", "ஆமாம், குறிப்பாக கூட்டம் அதிகமான இடங்களில்.", "வீட்டில் மட்டும்", "அவசியமில்லை"]
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
      isCompleted = prefs.getBool('Completed_\$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_\$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_\$topicName') ?? false;
    });
  }

  Future<void> _saveCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_\$topicName', value);
    setState(() {
      isCompleted = value;
    });
    if (value) _showQuizDialog();
  }

  Future<void> _saveQuizScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('QuizScore_\$topicName', score);
    await prefs.setBool('QuizTaken_\$topicName', true);
    await prefs.setBool('Completed_\$topicName', true);
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
      isCompleted = true;
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
              title: Text("வினாடி வினா: Forklift அறிமுகம்"),
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
          title: Text("முடிவுகள்"),
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
                  Navigator.pushNamed(context, '/center_of_gravity_ta');
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
        title: Text("Forklift Safety அறிமுகம்"),
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
                  _buildQA("🚜 Forklift என்றால் என்ன?", "முன்புறத்தில் கூர்மையான பகுதியுடன் பொருட்களை தூக்கி நகர்த்தும் வாகனம்.", imagePath: 'assets/forklift_1.0.png'),
                  _buildQA("⚠ ஏன் பாதுகாப்பு முக்கியம்?", "தவறான பயன்பாடு பல்வேறு இடர்பாடுகளை ஏற்படுத்தலாம்."),
                  _buildQA("❌ தவறாக பயன்படுத்தினால்?", "தூக்கம், நொறுக்கல் அல்லது விபத்துக்குள்ளாகலாம்.", imagePath: 'assets/forklift_1.1.png'),
                  _buildQA("📘 பாதுகாப்பாக செயல்பட?", "பயிற்சி எடுத்து, விதிகளை பின்பற்றி மற்றும் சரியான கட்டுப்பாடுகளை அறிந்து செயல்பட வேண்டும்."),
                  _buildQA("🏭 இது எல்லா இடங்களிலும் தேவையா?", "ஆமாம், குறிப்பாக தொழிற்சாலைகள், கட்டுமான இடங்கள் போன்ற இடங்களில்.", imagePath: 'assets/forklift_1.2.png'),
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
