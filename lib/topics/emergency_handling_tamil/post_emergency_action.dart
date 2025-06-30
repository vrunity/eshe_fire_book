import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/emergency_handling_tamil.dart';
import 'package:intl/intl.dart';

class PostEmergencyActionsTamil extends StatefulWidget {
  @override
  _PostEmergencyActionsStateTamil createState() => _PostEmergencyActionsStateTamil();
}

class _PostEmergencyActionsStateTamil extends State<PostEmergencyActionsTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicKey = "PostEmergencyActions";

  final Map<int, String> correctAnswers = {
    1: "நிலைமை மற்றும் சேதத்தை மதிப்பிட",
    2: "தேவைப்படும் சிகிச்சை வழங்க",
    3: "மீண்டும் நிகழ்வதைத் தடுக்கும்",
    4: "ஆம், இது மேம்பாட்டுக்கு உதவும்",
    5: "முடிவடைந்து கற்றது உறுதிப்படுத்தப்படுகிறது"
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "அவசரத்துக்குப் பிந்தைய நடவடிக்கைகள் ஏன் முக்கியம்?",
      "options": [
        "நிலைமை மற்றும் சேதத்தை மதிப்பிட",
        "அறிக்கைகளை புறக்கணிக்க",
        "புகார்கள் அளிக்க",
        "ஊழியர்களை தண்டிக்க"
      ]
    },
    {
      "question": "காயமடைந்தவர்களுக்கு என்ன செய்யப்படுகிறது?",
      "options": [
        "அவர்களை புறக்கணிக்க",
        "அவர்களை குற்றம் சொல்வது",
        "தேவைப்படும் சிகிச்சை வழங்க",
        "உடனே வீட்டுக்கு அனுப்ப"
      ]
    },
    {
      "question": "காரணங்களை ஆராய்வது ஏன்?",
      "options": [
        "நேரம் வீணாக்க",
        "மீண்டும் நிகழ்வதைத் தடுக்கும்",
        "குற்றம் சொல்ல",
        "அறிக்கையை தாமதிக்க"
      ]
    },
    {
      "question": "கருத்து திரும்பிப் பார்க்கும் செயல் முக்கியமா?",
      "options": [
        "இல்லை, அது உதவாது",
        "ஆம், இது மேம்பாட்டுக்கு உதவும்",
        "HRக்காக மட்டும்",
        "எப்போதும் தவிர்க்கவும்"
      ]
    },
    {
      "question": "பயிற்சி முடித்ததை குறிவைக்கும் முக்கியம்?",
      "options": [
        "முடிவடைந்து கற்றது உறுதிப்படுத்தப்படுகிறது",
        "அலங்காரத்திற்காக",
        "பட்ஜெட்டைக் செலவழிக்க",
        "எந்த காரணமும் இல்லை"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCompleted = prefs.getBool('Completed_$topicKey') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicKey') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicKey') ?? false;
    });
  }

  Future<void> _saveCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicKey', value);
    setState(() {
      isCompleted = value;
    });
    if (value) _showQuizDialog();
  }

  Future<void> _saveQuizScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('QuizScore_$topicKey', score);
    await prefs.setBool('QuizTaken_$topicKey', true);
    if (score >= 3) {
      final date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
      await prefs.setString('EmergencyHandling_CompletedOn', date);
    }
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
              title: Text("வினாடி வினா: அவசரத்துக்குப் பிந்தைய நடவடிக்கைகள்"),
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
                  child: Text("சமர்ப்பி"),
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
          title: Text("வினாடி வினா முடிவு"),
          content: Text("நீங்கள் $score / ${quizQuestions.length} பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("முடிக்கவும்"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => EmergencyHandlingTamil()),
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

  Widget _buildQA(String question, String answer, {String? imagePath}) {
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
        title: Text("அவசரத்துக்குப் பிந்தைய நடவடிக்கைகள்"),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => EmergencyHandlingTamil()),
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
                  _buildQA("அவசரத்துக்குப் பிந்தைய நடவடிக்கைகள் ஏன்?", "நிலைமை, சேதம் மற்றும் தயார்பாடுகளை மேம்படுத்த மதிப்பிட.", imagePath: 'assets/post_1.png'),
                  _buildQA("காயமடைந்தவர்களுக்கு சிகிச்சை", "உடனடி மருத்துவ உதவி வழங்கப்படுகிறது."),
                  _buildQA("ஆராய்வு முக்கியத்துவம்", "இதுபோன்ற நிகழ்வுகள் மீண்டும் நிகழாமல் தடுக்கும்."),
                  _buildQA("கருத்து திரும்பிப் பார்ப்பு", "ஆம், இது எதிர்கால செயல்பாடுகளை மேம்படுத்தும்."),
                  _buildQA("பயிற்சி முடித்ததை குறிவைக்கும்", "முடிவடைந்து கற்றது உறுதிப்படுத்தப்படுகிறது.", imagePath: 'assets/post_2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) {
                _saveCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசியாக பெற்ற மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி")),
          ],
        ),
      ),
    );
  }
}
