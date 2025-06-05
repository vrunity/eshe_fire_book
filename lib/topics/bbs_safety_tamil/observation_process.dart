import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/bbs_safety_english.dart';

class ObservationProcessPageTamil extends StatefulWidget {
  @override
  _ObservationProcessPageState createState() => _ObservationProcessPageState();
}

class _ObservationProcessPageState extends State<ObservationProcessPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "ObservationProcess";

  final Map<int, String> correctAnswers = {
    1: "பணியின் போது நடத்தைமுறைகளை கவனிக்க வேண்டும்.",
    2: "பாதுகாப்பான மற்றும் பாதுகாப்பற்ற நடவடிக்கைகளை அடையாளம் காண",
    3: "நிகழ்ந்ததை விருப்பமின்றி பதிவு செய்யவும்.",
    4: "வளர்ச்சியான பின்னூட்டம் வழங்க",
    5: "ஆம், இது போக்குகளை கண்காணிக்க உதவுகிறது."
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "BBS செயல்முறையில் கவனிப்பாளர்கள் என்ன செய்ய வேண்டும்?",
      "options": [
        "பணியின் போது நடத்தைமுறைகளை கவனிக்க வேண்டும்.",
        "பணியாளர்களை தவிர்க்க",
        "மறைவாக புகைப்படம் எடுக்க",
        "மேலாளர்களிடம் மட்டுமே பேசுங்கள்"
      ]
    },
    {
      "question": "நாம் பணியாளர் நடத்தையை ஏன் கவனிக்க வேண்டும்?",
      "options": [
        "நேரத்தை செலவழிக்க",
        "பாதுகாப்பான மற்றும் பாதுகாப்பற்ற நடவடிக்கைகளை அடையாளம் காண",
        "வதந்தி பரப்ப",
        "பழி சுமத்த"
      ]
    },
    {
      "question": "கவனித்த பிறகு என்ன செய்ய வேண்டும்?",
      "options": [
        "அதை மறந்துவிடுங்கள்",
        "நிகழ்ந்ததை விருப்பமின்றி பதிவு செய்யவும்.",
        "உடனே புகார் அளிக்கவும்",
        "பணியாளரை பழி சுமத்தவும்"
      ]
    },
    {
      "question": "கவனிப்புக்குப் பிறகு பின்னூட்டம் ஏன் வழங்கப்படுகிறது?",
      "options": [
        "பணியாளரை திட்ட",
        "வளர்ச்சியான பின்னூட்டம் வழங்க",
        "பணியாளர்களை பயமுறுத்த",
        "சிக்கல்கள் பதிவு செய்ய மட்டும்"
      ]
    },
    {
      "question": "BBS இல் ஆவணப்படுத்துதல் முக்கியமா?",
      "options": [
        "இல்லை, அவசியமில்லை",
        "விபத்து ஏற்பட்டால் மட்டும்",
        "ஆம், இது போக்குகளை கண்காணிக்க உதவுகிறது.",
        "கட்டளையிட்டால் மட்டும்"
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
      isCompleted = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveCompletion(bool value) async {
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
              title: Text("வினா: கவனிப்பு செயல்முறை"),
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
                  child: Text("சமர்ப்பிக்க"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("தயவு செய்து அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
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
          title: Text("வினா முடிவு"),
          content: Text("நீங்கள் ${quizQuestions.length} இல் $score மதிப்பெண் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/employee_engagement_ta');
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
        title: Text("கவனிப்பு செயல்முறை"),
        backgroundColor: Colors.blue[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BBSSafetyEnglish()),
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
                  _buildQA(
                    "👀 நடத்தை கண்காணிப்பு",
                    "பணியாளர்கள் பணியைச் செய்யும் போது அவர்களின் நடத்தைமுறைகளை அவதானிப்பது முக்கியம். இது அவர்கள் செயல்களில் உள்ள பாதுகாப்பு பழக்கங்களைப் புரிந்து கொள்ள உதவுகிறது.",
                    imagePath: 'assets/bbs_observe_1.png',
                  ),
                  _buildQA(
                    "✅ பாதுகாப்பான / பாதுகாப்பற்ற செயலை கண்டறிதல்",
                    "பாதுகாப்பான மற்றும் பாதுகாப்பற்ற நடத்தைமுறைகளை அடையாளம் காண்பது முக்கியம். இது நல்ல பழக்கங்களை ஊக்குவிக்கவும், தவறானவற்றை முன்னே சரிசெய்யவும் உதவுகிறது.",
                  ),
                  _buildQA(
                    "📝 அவதானிப்புகளை பதிவு செய்தல்",
                    "துல்லியமான பதிவு முக்கியமானது. என்ன நடந்தது என்பதை நேர்மையாக பதிவு செய்ய வேண்டும், என்ன நடந்திருக்கலாம் என்று ஊகிக்கக் கூடாது.",
                    imagePath: 'assets/bbs_observe_3.png',
                  ),
                  _buildQA(
                    "💬 பின்னூட்டம் அளித்தல்",
                    "நேர்த்தியான பின்னூட்டம் பணியாளர்களை மேம்படுத்த உதவுகிறது. இது உடனடி, சுருக்கமானதாகவும், செயலை மட்டும் குறிக்க வேண்டும், நபியைக் குறிக்கக் கூடாது.",
                  ),
                  _buildQA(
                    "📊 தரவுத் திரட்டல்",
                    "அவதானிப்பு தரவுகள் பாதுகாப்பு போக்குகளை மற்றும் பயிற்சி தேவைகளை அடையாளம் காண உதவுகிறது. இவை எதிர்கால நடவடிக்கைகள் எடுக்க உதவுகிறது.",
                    imagePath: 'assets/bbs_observe_5.png',
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்ததாக குறியிடு"),
              value: isCompleted,
              onChanged: (value) {
                _saveCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினா மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி")),
          ],
        ),
      ),
    );
  }
}
