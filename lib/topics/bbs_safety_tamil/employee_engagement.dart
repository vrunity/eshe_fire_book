import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/bbs_safety_english.dart';

class EmployeeEngagementPageTamil extends StatefulWidget {
  @override
  _EmployeeEngagementPageState createState() => _EmployeeEngagementPageState();
}

class _EmployeeEngagementPageState extends State<EmployeeEngagementPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EmployeeEngagement";

  final Map<int, String> correctAnswers = {
    1: "பாதுகாப்பு உரையாடல்கள் மற்றும் கவனிப்புகளில் அவர்களை ஈடுபடுத்தவும்.",
    2: "அது சொந்த பொறுப்பையும் பொறுப்புணர்வையும் உருவாக்குகிறது.",
    3: "பாதுகாப்பான நடத்தைக்கு பாராட்டு தெரிவித்து ஊக்கமளிக்கவும்.",
    4: "இணைய பணியாளர் பங்கேற்பும் வழிகாட்டலும்.",
    5: "ஆம், பங்கேற்பு பாதுகாப்பு முடிவுகளை மேம்படுத்துகிறது."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "BBS இல் பணியாளர்களை எப்படிச் சேர்த்துக் கொள்ளலாம்?",
      "options": [
        "அவர்களை தவிர்க்கவும்",
        "பிழைகளை மட்டும் தெரிவிக்கவும்",
        "பாதுகாப்பு உரையாடல்கள் மற்றும் கவனிப்புகளில் அவர்களை ஈடுபடுத்தவும்.",
        "அதிக வேலை ஒப்படைக்கவும்"
      ]
    },
    {
      "question": "ஈடுபாடேன் முக்கியம்?",
      "options": [
        "அது பயத்தை உருவாக்குகிறது",
        "அது சொந்த பொறுப்பையும் பொறுப்புணர்வையும் உருவாக்குகிறது.",
        "பணிகளை குறைக்கிறது",
        "அது குழப்பத்தை அதிகரிக்கிறது"
      ]
    },
    {
      "question": "நல்ல நடத்தைக்கு ஊக்கம் அளிப்பது எப்படி?",
      "options": [
        "அதைப் புறக்கணிக்கவும்",
        "பாதுகாப்பான நடத்தைக்கு பாராட்டு தெரிவித்து ஊக்கமளிக்கவும்.",
        "அடிக்கடி தண்டிக்கவும்",
        "பின்னூட்டம் தவிர்க்கவும்"
      ]
    },
    {
      "question": "பணியாளர் பங்கேற்பை என்ன ஊக்குவிக்கிறது?",
      "options": [
        "தனிமைப்படுத்தல்",
        "கடுமையான விதிகள் மட்டும்",
        "இணைய பணியாளர் பங்கேற்பும் வழிகாட்டலும்.",
        "தனித்தனி வேலை"
      ]
    },
    {
      "question": "ஈடுபாடு பாதுகாப்பை மேம்படுத்துமா?",
      "options": [
        "ஆம், பங்கேற்பு பாதுகாப்பு முடிவுகளை மேம்படுத்துகிறது.",
        "இல்லை, இது நேரத்தை வீணாக்குகிறது",
        "சில நேரங்களில் மட்டும்",
        "அப்படி ஒன்றுமில்லை"
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
              title: Text("வினாடி வினா: பணியாளர் ஈடுபாடு"),
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
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3)
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/incident_prevention_ta');
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
        title: Text("பணியாளர் ஈடுபாடு"),
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
                    "👥 அனைவரையும் சேர்த்துக்கொள்ளுங்கள்",
                    "நடத்தை அடிப்படையிலான பாதுகாப்பு (BBS) முறையில், மேலாளர் முதல் தரணி வரை உள்ள அனைவரும் பாதுகாப்பு உரையாடல்களில் மற்றும் முடிவெடுப்புகளில் ஈடுபட வேண்டும். இது நம்பிக்கையையும் பொறுப்புணர்வையும் அதிகரிக்கிறது.",
                    imagePath: 'assets/bbs_engage_1.0.png',
                  ),
                  _buildQA(
                    "💡 பங்கேற்பை ஊக்குவிக்கவும்",
                    "பணியாளர்கள் பணிச்சுற்றுகளை கவனிக்கவும், அருகிலுள்ள விபத்துகளைத் தெரிவிக்கவும், மேம்பாடுகளை பரிந்துரைக்கவும் அனுமதிக்கவும். இது அவர்களுக்கு அதிகாரம் அளிக்கிறது மற்றும் பகிர்ந்த பொறுப்பை உருவாக்குகிறது.",
                  ),
                  _buildQA(
                    "👏 முயற்சிகளை பாராட்டுங்கள்",
                    "பாதுகாப்பான நடத்தைக்கு பாராட்டும் மூலம் நற்பண்புகளை வலுப்படுத்தலாம். ‘நன்றி’ சொல்லுதல் அல்லது சிறிய பரிசு கூட பெரும் தாக்கத்தை ஏற்படுத்தும்.",
                    imagePath: 'assets/bbs_engage_3.png',
                  ),
                  _buildQA(
                    "🔄 சக பணியாளர் கற்றல்",
                    "பணியாளர்கள் அனுபவங்களை பகிர, ஒருவருக்கொருவர் வழிகாட்ட, மற்றும் சம்பவங்களை குழுவாக பகுப்பாய்வு செய்ய அனுமதிக்கவும். இதன்மூலம் மேல் நிலைத் தண்டனையைவிட நெருக்கமான பங்கேற்பு ஏற்படுகிறது.",
                  ),
                  _buildQA(
                    "📣 ஊக்கம் அதிகரிக்கவும்",
                    "அவர்கள் கருத்துகள் மதிக்கப்படுவதையும் நடைமுறைப்படுத்தப்படுவதையும் பணியாளர்கள் உணரும்போது, அவர்களின் மனநிலை உயர்கிறது. இது பாதுகாப்பான நடத்தை மற்றும் நல்ல முடிவுகளுக்கான பாதையை உருவாக்குகிறது.",
                    imagePath: 'assets/bbs_engage_5.png',
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
