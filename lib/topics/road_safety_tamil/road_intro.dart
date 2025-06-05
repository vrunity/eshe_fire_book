import 'package:e_she_book/tamil/road_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoadIntroPageTamil extends StatefulWidget {
  @override
  _RoadIntroPageTamilState createState() => _RoadIntroPageTamilState();
}

class _RoadIntroPageTamilState extends State<RoadIntroPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "RoadIntroTamil";

  final Map<int, String> correctAnswers = {
    1: "சாலை பாதுகாப்பு என்பது விபத்துகளைத் தடுக்கும் விதிமுறைகளும் நடத்தை முறைகளும் ஆகும்",
    2: "விபத்துகள் நேரும்போது காயங்களை குறைக்க முறுக்குக் கட்டுகள் உதவுகின்றன",
    3: "நடந்து செல்லும் பாதைகளை மற்றும் கடத்தலுக்கான இடங்களை பயன்படுத்தவும்",
    4: "சாலை அடையாளங்கள், சிக்னல்கள் மற்றும் வேகக் கட்டுப்பாடுகளை கடைபிடிக்கவும்",
    5: "எச்சரிக்கையுடன் இருங்கள் மற்றும் குழப்பங்களை தவிர்க்கவும்",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "சாலை பாதுகாப்பு என்றால் என்ன?",
      "options": [
        "சாலை பாதுகாப்பு என்பது விபத்துகளைத் தடுக்கும் விதிமுறைகளும் நடத்தை முறைகளும் ஆகும்",
        "விரைவாக ஓட்டுவது முக்கியம்",
        "விதிகளை புறக்கணிக்கலாம்",
        "சாலையில் சீரற்ற முறையில் நடக்கலாம்"
      ]
    },
    {
      "question": "முறுக்குக் கட்டு ஏன் முக்கியம்?",
      "options": [
        "விபத்துகள் நேரும்போது காயங்களை குறைக்க முறுக்குக் கட்டுகள் உதவுகின்றன",
        "அவை விருப்பமானவை",
        "அவை இயக்கத்தை மெதுவாக்குகின்றன",
        "அவை அணியக் கடினமாக இருக்கின்றன"
      ]
    },
    {
      "question": "நடந்துசெல்லும் நபர்கள் என்ன செய்ய வேண்டும்?",
      "options": [
        "நடந்து செல்லும் பாதைகள் மற்றும் கடத்தலுக்கான இடங்களை பயன்படுத்தவும்",
        "சாலையின் நடுவில் நடக்கவும்",
        "சிக்னல்களை புறக்கணிக்கவும்",
        "திடீரென சாலையை கடக்கவும்"
      ]
    },
    {
      "question": "விபத்துகளை எவ்வாறு குறைக்கலாம்?",
      "options": [
        "சாலை அடையாளங்கள், சிக்னல்கள் மற்றும் வேகக் கட்டுப்பாடுகளை கடைபிடிக்கவும்",
        "சிக்னல்களில் வேகமாக ஓட்டவும்",
        "ஓட்டும் போது போனை பயன்படுத்தவும்",
        "சிக்னல்களை புறக்கணிக்கவும்"
      ]
    },
    {
      "question": "ஓட்டுநர்களுக்கு என்ன முக்கியம்?",
      "options": [
        "எச்சரிக்கையுடன் இருங்கள் மற்றும் குழப்பங்களை தவிர்க்கவும்",
        "ஓட்டும் போது சாப்பிடவும்",
        "போனை பயன்படுத்தவும்",
        "கண்களை மூடுங்கள்"
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
              title: Text("சாலை பாதுகாப்பு அறிமுக வினா விடை"),
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
          title: Text("முடிவுகள்"),
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
                  Navigator.pushNamed(context, '/traffic_signs_ta');
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
        title: Text("சாலை பாதுகாப்பு அறிமுகம்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🚦 சாலை பாதுகாப்பு என்றால் என்ன?", "சாலை பாதுகாப்பு என்பது விபத்துகளைத் தடுக்கும் விதிமுறைகளும் நடத்தை முறைகளும் ஆகும்.", imagePath: 'assets/road_1.0.png'),
                  _buildQuestionAnswer("🚦 முறுக்குக் கட்டு ஏன்?", "விபத்துகளின் போது காயங்களை குறைக்கும் பாதுகாப்பு கருவி."),
                  _buildQuestionAnswer("🚦 நடன பயணிகள் பாதுகாப்பு?", "நடந்து செல்லும் பாதைகள் மற்றும் கடத்தலுக்கான இடங்களை பயன்படுத்தவும்.", imagePath: 'assets/road_1.1.png'),
                  _buildQuestionAnswer("🚦 விபத்துகளைத் தடுப்பது எப்படி?", "சிக்னல்களை பின்பற்றுங்கள், முறுக்குக் கட்டு அணியுங்கள்."),
                  _buildQuestionAnswer("🚦 ஓட்டுநர்களுக்கு முக்கியமானது?", "எச்சரிக்கையுடன் இருங்கள், போன்களை தவிர்க்கவும்.", imagePath: 'assets/road_1.2.png'),
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
