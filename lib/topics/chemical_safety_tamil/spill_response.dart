import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/chemical_safety_tamil.dart';

class SpillResponsePageTamil extends StatefulWidget {
  @override
  _SpillResponsePageTamilState createState() => _SpillResponsePageTamilState();
}

class _SpillResponsePageTamilState extends State<SpillResponsePageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "SpillResponse";

  final Map<int, String> correctAnswers = {
    1: "தகுந்த PPE பயன்படுத்தி பகுதியை தனிமைப்படுத்தவும்.",
    2: "சிவிழிவு பாதுகாப்பாக கட்டுப்படுத்த மற்றும் சுத்தம் செய்ய.",
    3: "உறிஞ்சும் பொருட்கள் மற்றும் நியூட்ரலைசர்கள்.",
    4: "ஆம், இது பரவல் மற்றும் ஆபத்துகளை குறைக்கிறது.",
    5: "அவசர தொடர்பு எண்கள் மற்றும் MSDS தகவல்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "ரசாயனச் சிந்தலில் முதலில் என்ன செய்கின்றீர்கள்?",
      "options": [
        "ஊடகங்களை அழைக்கவும்",
        "தகுந்த PPE பயன்படுத்தி பகுதியை தனிமைப்படுத்தவும்.",
        "உடனடியாக ஓடிவிடவும்",
        "அதை புறக்கணிக்கவும்"
      ]
    },
    {
      "question": "சிந்தல் பதிலளிப்பு நடைமுறையை ஏன் பின்பற்ற வேண்டும்?",
      "options": [
        "முகாமையாளர் மீது தாக்கம் செய்ய",
        "அறிக்கைகளைத் தவிர்க்க",
        "சிவிழிவு பாதுகாப்பாக கட்டுப்படுத்த மற்றும் சுத்தம் செய்ய.",
        "அலாரங்களை சோதிக்க"
      ]
    },
    {
      "question": "சிந்தலை சுத்தம் செய்ய எந்த கருவிகள் உதவும்?",
      "options": [
        "பேன்கள் மற்றும் காகிதங்கள்",
        "உறிஞ்சும் பொருட்கள் மற்றும் நியூட்ரலைசர்கள்.",
        "மேஜைகள் மற்றும் நாற்காலிகள்",
        "தீ அணைக்கும் குழாய்கள்"
      ]
    },
    {
      "question": "விரைவில் கட்டுப்படுத்துவது ஆபத்தை குறைக்கும்吗?",
      "options": [
        "ஆம், இது பரவல் மற்றும் ஆபத்துகளை குறைக்கிறது.",
        "இல்லை, இது மோசமாக்கும்",
        "மழைக்காலத்தில் மட்டும்",
        "அவ்வளவாக இல்லை"
      ]
    },
    {
      "question": "ஒரு சிந்தல் கிட் எதில் இருக்க வேண்டும்?",
      "options": [
        "தண்ணீர் மற்றும் ஸ்னாக்ஸ்",
        "அவசர தொடர்பு எண்கள் மற்றும் MSDS தகவல்.",
        "புத்தகங்கள் மற்றும் பேன்கள்",
        "நாற்காலிகள் மற்றும் கை கையுறை மட்டும்"
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
              title: Text("வினா: சிந்தல் பதிலளிப்பு மற்றும் அவசர நடவடிக்கைகள்"),
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
          title: Text("வினா முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("முடிக்க"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ChemicalSafetyTamil()),
                );
              },
            ),
            TextButton(
              child: Text("மீளத்தேர்வு"),
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
        title: Text("சிந்தல் பதிலளிப்பு மற்றும் அவசர நடவடிக்கைகள்"),
        backgroundColor: Colors.blue[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ChemicalSafetyTamil()),
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
                  _buildQA("🧯 முதற்கட்ட நடவடிக்கை", "PPE அணிந்து, பிறரை எச்சரித்து, பகுதியை தனிமைப்படுத்தவும்.", imagePath: 'assets/chemical_5.0.png'),
                  _buildQA("🛠️ கட்டுப்பாட்டு முறைகள்", "உறிஞ்சும் பொருட்கள், மேட்கள் அல்லது நியூட்ரலைசர்கள் பயன்படுத்தவும்."),
                  _buildQA("📄 அவசர தகவல்", "MSDS, அவசர எண்கள் மற்றும் தள வரைபடங்களை அருகில் வைக்கவும்.", imagePath: 'assets/chemical_5.1.png'),
                  _buildQA("🚨 அறிக்கை நடைமுறை", "மேலாளருக்கும் அவசர குழுவிற்கும் உடனடியாக தகவல் அளிக்கவும்."),
                  _buildQA("👥 குழுவின் பங்கு", "எல்லா ஊழியர்களும் சிந்தலின் போது என்ன செய்ய வேண்டும் என்பதை அறிந்திருக்க வேண்டும்.", imagePath: 'assets/chemical_5.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்க"),
              value: isCompleted,
              onChanged: (value) {
                _saveCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீளத் தேர்வு")),
          ],
        ),
      ),
    );
  }
}
