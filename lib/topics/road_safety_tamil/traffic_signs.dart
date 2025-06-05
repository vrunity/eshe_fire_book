import 'package:e_she_book/tamil/road_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrafficSignsPageTamil extends StatefulWidget {
  @override
  _TrafficSignsPageTamilState createState() => _TrafficSignsPageTamilState();
}

class _TrafficSignsPageTamilState extends State<TrafficSignsPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "TrafficSignsTamil";

  final Map<int, String> correctAnswers = {
    1: "சாலைப் பயணிகளை வழிநடத்தும் மற்றும் கட்டுப்படுத்தும்",
    2: "நீங்கள் முழுமையாக நின்றுவிட வேண்டும்",
    3: "மெதுவாக வாகனத்தை இயக்கி நின்றுவிட தயாராக இருங்கள்",
    4: "மக்கள் பாதுகாப்பாக சாலையை கடக்கும் இடம்",
    5: "பாதுகாப்பான வேகத்தை பராமரிக்கவும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "சாலை சிக்னல்களின் நோக்கம் என்ன?",
      "options": [
        "சாலைப் பயணிகளை வழிநடத்தும் மற்றும் கட்டுப்படுத்தும்",
        "சாலை அலங்கரிக்க",
        "ஓட்டுனர்களை குழப்ப",
        "நடக்கோர்களுக்கே மட்டும்"
      ]
    },
    {
      "question": "Stop சின்னத்தின் பொருள் என்ன?",
      "options": [
        "நீங்கள் முழுமையாக நின்றுவிட வேண்டும்",
        "சற்று மெதுவாக ஓட்டுங்கள்",
        "கிளாக்சன் அடித்து போங்கள்",
        "லைட் கொடுங்கள்"
      ]
    },
    {
      "question": "மஞ்சள் வண்ண சிக்னலின் அர்த்தம்?",
      "options": [
        "மெதுவாக வாகனத்தை இயக்கி நின்றுவிட தயாராக இருங்கள்",
        "வேகமாக ஓட்டுங்கள்",
        "தொடர்ந்து செல்லுங்கள்",
        "புறக்கணித்து செல்லலாம்"
      ]
    },
    {
      "question": "நடக்கோர்கள் கடக்கும் சின்னம் என்ன கூறுகிறது?",
      "options": [
        "மக்கள் பாதுகாப்பாக சாலையை கடக்கும் இடம்",
        "பைக் பாதை",
        "பார்கிங் இடம்",
        "அமைப்புப் பகுதி"
      ]
    },
    {
      "question": "வேகக் கட்டுப்பாட்டுச் சின்னங்கள் ஏன் முக்கியம்?",
      "options": [
        "பாதுகாப்பான வேகத்தை பராமரிக்கவும்",
        "வேகமாக ஓட்ட",
        "மற்ற வாகனங்களை வெல்ல",
        "முக்கியமில்லை"
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
              title: Text("சாலை சின்னங்கள் மற்றும் சிக்னல்கள் வினா"),
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
                        SnackBar(content: Text("தயவுசெய்து அனைத்து வினாக்களுக்கும் பதிலளிக்கவும்")),
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
          title: Text("வினா முடிவுகள்"),
          content: Text("நீங்கள் ${quizQuestions.length} வினாக்களில் $score மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/pedestrian_safety_ta');
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
              MaterialPageRoute(builder: (_) => RoadSafetyTamil()),
            );
          },
        ),
        title: Text("சாலை சிக்னல்கள் மற்றும் அடையாளங்கள்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🚦 சிக்னல்களின் நோக்கம் என்ன?", "சாலை சிக்னல்கள் பயணிகளை வழிநடத்த மற்றும் கட்டுப்படுத்த.", imagePath: 'assets/road_2.0.png'),
                  _buildQuestionAnswer("🚦 Stop சின்னத்தின் பொருள்?", "நீங்கள் முழுமையாக நின்றுவிட வேண்டும்."),
                  _buildQuestionAnswer("🚦 மஞ்சள் லைட் என்ன கூறுகிறது?", "மெதுவாக ஓட்டி நின்றுவிட தயாராக இருங்கள்.", imagePath: 'assets/road_2.1.png'),
                  _buildQuestionAnswer("🚦 நடக்கோர்களுக்கான சின்னம்?", "பாதுகாப்பாக சாலையை கடக்கும் இடத்தை குறிக்கும்."),
                  _buildQuestionAnswer("🚦 வேகக் கட்டுப்பாடு சின்னம் ஏன் முக்கியம்?", "பாதுகாப்பான ஓட்ட வேகத்தை உறுதி செய்ய.", imagePath: 'assets/road_2.2.png'),
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
              Text("கடைசி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
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
