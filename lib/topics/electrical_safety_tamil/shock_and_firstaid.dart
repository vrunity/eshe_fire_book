import 'package:e_she_book/tamil/electrical_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShockAndFirstAidPageTamil extends StatefulWidget {
  @override
  _ShockAndFirstAidPageTamilState createState() => _ShockAndFirstAidPageTamilState();
}

class _ShockAndFirstAidPageTamilState extends State<ShockAndFirstAidPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ShockAndFirstAidTamil";

  final Map<int, String> correctAnswers = {
    1: "பாதிப்படைந்த நபரை தொடுவதற்கு முன் மின்சாரத்தை அணைக்கவும்",
    2: "உடனடியாக மூச்சு மற்றும் மண்டையெலும்பை சரிபார்க்கவும்",
    3: "முன்னே பாதுகாப்பாக இருப்பதை உறுதி செய்தவுடன் அவசர சேவைகளை அழைக்கவும்",
    4: "மிக அவசியமான சூழ்நிலை தவிர நோயாளியை நகர்த்தக்கூடாது",
    5: "முன்னறிவும் பயிற்சியும் இருந்தால் CPR செய்யவும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {"question": "மின்சாட்டு ஏற்பட்ட நபருக்கு முதலில் என்ன செய்ய வேண்டும்?", "options": ["பாதிப்படைந்த நபரை தொடுவதற்கு முன் மின்சாரத்தை அணைக்கவும்", "உதவிக்காக ஓடவும்", "நபரை விரைவாக நகர்த்தவும்", "அவருக்கு தண்ணீர் கொடுக்கவும்"]},
    {"question": "மின்சாரம் அணைக்கப்பட்ட பிறகு என்ன செய்ய வேண்டும்?", "options": ["உடனடியாக மூச்சு மற்றும் மண்டையெலும்பை சரிபார்க்கவும்", "அவரது உடையைச் சரிபார்க்கவும்", "அவரது குடும்பத்தை அழைக்கவும்", "அவரை தண்ணீரில் கழுவவும்"]},
    {"question": "எப்போது அவசர சேவையை அழைக்க வேண்டும்?", "options": ["முன்னே பாதுகாப்பாக இருப்பதை உறுதி செய்தவுடன்", "ஒரு மணி நேரம் கழித்து", "அவர்கள் கத்தினால்", "யாராவது கேட்டால் மட்டும்"]},
    {"question": "மின்சாட்டு ஏற்பட்ட நபரை நகர்த்தலாமா?", "options": ["மிக அவசியமான சூழ்நிலை தவிர நோயாளியை நகர்த்தக்கூடாது", "எப்போதும் விரைவாக நகர்த்த வேண்டும்", "அவரை தரையில் புரட்டவும்", "அவரை அமர வைத்திடவும்"]},
    {"question": "நபர் மூச்சுவிடவில்லை என்றால் என்ன செய்ய வேண்டும்?", "options": ["முன்னறிவும் பயிற்சியும் இருந்தால் CPR செய்யவும்", "அம்புலன்ஸ் வரும்வரை காத்திருக்கவும்", "குளிர்ந்த தண்ணீர் தெளிக்கவும்", "அவரை அதிரடியாக குலைக்கவும்"]}
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
              title: Text("மின்சாட்டு மற்றும் முதலுதவி வினா"),
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
          title: Text("வினாடி வினா முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/safe_use_equipment_ta');
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
            if (imagePath != null) SizedBox(height: 12),
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
              MaterialPageRoute(builder: (_) => ElectricalSafetyTamil()),
            );
          },
        ),
        title: Text("மின்சாட்டு மற்றும் முதலுதவி"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("⚡ முதலில் என்ன செய்ய வேண்டும்?", "பாதிப்படைந்த நபரை தொடுவதற்கு முன் மின்சாரத்தை அணைக்கவும்", imagePath: 'assets/electrical_3.0.png'),
                  _buildQuestionAnswer("⚡ அடுத்த படி என்ன?", "மூச்சு மற்றும் மண்டையெலும்பை உடனே சரிபார்க்கவும்"),
                  _buildQuestionAnswer("⚡ எப்போது அவசர சேவையை அழைக்க வேண்டும்?", "பாதுகாப்பாக இருப்பதை உறுதி செய்தவுடன்", imagePath: 'assets/electrical_3.1.png'),
                  _buildQuestionAnswer("⚡ அவரை நகர்த்தலாமா?", "மிக அவசியமான சூழ்நிலையில் மட்டும் நகர்த்தவும்"),
                  _buildQuestionAnswer("⚡ மூச்சில்லையெனில்?", "CPR செய்யவும் (பயிற்சி பெற்றால்)", imagePath: 'assets/electrical_3.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz) Text("கடைசி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சிக்கவும்"),
              ),
          ],
        ),
      ),
    );
  }
}
