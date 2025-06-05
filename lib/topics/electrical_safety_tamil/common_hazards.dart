import 'package:e_she_book/tamil/electrical_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonHazardsPageTamil extends StatefulWidget {
  @override
  _CommonHazardsPageTamilState createState() => _CommonHazardsPageTamilState();
}

class _CommonHazardsPageTamilState extends State<CommonHazardsPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "CommonHazardsTamil";

  final Map<int, String> correctAnswers = {
    1: "சிதைந்த கம்பிகள், அதிக சுமை கொண்ட சாக்கெட்டுகள், வெளிப்படையான மின் பகுதிகள்",
    2: "நீர் மின்சாரத்தை நன்கு செலுத்தும்",
    3: "பாதிக்கப்பட்ட கம்பிகள் மற்றும் மோசமான நிலைநிறுத்தம்",
    4: "பாதுகாப்பான மூடிகள் மற்றும் பீறல் கொண்டு பாதுகாப்பு",
    5: "மின் பகுதிகளின் அருகே எரிகிற பொருட்களை வைக்காமல் இருக்க வேண்டும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {"question": "பொதுவான மின் ஆபத்துகளின் எடுத்துக்காட்டுகள் என்ன?", "options": ["சிதைந்த கம்பிகள், அதிக சுமை கொண்ட சாக்கெட்டுகள், வெளிப்படையான மின் பகுதிகள்", "குளிர்காலம்", "ஈரமான தரை", "உடைந்த ஜன்னல்கள்"]},
    {"question": "மின்சாரத்துடன் அருகாமையில் நீர் ஏன் ஆபத்தானது?", "options": ["நீர் மின்சாரத்தை நன்கு செலுத்தும்", "நீர் மின்சாரத்தை நிறுத்தும்", "நீர் மின்கம்பிகளை பாதுகாக்கும்", "எவ்வித தாக்கமும் இல்லை"]},
    {"question": "பாதிக்கப்பட்ட மின் அமைப்புகளின் அடையாளங்கள் என்ன?", "options": ["பாதிக்கப்பட்ட கம்பிகள் மற்றும் மோசமான நிலைநிறுத்தம்", "நிறமயமான சுவிட்சுகள்", "குறைந்த நீள கம்பிகள்", "மரம் செய்த பிளக்"]},
    {"question": "வெளிப்படையான மின் பகுதிகளை எவ்வாறு பாதுகாப்பாக மாற்றலாம்?", "options": ["பாதுகாப்பான மூடிகள் மற்றும் பீறல் கொண்டு பாதுகாப்பு", "அதை வண்ணம் பூசுதல்", "நீளமான கம்பிகள் பயன்படுத்துதல்", "அதற்காக எதையும் செய்ய வேண்டாம்"]},
    {"question": "தீ ஆபத்துகளை எவ்வாறு குறைக்கலாம்?", "options": ["மின் பகுதிகளின் அருகே எரிகிற பொருட்களை வைக்காமல் இருக்க வேண்டும்", "ஊதல் இயந்திரங்களின் அருகே காகிதங்களை வைக்கவும்", "பாதிக்கப்பட்ட பிளக்குகளை பயன்படுத்தவும்", "உடைந்த கம்பிகளை புறக்கணிக்கவும்"]}
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
              title: Text("பொதுவான மின்சார ஆபத்துகள் வினாடி வினா"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int questionIndex = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question["question"],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
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
                        SnackBar(content: Text("அனைத்து கேள்விகளுக்கும் பதில் அளிக்கவும்")),
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
          title: Text("வினாடி வினா முடிவுகள்"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/shock_and_firstaid_ta'); // ✅ Tamil next page
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
          title: Text("பொதுவான மின்சார ஆபத்துகள்")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("⚡ பொதுவான மின்சார ஆபத்துகளின் எடுத்துக்காட்டுகள் என்ன?", "சிதைந்த கம்பிகள், அதிக சுமை கொண்ட சாக்கெட்டுகள், வெளிப்படையான மின் பகுதிகள்.", imagePath: 'assets/electrical_2.0.png'),
                  _buildQuestionAnswer("⚡ மின்சாரத்துடன் அருகாமையில் நீர் ஏன் ஆபத்தானது?", "நீர் மின்சாரத்தை நன்கு செலுத்தும் மற்றும் ஆபத்துகளை அதிகரிக்கும்."),
                  _buildQuestionAnswer("⚡ மோசமான மின் அமைப்புகளின் அறிகுறிகள் என்ன?", "பாதிக்கப்பட்ட கம்பிகள், முறையான நிலைநிறுத்தம் இல்லாதவை.", imagePath: 'assets/electrical_2.1.png'),
                  _buildQuestionAnswer("⚡ வெளிப்படையான பகுதிகளை எவ்வாறு பாதுகாப்பாக மாற்றலாம்?", "பாதுகாப்பான மூடிகள் மற்றும் பராமரிப்பு மூலம்."),
                  _buildQuestionAnswer("⚡ தீ ஆபத்துகளை எப்படி குறைக்கலாம்?", "எரிபொருள்களை மின் பகுதிகளிலிருந்து விலக்கி வைக்க வேண்டும்.", imagePath: 'assets/electrical_2.2.png'),
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
}
