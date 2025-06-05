import 'package:e_she_book/tamil/construction_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToolsHandlingTamilPage extends StatefulWidget {
  @override
  _ToolsHandlingTamilPageState createState() => _ToolsHandlingTamilPageState();
}

class _ToolsHandlingTamilPageState extends State<ToolsHandlingTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ToolsHandlingTamil";

  final Map<int, String> correctAnswers = {
    1: "கைப்படிச் செயல்கள் என்பது கை மூலம் பொருட்களை தூக்குதல், நகர்த்துதல்.",
    2: "முழங்கால் மடித்து, முதுகு நேராக வைத்து, இரண்டு கைகளால் தூக்க வேண்டும்.",
    3: "வலி, சுளுக்கு மற்றும் முதுகு காயங்கள்.",
    4: "கருவிகளை பரிசோதித்து, பராமரித்து, சரியான முறையில் பயன்படுத்த வேண்டும்.",
    5: "தளர்ந்த உடைகள், ஈரமான கைகள் மற்றும் கவனக்குறைவு.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "கைப்படிச் செயல்கள் என்றால் என்ன?",
      "options": [
        "கை மூலம் பொருட்களை தூக்குதல், நகர்த்துதல்.",
        "கணினியில் தட்டச்சு செய்தல்.",
        "சிமெண்டுடன் வேலை செய்தல்.",
        "சுவர்கள் ஓவியம் வரைதல்."
      ]
    },
    {
      "question": "எப்படி பாதுகாப்பாக தூக்க வேண்டும்?",
      "options": [
        "முழங்கால் மடித்து, முதுகு நேராக வைத்து, இரண்டு கைகளால் தூக்க வேண்டும்.",
        "முழுக்க முதுகை வளைத்து தூக்க வேண்டும்.",
        "ஒரே கையால் விரைவில் தூக்க வேண்டும்.",
        "எப்போதும் மற்றவரிடம் தூக்க சொல்ல வேண்டும்."
      ]
    },
    {
      "question": "தவறான தூக்கத்தால் என்ன காயங்கள் ஏற்படும்?",
      "options": [
        "வலி, சுளுக்கு மற்றும் முதுகு காயங்கள்.",
        "தலைவலி.",
        "பல்லுவலி.",
        "செவிவலி."
      ]
    },
    {
      "question": "கருவிகளை எப்படிச் சமாளிக்க வேண்டும்?",
      "options": [
        "கருவிகளை பரிசோதித்து, பராமரித்து, சரியான முறையில் பயன்படுத்த வேண்டும்.",
        "பிளாஸ்டிக் பொம்மையாக பயன்படுத்த வேண்டும்.",
        "மற்றவர்களுக்கு கொடுத்து விட வேண்டும்.",
        "பயன்பாட்டுக்குப் பிறகு எறிய வேண்டும்."
      ]
    },
    {
      "question": "கருவிகள் பயன்படுத்தும்போது எதை தவிர்க்க வேண்டும்?",
      "options": [
        "தளர்ந்த உடைகள், ஈரமான கைகள் மற்றும் கவனக்குறைவு.",
        "கையுறை அணிதல்.",
        "பாதுகாப்பு கண்ணாடி.",
        "கவனம் மற்றும் பொறுப்பு."
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
              title: Text("கருவிகள் கையாளல் வினா"),
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
          title: Text("மதிப்பீட்டு முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
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
        title: Text("கருவிகள் மற்றும் தூக்குதல்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("📦 கைப்பிடி செயல்கள் என்றால் என்ன?",
                      "கை கொண்டு பொருட்களை தூக்குதல், நகர்த்துதல்.", imagePath: 'assets/construction_3.0.png'),
                  _buildQuestionAnswer("🧍 எப்படிச் சரியாக தூக்க வேண்டும்?", "முழங்கால் மடித்து, முதுகு நேராக வைத்து தூக்க வேண்டும்."),
                  _buildQuestionAnswer("💢 என்ன காயங்கள் ஏற்படலாம்?", "முதுகு வலி, சுளுக்கு, களைப்பு.", imagePath: 'assets/construction_3.1.png'),
                  _buildQuestionAnswer("🔧 கருவிகளை எப்படிச் சமாளிக்க வேண்டும்?", "பரிசோதித்து, பராமரித்து, சரியாக பயன்படுத்த வேண்டும்."),
                  _buildQuestionAnswer("❌ எதை தவிர்க்க வேண்டும்?", "தளர்ந்த உடை, ஈரமான கை, கவனக்குறைவு.", imagePath: 'assets/construction_3.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
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
