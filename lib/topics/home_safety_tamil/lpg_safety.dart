import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/home_safety_tamil.dart';

class LPGSafetyTamilPage extends StatefulWidget {
  @override
  _LPGSafetyTamilPageState createState() => _LPGSafetyTamilPageState();
}

class _LPGSafetyTamilPageState extends State<LPGSafetyTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "LPGSafety";

  final Map<int, String> correctAnswers = {
    1: "LPG பயன்படுத்தும்போது போதுமான காற்றோட்டம் இருக்க வேண்டும்.",
    2: "வாடகையை அணைத்து, ஜன்னல்கள் திறக்கவும்.",
    3: "வாயுக்களி கண்டறியும் கருவிகள் பொருத்தவும் மற்றும் உற்பத்தியாளர் வழிகாட்டுதல்களை பின்பற்றவும்.",
    4: "வாசனை இருந்தால் மெழுகுவர்த்தி மற்றும் பூப்பொருள்கள் பயன்படுத்தக்கூடாது.",
    5: "ஆம், இது தீவிபத்து, வெடிப்பு மற்றும் விஷப்புகை ஆகியவற்றைத் தடுக்கும்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "LPG பயன்படுத்தும் போது என்ன கவனிக்க வேண்டும்?",
      "options": [
        "அனைத்து கதவுகளையும் பூட்டவும்",
        "LPG பயன்படுத்தும்போது போதுமான காற்றோட்டம் இருக்க வேண்டும்.",
        "மெழுகுவர்த்தி பயன்படுத்தவும்",
        "இரவில் எப்போதும் வாயுக்களை ஓட விட்டுவைக்கவும்"
      ]
    },
    {
      "question": "வாசனை இருந்தால் என்ன செய்ய வேண்டும்?",
      "options": [
        "பங்குகளை இயக்கவும்",
        "வாடகையை அணைத்து, ஜன்னல்கள் திறக்கவும்.",
        "கத்தி கொண்டு கத்தவும்",
        "பூப்பொருள் ஏற்றவும்"
      ]
    },
    {
      "question": "LPG பாதுகாப்பை எவ்வாறு மேம்படுத்தலாம்?",
      "options": [
        "வாசனைகளை புறக்கணிக்கவும்",
        "வாயுக்களி கண்டறியும் கருவிகள் பொருத்தவும் மற்றும் உற்பத்தியாளர் வழிகாட்டுதல்களை பின்பற்றவும்.",
        "பிளாஸ்டிக் குழாய்களை பயன்படுத்தவும்",
        "சிலிண்டர்களை தலைகீழாக வைத்திருப்பது"
      ]
    },
    {
      "question": "வாயுக்களி போது என்ன தவிர்க்க வேண்டும்?",
      "options": [
        "மின் வசதிகளை அணைக்கவும்",
        "ஜன்னல்கள் திறக்கவும்",
        "வெளியில் இருந்து போனில் பேசவும்",
        "வாசனை இருந்தால் மெழுகுவர்த்தி மற்றும் பூப்பொருள்கள் பயன்படுத்தக்கூடாது."
      ]
    },
    {
      "question": "LPG பாதுகாப்பு விழிப்புணர்வு முக்கியமா?",
      "options": [
        "இல்லை, இது அதிகமாக பேசப்படுகிறது",
        "ஆம், இது தீவிபத்து, வெடிப்பு மற்றும் விஷப்புகை ஆகியவற்றைத் தடுக்கும்.",
        "கேஸ் நிறுவனங்களுக்கு மட்டும்",
        "முக்கியமில்லை"
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
              title: Text("வினா: எல்.பி.ஜி. பாதுகாப்பு"),
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
                  child: Text("சமர்ப்பிக்க"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("தயவுசெய்து அனைத்து வினாக்களுக்கும் பதிலளிக்கவும்")),
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
      if (correctAnswers[key] == value) score++;
    });
    _saveQuizScore(score);
    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("வினா முடிவு"),
          content: Text("நீங்கள் ${quizQuestions.length} வினாக்களில் $score மதிப்பெண் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/home_electrical_safety_ta');
                },
              ),
            TextButton(
              child: Text("மீண்டும் முயற்சி"),
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
        title: Text("எல்.பி.ஜி. பாதுகாப்பு"),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQA("🪠 ஏன் LPG பாதுகாப்பு?", "வாசனை, தீவிபத்து, வெடிப்பு மற்றும் விஷப்புகைகளைத் தடுக்க."),
                  _buildQA("💨 காற்றோட்டம் முக்கியம்", "எப்போதும் நல்ல காற்றோட்டம் உள்ள இடத்தில் பயன்படுத்தவும்.", imagePath: "assets/home_3.0.png"),
                  _buildQA("🚫 வாயுக்களி போது தீயாது", "வாசனை இருந்தால் மெழுகுவர்த்தி அல்லது பூப்பொருள் பயன்படுத்தாதீர்கள்."),
                  _buildQA("🧯 கண்டறியும் கருவிகள்", "வாயுக்களை முன்கூட்டியே கண்டறிய உதவுகிறது.", imagePath: "assets/home_3.1.png"),
                  _buildQA("📞 அவசர நடவடிக்கைகள்", "வாடகையை அணைத்து, ஜன்னல்கள் திறக்கவும் மற்றும் அவசர சேவைகளை அழைக்கவும்."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி")),
          ],
        ),
      ),
    );
  }
}
