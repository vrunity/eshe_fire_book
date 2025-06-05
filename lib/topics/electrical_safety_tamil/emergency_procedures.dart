import 'package:e_she_book/tamil/electrical_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class EmergencyProceduresPageTamil extends StatefulWidget {
  @override
  _EmergencyProceduresPageTamilState createState() => _EmergencyProceduresPageTamilState();
}

class _EmergencyProceduresPageTamilState extends State<EmergencyProceduresPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EmergencyProceduresTamil";

  final Map<int, String> correctAnswers = {
    1: "உடனடியாக மின்சாரத்தை அணைக்கவும்",
    2: "மின்சாரம் அணைக்கப்படும்வரை நபரை தொடக்கூடாது",
    3: "நிகழ்வு பாதுகாப்பாக இருக்கும் போது உடனே அவசர சேவையை அழைக்கவும்",
    4: "பாதுகாப்பானதாக இருந்தால் உலர்ந்த மரக்கம்பு போன்ற பொருளை பயன்படுத்தி நபரை எடுத்திழுக்கவும்",
    5: "முதலுதவி வழங்கி நபருடன் இருக்கவும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {"question": "மின் விபத்தில் முதலில் என்ன செய்ய வேண்டும்?", "options": ["உடனடியாக மின்சாரத்தை அணைக்கவும்", "மற்றவர்களை அழைக்க ஓடவும்", "நபரை நகர்த்தவும்", "அவர்மேல் தண்ணீர் ஊற்றவும்"]},
    {"question": "மின்சாரம் இன்னும் ஓடிக் கொண்டிருக்கும்போது நபரை தொடலாமா?", "options": ["மின்சாரம் அணைக்கப்படும்வரை நபரை தொடக்கூடாது", "விரைவாக இழுக்கவும்", "கையை வைத்து தள்ளவும்", "கம்பளி கொண்டு மூடவும்"]},
    {"question": "எப்போது அவசர சேவையை அழைக்க வேண்டும்?", "options": ["நிகழ்வு பாதுகாப்பாக இருக்கும் போது உடனே", "10 நிமிடங்களுக்குப் பிறகு", "நபரிடம் பேசிய பிறகு", "அவர்கள் அழும் போது"]},
    {"question": "நபரை பாதுகாப்பாக நகர்த்த வேண்டுமா?", "options": ["உலர்ந்த மரக்கம்பு அல்லது மின்சாரம் செல்லாத பொருள் மூலம் நகர்த்தவும்", "ஈரமான கையால் இழுக்கவும்", "உலோக கம்பியைப் பயன்படுத்தவும்", "தண்ணீர் தெளிக்கவும்"]},
    {"question": "நபரை மீட்ட பிறகு என்ன செய்ய வேண்டும்?", "options": ["முதலுதவி வழங்கி நபருடன் இருக்கவும்", "அவரை தனியாக விடவும்", "குளிர்ந்த துணியால் மூடவும்", "அவரை உட்கார வைக்கவும்"]}
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
              title: Text("அவசரநிலை நடைமுறைகள் வினா"),
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
                        SnackBar(content: Text("அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
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

  void _evaluateQuiz() async {
    int score = 0;
    userAnswers.forEach((key, value) {
      if (correctAnswers[key] == value) {
        score++;
      }
    });

    await _saveQuizScore(score);

    if (score >= 3) {
      final String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('CourseCompletedOn_Electrical Safety', formattedDate);
      print("✅ Electrical Safety Complete Date Stored: $formattedDate");
    }

    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("வினா முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ElectricalSafetyTamil()),
              ),
            ),
            TextButton(
              child: Text("மீண்டும் முயற்சி செய்யவும்"),
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
        title: Text("அவசரநிலை நடைமுறைகள்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("⚡ மின் விபத்தில் முதலில் என்ன செய்ய வேண்டும்?", "உடனடியாக மின்சாரத்தை அணைக்கவும்", imagePath: 'assets/electrical_4.0.png'),
                  _buildQuestionAnswer("⚡ மின்சாரம் ஓடிக்கொண்டிருக்கும்போது நபரை தொடலாமா?", "மின்சாரம் அணைக்கப்படும்வரை நபரை தொடக்கூடாது"),
                  _buildQuestionAnswer("⚡ எப்போது அவசர சேவையை அழைக்க வேண்டும்?", "நிகழ்வு பாதுகாப்பாக இருப்பதை உறுதி செய்தவுடன்", imagePath: 'assets/electrical_3.1.png'),
                  _buildQuestionAnswer("⚡ நபரை பாதுகாப்பாக நகர்த்த வேண்டுமா?", "உலர்ந்த மரக்கம்பு அல்லது மின்சாரம் செல்லாத பொருள் கொண்டு நகர்த்தவும்"),
                  _buildQuestionAnswer("⚡ நபரை மீட்ட பிறகு என்ன செய்ய வேண்டும்?", "முதலுதவி வழங்கி நபருடன் இருக்கவும்", imagePath: 'assets/electrical_2.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
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
