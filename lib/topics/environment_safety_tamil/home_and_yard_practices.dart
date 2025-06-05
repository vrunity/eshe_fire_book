import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/environment_safety_tamil.dart';
import 'package:intl/intl.dart';

class HomeAndYardPracticesTamilPage extends StatefulWidget {
  @override
  _HomeAndYardPracticesTamilPageState createState() => _HomeAndYardPracticesTamilPageState();
}

class _HomeAndYardPracticesTamilPageState extends State<HomeAndYardPracticesTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EnvTopic5";

  final Map<int, String> correctAnswers = {
    1: "எல்இடி பல்புகளை பயன்படுத்தவும் மற்றும் வீடு முறையாக ஒதுக்கி வைத்திருப்பதை உறுதி செய்யவும்.",
    2: "சோலார் பானல்கள் மற்றும் ஆற்றல் சேமிப்பு சாதனங்களை நிறுவவும்.",
    3: "வீட்டின் சுற்றிலும் மரங்களை நடவும்.",
    4: "ராசாயன பூச்சிக்கொல்லிகள் மற்றும் உரங்களை தவிர்க்கவும்.",
    5: "உழைகக்கூடிய குப்பைகளை மீள்பயன்படுத்துவதற்கான இடம் அமைக்கவும்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "மின்சாரம் பயன்பாட்டை குறைக்க ஒரு வழி என்ன?",
      "options": [
        "நாள் முழுவதும் விளக்குகளை இயக்கவும்",
        "எல்இடி பல்புகளை பயன்படுத்தவும் மற்றும் வீடு முறையாக ஒதுக்கி வைத்திருப்பதை உறுதி செய்யவும்.",
        "பழைய சாதனங்களை பயன்படுத்தவும்",
        "விந்தைகளைக் காற்றோட்டமாக விடவும்"
      ]
    },
    {
      "question": "சோலார் பானல்கள் வீடுகளில் எவ்வாறு உதவுகிறது?",
      "options": [
        "மின்சார கட்டணங்களை அதிகரிக்கும்",
        "அழகிற்காக",
        "சோலார் பானல்கள் மற்றும் ஆற்றல் சேமிப்பு சாதனங்களை நிறுவவும்.",
        "இவை இரவில் மட்டுமே வேலை செய்கிறது"
      ]
    },
    {
      "question": "வீட்டின் சுற்றிலும் மரங்கள் நடுவது எப்படி உதவுகிறது?",
      "options": [
        "புதிய காற்றைத் தடுக்கும்",
        "பூச்சிகளை ஈர்க்கும்",
        "மின்சார பயன்பாட்டை அதிகரிக்கும்",
        "வீட்டின் சுற்றிலும் மரங்களை நடவும்."
      ]
    },
    {
      "question": "யார்ட்டை சூழலுக்கு ஏற்றதாக எவ்வாறு வைத்திருக்கலாம்?",
      "options": [
        "ராசாயன பூச்சிக்கொல்லிகள் மற்றும் உரங்களை தவிர்க்கவும்.",
        "பிளாஸ்டிக் அலங்காரங்களை பயன்படுத்தவும்",
        "தீவிரமான ரசாயனங்களை அடிக்கடி தெளிக்கவும்",
        "ஒளிரும் அலங்கார விளக்குகளை நிறுவவும்"
      ]
    },
    {
      "question": "உழைகக்கூடிய குப்பைகளுக்கு என்ன செய்யலாம்?",
      "options": [
        "ஆற்றில் வீசவும்",
        "எரிக்கவும்",
        "உழைகக்கூடிய குப்பைகளை மீள்பயன்படுத்துவதற்கான இடம் அமைக்கவும்.",
        "அவை வீட்டுக்குள் சேர்க்கவும்"
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
      isCompleted = prefs.getBool('Completed_\$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_\$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_\$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_\$topicName', value);
    setState(() {
      isCompleted = value;
    });
    if (value) _showQuizDialog();
  }

  Future<void> _saveQuizScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('QuizScore_\$topicName', score);
    await prefs.setBool('QuizTaken_\$topicName', true);
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
              title: Text("வினா - வீடு மற்றும் யார்ட் நடைமுறைகள்"),
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
      await prefs.setString('CourseCompletedOn_Environmental Safety', formattedDate);
      print("✅ Course completed date stored for Environmental Safety: $formattedDate");
    }

    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("வினா விளைவு"),
          content: Text("மொத்தம் ${quizQuestions.length} கேள்விகளில் நீங்கள் $score பெறுபெற்கள் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () =>  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EnvironmentalSafetyTamil()),
              ),
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
        title: Text("வீடு மற்றும் யார்ட் நடைமுறைகள்"),
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
                  _buildQuestionAnswer("💡 திறமையான ஒளியமைப்பு", "எல்இடி பல்புகளை பயன்படுத்தவும் மற்றும் தேவையில்லாத போது விளக்குகளை அணைக்கவும்.", imagePath: 'assets/env_5.0.png'),
                  _buildQuestionAnswer("🏡 ஆற்றல் மிக்க வீடு", "வீட்டை ஒதுக்கி வைத்து சோலார் எரிசக்தியை பயன்படுத்தவும்."),
                  _buildQuestionAnswer("🌳 மரங்களை நட்டு சாயல் ஏற்படுத்தவும்", "மரங்கள் குளிர்ச்சியை வழங்குவதால் ஆற்றல் சேமிக்கலாம்.", imagePath: 'assets/env_5.1.png'),
                  _buildQuestionAnswer("🚫 தீங்கான ரசாயனங்களை தவிர்க்கவும்", "இயற்கை மாற்றுகளை பயன்படுத்தி பூச்சிக்கொல்லிகளை மாற்றவும்."),
                  _buildQuestionAnswer("🌱 உரமிடல்", "சமையல் கழிவுகள் மற்றும் இயற்கை குப்பைகளை பயன்படுத்தி உரமாக மாற்றலாம்.", imagePath: 'assets/env_5.2.png'),
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
