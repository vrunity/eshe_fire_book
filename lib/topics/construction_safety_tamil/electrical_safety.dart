import 'package:e_she_book/tamil/construction_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElectricalSafetyTamilPage extends StatefulWidget {
  @override
  _ElectricalSafetyTamilPageState createState() => _ElectricalSafetyTamilPageState();
}

class _ElectricalSafetyTamilPageState extends State<ElectricalSafetyTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ElectricalSafetyTamil";

  final Map<int, String> correctAnswers = {
    1: "மின்சாரம் அணைத்து, கையுறை போன்ற பாதுகாப்பு கருவிகளை பயன்படுத்த வேண்டும்.",
    2: "இல்லை, பயிற்சி பெற்ற நபர்களே கைலாவ வேண்டும்.",
    3: "துணைக்கையுறை மற்றும் உலர்ந்த கைகளை பயன்படுத்த வேண்டும்.",
    4: "உடனடியாக மேற்பார்வையாளருக்கு தெரிவிக்க வேண்டும்.",
    5: "அவரை தொடாமல் அமைதியாக இருந்து உதவி அழைக்கவும்.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "திறந்த மின்கம்பிகளை எப்படிச் சமாளிப்பது?",
      "options": [
        "மின்சாரம் அணைத்து, கையுறை போன்ற பாதுகாப்பு கருவிகளை பயன்படுத்த வேண்டும்.",
        "கைம்மயிர் கொண்டு விரைவாக எடுக்க வேண்டும்.",
        "வேறொருவரிடம் செய்ய சொல்ல வேண்டும்.",
        "பொருட்படுத்தாமல் வேலையை தொடரவும்.",
      ]
    },
    {
      "question": "பயிற்சி இல்லாதவர்கள் மின் பழுதுகளை சரி செய்யலாமா?",
      "options": [
        "இல்லை, பயிற்சி பெற்ற நபர்களே கைலாவ வேண்டும்.",
        "ஆமாம், கையுறை அணிந்தால் போதும்.",
        "எவரும் சரி செய்யலாம்.",
        "இரவில் மட்டும் செய்யலாம்.",
      ]
    },
    {
      "question": "மின் உபகரணங்களை பாதுகாப்பாக இணைக்க/அனைக்க எப்படிச் செய்ய வேண்டும்?",
      "options": [
        "துணைக்கையுறை மற்றும் உலர்ந்த கைகளை பயன்படுத்த வேண்டும்.",
        "ஈரமான கைகளுடன் இணைக்கலாம்.",
        "உலோக பொருட்கள் கொண்டு செய்யலாம்.",
        "கம்பியை இழுத்து வலிக்க வேண்டும்.",
      ]
    },
    {
      "question": "மின் திடீர் தீப்பிழம்பு இருந்தால் என்ன செய்ய வேண்டும்?",
      "options": [
        "உடனடியாக மேற்பார்வையாளருக்கு தெரிவிக்க வேண்டும்.",
        "வேலையை தொடரவும்.",
        "துணிக்கையால் மூட வேண்டும்.",
        "தண்ணீர் தெளிக்க வேண்டும்.",
      ]
    },
    {
      "question": "யாராவது மின்சாரம் தாக்கினால் முதல் நடவடிக்கை என்ன?",
      "options": [
        "அவரை தொடாமல் அமைதியாக இருந்து உதவி அழைக்கவும்.",
        "அவரை இழுத்து காப்பாற்றவும்.",
        "தண்ணீர் ஊற்றவும்.",
        "அங்கிருந்து தப்பிக்க ஓடவும்.",
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
              title: Text("மின்சார பாதுகாப்பு வினா"),
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
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
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
        title: Text("மின்சார பாதுகாப்பு"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("⚡ திறந்த மின்கம்பிகளை எப்படிச் சமாளிப்பது?",
                      "மின்சாரம் அணைத்து, பாதுகாப்பு கருவிகளை பயன்படுத்த வேண்டும்.", imagePath: 'assets/construction_5.0.png'),
                  _buildQuestionAnswer("⚠️ யாரெல்லாம் மின் பழுதுகளை சரி செய்யலாம்?", "பயிற்சி பெற்ற நபர்களே செய்ய வேண்டும்."),
                  _buildQuestionAnswer("🔌 எப்படி சாதனங்களை இணைக்க / அணைக்க வேண்டும்?", "உலர்ந்த கைகள் மற்றும் கையுறை கொண்டு.", imagePath: 'assets/construction_5.1.png'),
                  _buildQuestionAnswer("🔥 தீப்பிழம்பு இருந்தால் என்ன செய்ய வேண்டும்?", "மேற்பார்வையாளரிடம் உடனடியாக தெரிவிக்கவும்."),
                  _buildQuestionAnswer("🚑 மின்சாரம் தாக்கினால் முதற்கட்ட நடவடிக்கை?", "அவரை தொடாமல் அமைதியாக இருந்து உதவி அழைக்கவும்.", imagePath: 'assets/construction_5.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிக்கப்பட்டதாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சி"),
              ),
          ],
        ),
      ),
    );
  }
}
