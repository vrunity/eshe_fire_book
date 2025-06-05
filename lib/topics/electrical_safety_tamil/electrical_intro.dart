import 'package:e_she_book/tamil/electrical_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElectricalIntroPageTamil extends StatefulWidget {
  @override
  _ElectricalIntroPageTamilState createState() => _ElectricalIntroPageTamilState();
}

class _ElectricalIntroPageTamilState extends State<ElectricalIntroPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ElectricalIntroTamil";

  final Map<int, String> correctAnswers = {
    1: "பாதிப்பு மற்றும் உயிரிழப்பைத் தவிர்க்க",
    2: "மின்சாட்டு, எரிச்சல் மற்றும் தீப்பற்றுதல்",
    3: "பாதுகாப்பான வேலை நடைமுறைகளைப் பின்பற்றுவதன் மூலம்",
    4: "சரியான பயிற்சி மற்றும் தனிப்பட்ட பாதுகாப்பு உபகரணங்கள்",
    5: "மின்சாரம் கண்ணுக்குத் தெரியாமல் ஆபத்தானது என்பதால்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {"question": "மின் பாதுகாப்பு ஏன் முக்கியம்?", "options": ["பாதிப்பு மற்றும் உயிரிழப்பைத் தவிர்க்க", "அலங்கரிக்க", "பதவி உயர்விற்காக", "வேடிக்கை காக"]},
    {"question": "மின்சாரம் தொடர்பான ஆபத்துகள் எவை?", "options": ["மின்சாட்டு, எரிச்சல் மற்றும் தீப்பற்றுதல்", "குளிர் காலநிலை", "இடி சத்தம்", "தூசி"]},
    {"question": "மின்சார விபத்துகளை எவ்வாறு குறைக்கலாம்?", "options": ["பாதுகாப்பான நடைமுறைகளை பின்பற்றுவதன் மூலம்", "பாதுகாப்பு விதிகளை புறக்கணித்து", "பாதுகாப்பற்ற கருவிகளைப் பயன்படுத்தி", "ஈரப்பதமான இடங்களில் வேலை செய்து"]},
    {"question": "மின் பாதுகாப்பின் முக்கிய கூறுகள் எவை?", "options": ["சரியான பயிற்சி மற்றும் PPE", "அனுமானம் வைத்து வேலை", "வழிபட்ட நம்பிக்கை", "தகுதியற்ற பணியாளர்களை நியமித்து"]},
    {"question": "மின்சாரத்தைக் கவனிக்க வேண்டியதற்கான காரணம் என்ன?", "options": ["மின்சாரம் கண்ணுக்குத் தெரியாமல் ஆபத்தானது என்பதால்", "விளக்குகளின் அழகு காரணமாக", "வண்ணமயமான கம்பிகள் காரணமாக", "மின்சாரம் மெதுவாக இருக்கிறது"]}
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
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("மின் பாதுகாப்பு அறிமுகம் வினாடி வினா"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"], style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[index],
                            onChanged: (String? value) {
                              setState(() {
                                userAnswers[index] = value!;
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
                        SnackBar(content: Text("அனைத்து கேள்விகளுக்கும் பதில் அளிக்கவும்")),
                      );
                    } else {
                      Navigator.of(context).pop();
                      _evaluateQuiz();
                    }
                  },
                )
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
          title: Text("வினாடி வினா முடிவுகள்"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3) // ✅ Only show Next if passing
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/common_hazards_ta'); // ✅ Tamil Next Page Link
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
                MaterialPageRoute(builder: (_) => ElectricalSafetyTamil()),
              );
            },
          ),
          title: Text("மின் பாதுகாப்பு அறிமுகம்")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("⚡ மின் பாதுகாப்பு என்றால் என்ன?", "மின்சாரம் காரணமாக ஏற்படும் ஆபத்துகளைத் தவிர்க்கும் நடைமுறைகள்.", imagePath: 'assets/electrical_1.0.png'),
                  _buildQuestionAnswer("⚡ மின்சாரம் ஏன் ஆபத்தானது?", "இது கண்ணுக்குத் தெரியாது, ஆனால் அது சாகும் ஆபத்தாக இருக்கலாம்."),
                  _buildQuestionAnswer("⚡ மின் பாதுகாப்புக்கு யார் பொறுப்பு?", "தொழிலாளர் மற்றும் மேலாளர்கள் இருவரும் பாதுகாப்பு உறுதி செய்ய வேண்டும்.", imagePath: 'assets/electrical_1.1.png'),
                  _buildQuestionAnswer("⚡ விபத்துகளைத் தடுக்கும் வழி என்ன?", "சரியான கருவிகளைப் பயன்படுத்தி மற்றும் பாதுகாப்பு நடைமுறைகளை பின்பற்றுவது."),
                  _buildQuestionAnswer("⚡ மின் பாதுகாப்பிற்கான முக்கிய கருவிகள் என்ன?", "துணிச்சல் கையுறை, மின்னோட்ட கண்டுபிடிப்பி, PPE, சர்க்யூட் பிரேக்கர்கள்.", imagePath: 'assets/electrical_1.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) {
                _saveTopicCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினாடி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சி செய்யவும்"),
              ),
          ],
        ),
      ),
    );
  }
}
