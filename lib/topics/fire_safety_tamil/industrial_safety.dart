import 'package:e_she_book/tamil/fire_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class IndustrialSafetyPage extends StatefulWidget {
  @override
  _IndustrialSafetyPageState createState() => _IndustrialSafetyPageState();
}

class _IndustrialSafetyPageState extends State<IndustrialSafetyPage> {
  bool istopic_7_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "IndustrialSafety"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "யந்திரங்கள் அதிக சூடாகுதல், ரசாயனச் சேமிப்பு மற்றும் மின்சார குறைபாடுகள்",
    2: "வழக்கமான சாதன பராமரிப்பு, தீ பயிற்சிகள் மற்றும் பாதுகாப்பு உபகரணங்கள் பயன்பாடு",
    3: "தீ பரவுவதற்கு முன் கண்டறிந்து கட்டுப்படுத்த",
    4: "தீ அணைப்பு நடவடிக்கைக்காக தொடர்ச்சியான நீர் வழங்கும் வசதி",
    5: "தீக்காயம் மற்றும் நச்சு புகைநீக்கத்திலிருந்து ஊழியர்களை பாதுகாப்பது"
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "தொழிற்சாலைகளில் தீயின் முக்கிய அபாயங்கள் என்ன?",
      "options": [
        "யந்திரங்கள் அதிக சூடாகுதல், ரசாயனச் சேமிப்பு மற்றும் மின்சார குறைபாடுகள்",
        "மின்சாரப் பிரச்சனைகள் மட்டும்",
        "தொழிற்சாலைகளில் எந்த அபாயமும் இல்லை",
        "தொழிற்சாலைகளில் தீ ஏற்படாது"
      ]
    },
    {
      "question": "தொழிற்சாலைகள் தீ அபாயங்களை எவ்வாறு தடுக்க முடியும்?",
      "options": [
        "வழக்கமான சாதன பராமரிப்பு, தீ பயிற்சிகள் மற்றும் பாதுகாப்பு உபகரணங்கள் பயன்பாடு",
        "பாதுகாப்பு பயிற்சிகளை புறக்கணித்தல்",
        "தீ அலாரங்களை மட்டுமே பயன்படுத்துதல்",
        "எந்த முன்னெச்சரிக்கையும் தேவையில்லை"
      ]
    },
    {
      "question": "தொழில்களில் தீ கண்டறியும் அமைப்புகள் ஏன் இருக்க வேண்டும்?",
      "options": [
        "தீ பரவுவதற்கு முன் கண்டறிந்து கட்டுப்படுத்த",
        "அலங்காரத்திற்காக",
        "அவை தேவையில்லை",
        "செலவுகளை அதிகரிக்க"
      ]
    },
    {
      "question": "தொழிற்சாலைகளில் Fire Hydrant அமைப்பின் நோக்கம் என்ன?",
      "options": [
        "தீ அணைப்பு நடவடிக்கைக்காக தொடர்ச்சியான நீர் வழங்கும் வசதி",
        "அலங்காரமாக பயன்படுத்த",
        "இதில் பயன் இல்லை",
        "சட்டபூர்வம் மட்டுமே வைத்திருக்கப்படுகிறது"
      ]
    },
    {
      "question": "தீ பாதுகாப்பில் தனிப்பட்ட பாதுகாப்பு உபகரணங்கள் (PPE) எப்படி உதவுகின்றன?",
      "options": [
        "தீக்காயம் மற்றும் நச்சு புகைநீக்கத்திலிருந்து ஊழியர்களை பாதுகாப்பது",
        "அவை தோற்றத்திற்காக மட்டுமே",
        "அவை தேவையற்றவை",
        "PPE வை தீயணைப்பு வீரர்கள் மட்டுமே பயன்படுத்த வேண்டும்"
      ]
    },
  ];


  @override
  void initState() {
    super.initState();
    _loadTopicCompletionStatus();
  }

  Future<void> _loadTopicCompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      istopic_7_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_7_Completed = value;
    });

    if (value) {
      Future.delayed(Duration(milliseconds: 300), () {
        _showQuizDialog();
      });
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
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Industrial Fire Safety Quiz"),
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
      await prefs.setString('CourseCompletedOn $topicName', formattedDate);
      print("✅ Course completed date stored: $formattedDate");
    }

    _showQuizResult(score);
  }
  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("வினாடி வினா முடிவு"),
          content: Text("You scored $score out of ${quizQuestions.length}."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove shadow for clean UI
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF4500), Color(0xFF5B0000)], // Red to Dark Maroon
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28), // Back Arrow
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => fire_safety_tamil()),
              );
            },
          ),title: Text("தொழிற்சாலை தீ பாதுகாப்பு")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 தொழிற்சாலைகளில் தீயின் முக்கிய அபாயங்கள் என்ன?", "யந்திரங்கள் அதிக சூடாகுதல், ரசாயனச் சேமிப்பு மற்றும் மின்சார குறைபாடுகள்.",imagePath: 'assets/banner_7.1.jpg'),
                  _buildQuestionAnswer("🔥 தொழிற்சாலைகள் தீ அபாயங்களை எவ்வாறு தடுக்க முடியும்?", "வழக்கமான சாதன பராமரிப்பு, தீ பயிற்சிகள் மற்றும் பாதுகாப்பு உபகரணங்கள் பயன்பாடு."),
                  _buildQuestionAnswer("🔥 தொழில்களில் தீ கண்டறியும் அமைப்புகள் ஏன் இருக்க வேண்டும்?", "தீ பரவுவதற்கு முன் கண்டறிந்து கட்டுப்படுத்த.",imagePath: 'assets/banner_7.2.jpg'),
                  _buildQuestionAnswer("🔥 தொழிற்சாலைகளில் Fire Hydrant அமைப்பின் நோக்கம் என்ன?", "தீ அணைப்பு நடவடிக்கைக்காக தொடர்ச்சியான நீர் வழங்கும் வசதி."),
                  _buildQuestionAnswer("🔥 தீ பாதுகாப்பில் தனிப்பட்ட பாதுகாப்பு உபகரணங்கள் (PPE) எப்படி உதவுகின்றன?", "தீக்காயம் மற்றும் நச்சு புகைநீக்கத்திலிருந்து ஊழியர்களை பாதுகாப்பது.",imagePath: 'assets/banner_7.3.jpg'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: istopic_7_Completed,
              onChanged: (value) {
                _saveTopicCompletionStatus(value ?? false);
              },
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
            // If image is provided, show it at the top full-width
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
            // Question
            Text(
              question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 6),
            // Answer
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
