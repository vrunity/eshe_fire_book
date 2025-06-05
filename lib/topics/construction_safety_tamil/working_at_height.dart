import 'package:e_she_book/tamil/construction_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkingAtHeightTamilPage extends StatefulWidget {
  @override
  _WorkingAtHeightTamilPageState createState() => _WorkingAtHeightTamilPageState();
}

class _WorkingAtHeightTamilPageState extends State<WorkingAtHeightTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "WorkingAtHeightTamil";

  final Map<int, String> correctAnswers = {
    1: "முழு உடல் ஹார்னஸும் லைஃப்லைனும் பயன்படுத்த வேண்டும்.",
    2: "ஏணிகள் மற்றும் மேடைகளை பயன்படுத்துவதற்கு முன் பாதுகாப்பு பரிசோதனை செய்ய வேண்டும்.",
    3: "மிகுந்த காற்று அல்லது மழை உள்ளபோது உயரத்தில் வேலை செய்ய வேண்டாம்.",
    4: "தலையணை, நனைவில்லாத ஷூஸ், பாதுகாப்பான கருவிகள் போன்றவை அணிய வேண்டும்.",
    5: "மேடை பாதிப்பு அல்லது விழும் அபாயத்தை உடனடியாக புகாரளிக்கவும்.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "உயரத்தில் வேலை செய்யும் போது என்ன அணிய வேண்டும்?",
      "options": [
        "முழு உடல் ஹார்னஸும் லைஃப்லைனும் பயன்படுத்த வேண்டும்.",
        "பொதுவான தொப்பி மட்டும் போதும்.",
        "வழக்கமான ஷூஸ் போதும்.",
        "எந்ததும் தேவையில்லை."
      ]
    },
    {
      "question": "ஏறுவதற்கு முன் என்ன செய்ய வேண்டும்?",
      "options": [
        "ஏணிகள் மற்றும் மேடைகளை பயன்படுத்துவதற்கு முன் பாதுகாப்பு பரிசோதனை செய்ய வேண்டும்.",
        "தொலைபேசியை சார்ஜ் செய்ய வேண்டும்.",
        "செல்பி எடுக்க வேண்டும்.",
        "கத்தி ஒலி செய்ய வேண்டும்."
      ]
    },
    {
      "question": "எப்போது உயரத்தில் வேலை செய்யக்கூடாது?",
      "options": [
        "மிகுந்த காற்று அல்லது மழை உள்ளபோது உயரத்தில் வேலை செய்ய வேண்டாம்.",
        "எந்த காலநிலையிலும் வேலை செய்யலாம்.",
        "இரவில் மட்டும் வேலை செய்யலாம்.",
        "கடுமையான வெயிலில் வேலை செய்யலாம்."
      ]
    },
    {
      "question": "பாதுகாப்பு கருவிகள் எவை?",
      "options": [
        "தலையணை, நனைவில்லாத ஷூஸ், பாதுகாப்பான கருவிகள் போன்றவை அணிய வேண்டும்.",
        "வண்ணாடை அணிவது போதும்.",
        "சளிச்சலான சிள்ளிகள் போதும்.",
        "கைப்புறை மட்டும் போதும்."
      ]
    },
    {
      "question": "விழும் அபாயத்தை பார்த்தால் என்ன செய்ய வேண்டும்?",
      "options": [
        "மேடை பாதிப்பு அல்லது விழும் அபாயத்தை உடனடியாக புகாரளிக்கவும்.",
        "பொருட்படுத்தாமல் தொடரவும்.",
        "நண்பனை அழைத்து சரி செய்ய சொல்லவும்.",
        "யாராவது பார்ப்பதை காத்திருக்கவும்."
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
              title: Text("உயரத்தில் வேலை - வினாடி வினா"),
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
                        SnackBar(content: Text("தயவுசெய்து அனைத்து கேள்விகளுக்கும் பதில் அளிக்கவும்")),
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
          title: Text("வினாடி வினா முடிவு"),
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
        title: Text("உயரத்தில் வேலை பாதுகாப்பு"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🧍 ஏன் பாதுகாப்பு கருவி அணிய வேண்டும்?", "உயரத்தில் விழாமல் இருக்க ஹார்னஸ் மற்றும் லைஃப்லைன் தேவை.", imagePath: 'assets/construction_4.0.png'),
                  _buildQuestionAnswer("✅ ஏறுவதற்கு முன் என்ன செய்ய வேண்டும்?", "ஏணி, மேடை மற்றும் தங்கும் இடத்தை சரிபார்க்க வேண்டும்."),
                  _buildQuestionAnswer("🌪 எந்த நிலையில் வேலை செய்யக்கூடாது?", "மிகுந்த காற்று அல்லது மழையில் வேலை செய்ய வேண்டாம்.", imagePath: 'assets/constuction_4.1.png'),
                  _buildQuestionAnswer("👷‍♂️ தேவையான பாதுகாப்பு?", "தலையணை, பிடிப்பு ஷூஸ், பாதுகாப்பான கருவிகள்."),
                  _buildQuestionAnswer("🚨 அபாயம் இருந்தால்?", "உடனடியாக மேடை பிழைகள் அல்லது அபாயங்களை புகாரளிக்கவும்.", imagePath: 'assets/construction_4.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிக்கப்பட்டதாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz) Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
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
