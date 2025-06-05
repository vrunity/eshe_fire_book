import 'package:e_she_book/tamil/bbs_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/bbs_safety_english.dart';

class IncidentPreventionPageTamil extends StatefulWidget {
  @override
  _IncidentPreventionPageState createState() => _IncidentPreventionPageState();
}

class _IncidentPreventionPageState extends State<IncidentPreventionPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "IncidentPrevention";

  final Map<int, String> correctAnswers = {
    1: "பாதுகாப்பற்ற நடத்தைகளை அடையாளம் கண்டு திருத்துவதன் மூலம்.",
    2: "காயம் அல்லது சேதம் ஏற்படும் வாய்ப்பை குறைக்க.",
    3: "அவை அவமதிக்கப்படும்போது விபத்துகள் ஏற்பட வாய்ப்பு உள்ளது.",
    4: "பின்னூட்டம் மற்றும் முறைமையான அவதானிப்பு பயன்படுத்தவும்.",
    5: "ஆம், தடுப்பது என்பது பகிர்ந்த பொறுப்பு."
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "BBS எப்படி விபத்துகளைத் தடுக்கிறது?",
      "options": [
        "தயாரிப்பை அதிகரிப்பதன் மூலம்",
        "அதிக ஊழியர்களை நியமிப்பதன் மூலம்",
        "பாதுகாப்பற்ற நடத்தைகளை அடையாளம் கண்டு திருத்துவதன் மூலம்.",
        "புதிய கருவிகளை வாங்குவதன் மூலம்"
      ]
    },
    {
      "question": "விபத்துகளை ஏன் தடுப்பது அவசியம்?",
      "options": [
        "காயம் அல்லது சேதம் ஏற்படும் வாய்ப்பை குறைக்க.",
        "மேம்படுத்தல்களுக்கு உதவ",
        "தணிக்கையாளர்களை ஈர்க்க",
        "மீட்டிங்குகளை குறைக்க"
      ]
    },
    {
      "question": "பாதுகாப்பற்ற செயற்பாடுகளின் அபாயம் என்ன?",
      "options": [
        "கட்டாயமில்லை",
        "அவை வேகத்தை அதிகரிக்கின்றன",
        "அவை அவமதிக்கப்படும்போது விபத்துகள் ஏற்பட வாய்ப்பு உள்ளது.",
        "அவை நேரத்தை மிச்சப்படுத்தும்"
      ]
    },
    {
      "question": "பாதுகாப்பற்ற நடத்தை குறைய என்ன செய்யலாம்?",
      "options": [
        "அதைப் புறக்கணிக்கவும்",
        "பின்னூட்டம் மற்றும் முறைமையான அவதானிப்பு பயன்படுத்தவும்.",
        "அவர்களை கூச்சலிடவும்",
        "ஷிப்ட் மாற்றவும்"
      ]
    },
    {
      "question": "விபத்து தடுப்பு அனைவரின் பொறுப்பா?",
      "options": [
        "இல்லை, பாதுகாப்பு அலுவலர்கள் மட்டும்",
        "ஆம், தடுப்பது என்பது பகிர்ந்த பொறுப்பு.",
        "மேலாளர்கள் மட்டுமே கவலையுடன் இருப்பார்கள்",
        "தேர்வுக்குரியது"
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
    await prefs.setBool('Completed_$topicName', true);
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
      isCompleted = true;
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
              title: Text("வினா: விபத்து தடுப்பு"),
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
              child: Text("முடிக்கவும்"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => BbsSafetyTamil()),
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
        title: Text("விபத்து தடுப்பு"),
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
                    "🔍 பாதுகாப்பற்ற செயல் கண்டறிதல்",
                    "BBS என்பது வேலைசெய்யும் இடங்களில் பாதுகாப்பற்ற செயல்களை கண்டறிதலோடு துவங்குகிறது. இது PPE தவிர்த்தல், கவனக் குறைவு போன்றவற்றை உள்ளடக்கலாம். இதை ஆரம்பத்திலேயே கண்டறிந்து சரி செய்தால் பெரிய பிரச்னையைத் தவிர்க்கலாம்.",
                    imagePath: 'assets/bbs_incident_1.png',
                  ),
                  _buildQA(
                    "🎯 தடுப்பில் கவனம் செலுத்தல்",
                    "BBS யின் மையக்கருத்து — விபத்து நடக்காமல் தடுப்பது. விபத்துக்குப் பிறகு பதிலளிக்காமல், பணியாளர்கள் அபாயங்களை முன்னே கணித்து தடுக்கும் பழக்கத்திற்கு பயிற்சி பெறுகிறார்கள்.",
                  ),
                  _buildQA(
                    "🧠 பின்னூட்டம் வழங்குதல்",
                    "சமயோசிதமான மற்றும் கட்டமைக்கப்பட்ட பின்னூட்டம் பாதுகாப்பான நடத்தை வளர்க்க உதவுகிறது. இது சாதாரண உரையாடலாக இருந்தாலும் கூட, நல்ல பழக்கங்கள் உருவாக்க உதவும்.",
                    imagePath: 'assets/bbs_incident_3.png',
                  ),
                  _buildQA(
                    "👀 அவதானிப்பு ஊக்கம்",
                    "ஒவ்வொரு பணியாளரும் ஒரு பாதுகாப்பு பார்வையாளர் ஆகலாம். BBS பணியாளர்கள் ஒருவருக்கொருவர் கவனிக்கக்கூடிய கலாசாரத்தை ஊக்குவிக்கிறது.",
                  ),
                  _buildQA(
                    "🤝 குழு முயற்சி",
                    "விபத்து தடுப்பு ஒருவருடைய பொறுப்பு மட்டுமல்ல. மேற்பார்வையாளர்கள், பணியாளர்கள், மேலாளர் என அனைவரும் சேர்ந்து செயல்பட வேண்டும்.",
                    imagePath: 'assets/bbs_incident_5.png',
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
