// Flutter page for Topic 7: Foot Protection (Tamil)

import 'package:e_she_book/tamil/ppe_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class FootProtectionPageTamil extends StatefulWidget {
  @override
  _FootProtectionPageTamilState createState() => _FootProtectionPageTamilState();
}

class _FootProtectionPageTamilState extends State<FootProtectionPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FootProtectionTamil";

  final Map<int, String> correctAnswers = {
    1: "கால்களுக்கு விழும் பொருட்கள் மற்றும் வழுக்கல்களிலிருந்து பாதுகாப்பதற்காக",
    2: "பாதுகாப்பு காலணிகள் மற்றும் பூட்ஸ்",
    3: "வழுக்காத அடிகள் மற்றும் பாதுகாப்பு முந்தியங்கள்",
    4: "சரியான அளவு மற்றும் சேதம் இல்லையா என சோதிக்கவும்",
    5: "கால்கள் தொடர்பான அபாயங்கள் உள்ள இடங்களில் வேலை செய்யும் போது",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "கால் பாதுகாப்பு ஏன் தேவை?",
      "options": [
        "நன்றாக நடக்க",
        "கால்களுக்கு விழும் பொருட்கள் மற்றும் வழுக்கல்களிலிருந்து பாதுகாப்பதற்காக",
        "ஷூவை சுத்தமாக வைத்திருக்க",
        "ஃபேஷனுக்காக"
      ]
    },
    {
      "question": "கால்களுக்கு எவ்வகை பாதுகாப்பு உபகரணங்கள் உள்ளன?",
      "options": [
        "சந்தல்கள்",
        "பாதுகாப்பு காலணிகள் மற்றும் பூட்ஸ்",
        "செருப்புகள்",
        "பாதுகாப்பு இல்லாமல்"
      ]
    },
    {
      "question": "பாதுகாப்பு காலணிகளின் முக்கிய அம்சங்கள் என்ன?",
      "options": [
        "விளக்கமான நிறங்கள்",
        "மென்மையான அடிகள்",
        "வழுக்காத அடிகள் மற்றும் பாதுகாப்பு முந்தியங்கள்",
        "திறந்த முனை வடிவம்"
      ]
    },
    {
      "question": "பாதுகாப்பு காலணிகளை எப்படிப் பராமரிப்பது?",
      "options": [
        "சரியான அளவு மற்றும் சேதம் இல்லையா என சோதிக்கவும்",
        "தினமும் பாலிஷ் செய்யவும்",
        "சுத்தம் செய்யாமல் விடவும்",
        "வேறொரு ஜோடி அணியவும்"
      ]
    },
    {
      "question": "எப்போது கால்கள் பாதுகாப்பு தேவை?",
      "options": [
        "மட்டும் கூட்டங்களில்",
        "வீட்டில்",
        "கால்கள் தொடர்பான அபாயங்கள் உள்ள இடங்களில் வேலை செய்யும் போது",
        "மட்டும் அலுவலகங்களில்"
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
    if (value) {
      _showQuizDialog();
    }
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
              title: Text("கால் பாதுகாப்பு வினாடி வினா"),
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
                        SnackBar(content: Text("தயவுசெய்து அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
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
      await prefs.setString('CourseCompletedOn_PPE', formattedDate);
    }

    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("வினாடி வினா முடிவு"),
          content: Text("நீங்கள் ${quizQuestions.length} இல் $score மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
          actions: [
            if (score >= 3)
              TextButton(
                child: Text("அடுத்து"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ppe_tamil()),
                  );
                },
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
        padding: EdgeInsets.all(12),
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
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("கால் பாதுகாப்பு")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🥾 கால் பாதுகாப்பு என்றால் என்ன?", "விழும் பொருட்கள், கூர்மையான பொருட்கள் அல்லது வழுக்கல்களில் இருந்து கைகளை பாதுகாப்பதற்காக பாதுகாப்பு காலணிகள் அணிவது.", imagePath: 'assets/ppe_5.0.png'),
                  _buildQuestionAnswer("🥾 இது ஏன் முக்கியம்?", "கால் காயங்கள் நீண்ட கால வேலைநீக்கம் மற்றும் நகர்வின் குறைவுக்கு காரணமாகும்."),
                  _buildQuestionAnswer("🥾 பொதுவான கால் அபாயங்கள் என்ன?", "விழும் கருவிகள், கூர்மையான பொருட்கள், சூடான மேடைகள் மற்றும் இரசாயன கசியல்கள்.", imagePath: 'assets/ppe_5.1.png'),
                  _buildQuestionAnswer("🥾 எத்தகைய காலணிகள் உள்ளன?", "ஸ்டீல் டோ பூட்ஸ், வழுக்காத காலணிகள், இரசாயன எதிர்ப்பு பூட்ஸ்."),
                  _buildQuestionAnswer("🥾 யாருக்கு தேவை?", "மண்வெட்டி, கையிறைச்சல், இரசாயன கையாளுதல் போன்ற வேலைகள் செய்பவர்கள்."),
                  _buildQuestionAnswer("🥾 எப்போது பரிசோதிக்க வேண்டும்?", "ஒவ்வொரு பணிப் பணியும் முன்னர் சேதமோ kulappamo என பரிசோதிக்க வேண்டும்.", imagePath: 'assets/ppe_5.2.png'),
                  _buildQuestionAnswer("🥾 சேதமடைந்த காலணிகள் பாதுகாப்பா?", "இல்லை. உடனே மாற்ற வேண்டும்."),
                  _buildQuestionAnswer("🥾 விளையாட்டு ஷூ வேலைக்கு ஏற்கத்தக்கதா?", "இல்லை, பாதுகாப்பு சான்றளிக்கப்பட்டவையாக இல்லையெனில்.", imagePath: 'assets/ppe_5.3.png'),
                  _buildQuestionAnswer("🥾 பாதுகாப்பு காலணிகளுக்கு எந்த தரநிலைகள் உள்ளன?", "ASTM அல்லது ISI போன்ற தரச்சான்றுகளுடன் இருக்க வேண்டும்."),
                  _buildQuestionAnswer("🥾 யார் வழங்க வேண்டும்?", "பாதுகாப்பு காலணிகளை வழங்குவது பொதுவாக நியாயபூர்வமாக வேலை கொடுப்பவரின் கடமையாகும்.", imagePath: 'assets/ppe_5.4.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("நிறைவு செய்யப்பட்டது என குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினாடி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் முயற்சி"),
              )
          ],
        ),
      ),
    );
  }
}
