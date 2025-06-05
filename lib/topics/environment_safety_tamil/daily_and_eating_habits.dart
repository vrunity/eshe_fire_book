import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/environment_safety_tamil.dart';

class DailyAndEatingHabitsTamilPage extends StatefulWidget {
  @override
  _DailyAndEatingHabitsTamilPageState createState() => _DailyAndEatingHabitsTamilPageState();
}

class _DailyAndEatingHabitsTamilPageState extends State<DailyAndEatingHabitsTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EnvTopic4";

  final Map<int, String> correctAnswers = {
    1: "பயன்பாட்டில் இல்லாத போது மின்சாதனங்களை அணைக்கவும்.",
    2: "மீள்சுழற்சி செய்யக்கூடியவற்றை அதிகமாக மீள்சுழற்சி செய்யவும்.",
    3: "மீள்பயன்படுத்தக்கூடிய குடிநீர் பாட்டில்களை பயன்படுத்தவும்.",
    4: "பிளாஸ்டிக் மற்றும் ஒரேமுறை பயன்பாட்டு பொருட்களை தவிர்க்கவும்.",
    5: "உள்ளூர் மற்றும் உயிரணுக்கேற்ற உணவுகளை வாங்கவும்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "ஆற்றலை சேமிக்க என்ன ஒரு நல்ல தினசரி பழக்கம்?",
      "options": [
        "முழுநாளும் விளக்குகளை விடவும்",
        "பயன்பாட்டில் இல்லாத போது மின்சாதனங்களை அணைக்கவும்.",
        "எப்போதும் முழு சக்தியுடன் ஏசி பயன்படுத்தவும்",
        "தூங்கும்போது டிவி ஓட விடவும்"
      ]
    },
    {
      "question": "வீட்டில் குப்பையை எவ்வாறு குறைக்கலாம்?",
      "options": [
        "எல்லாவற்றையும் ஒரே தொட்டியில் போடவும்",
        "பிளாஸ்டிக் எரிக்கவும்",
        "மீள்சுழற்சி செய்யக்கூடியவற்றை அதிகமாக மீள்சுழற்சி செய்யவும்.",
        "தொட்டிகளை தவிர்க்கவும்"
      ]
    },
    {
      "question": "தாராளமாக குடிநீர் குடிக்க என்ன ஒரு புத்திசாலி வழி?",
      "options": [
        "ஒரேமுறை பயன்படும் பிளாஸ்டிக் பாட்டில்கள்",
        "மட்டும் பாட்டிலில் நீர்",
        "மீள்பயன்படுத்தக்கூடிய குடிநீர் பாட்டில்களை பயன்படுத்தவும்.",
        "ஒவ்வொரு முறையும் புதிய பாட்டில் வாங்கவும்"
      ]
    },
    {
      "question": "உணவு பழக்க வழக்கங்களால் சூழலுக்கு எவ்வாறு உதவலாம்?",
      "options": [
        "மிகவும் மாமிசம் சாப்பிடவும்",
        "பிளாஸ்டிக் பொருட்கள் பயன்படுத்தவும்",
        "பிளாஸ்டிக் மற்றும் ஒரேமுறை பயன்பாட்டு பொருட்களை தவிர்க்கவும்.",
        "தொலைவிலிருந்து உணவு ஆர்டர் செய்யவும்"
      ]
    },
    {
      "question": "திடமான உணவுத்தேர்வு எது?",
      "options": [
        "இறக்குமதி செய்யப்பட்ட உணவு",
        "உள்ளூர் மற்றும் உயிரணுக்கேற்ற உணவுகளை வாங்கவும்.",
        "மட்டும் உறைய வைத்த உணவுகள்",
        "தினமும் ஃபாஸ்ட் ஃபுட் உணவகங்களில் உணவு"
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
              title: Text("தினசரி & உணவு பழக்கங்கள் - வினாடி வினா"),
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
          title: Text("வினா விளைவு"),
          content: Text("நீங்கள் ${quizQuestions.length} இலிருந்து $score மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/home_and_yard_practices_ta');
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
        title: Text("தினசரி & உணவு பழக்கங்கள்"),
        backgroundColor: Colors.green[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => EnvironmentalSafetyTamil()),
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
                  _buildQuestionAnswer("🔌 தேவையில்லை என்றால் அணைக்கவும்", "மின்சாதனங்களை தேவையில்லாமல் பயன்படுத்தும் போது அணைக்கவும்.", imagePath: 'assets/env_4.0.png'),
                  _buildQuestionAnswer("♻ புத்திசாலித்தனமாக மீள்சுழற்சி செய்", "பிளாஸ்டிக், கண்ணாடி, காகிதம் போன்றவற்றை மீள்சுழற்சி செய்யவும்."),
                  _buildQuestionAnswer("🚰 நீர் குடிக்கும் சிறந்த வழி", "மீள்பயன்படுத்தக்கூடிய பாட்டில்கள் பயன்படுத்தவும்.", imagePath: 'assets/env_4.1.png'),
                  _buildQuestionAnswer("🥗 பொறுப்புடன் உணவுகள்", "உணவுகளை வீணாக்காமல், உள்ளூரில் தயாரித்தவற்றை வாங்கவும்."),
                  _buildQuestionAnswer("🛍 சிறந்த பொருட்கள் வாங்கவும்", "சூழலுக்கு ஏற்ற பாறைகள் கொண்ட பொருட்களை வாங்கவும்.", imagePath: 'assets/env_4.2.png'),
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
              Text("கடைசி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மறுபரிசோதனை")),
          ],
        ),
      ),
    );
  }
}
