import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/bbs_safety_english.dart';

class CorePrinciplesPageTamil extends StatefulWidget {
  @override
  _CorePrinciplesPageState createState() => _CorePrinciplesPageState();
}

class _CorePrinciplesPageState extends State<CorePrinciplesPageTamil> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "CorePrinciples";

  final Map<int, String> correctAnswers = {
    1: "BBS பாதுகாப்பற்ற நடத்தைமுறைகளை சரிசெய்ய கவனிப்பு மற்றும் பின்னூட்டத்தை சார்ந்துள்ளது.",
    2: "நேர்மறை ஊக்குவிப்பு பாதுகாப்பான நடவடிக்கைகளை ஊக்குவிக்கிறது.",
    3: "BBS என்பது முன்னெச்சரிக்கையாகும், சம்பவங்களுக்கு முன் நடத்தை மீது கவனம் செலுத்துகிறது.",
    4: "அனைத்து நிலை பணியாளர்களும் பாதுகாப்பை மேம்படுத்த இணைக்கப்படுவர்.",
    5: "ஆம், இது பணியாளர்களை பாதுகாப்பை பொறுப்பாக ஏற்க வலுவூட்டுகிறது."
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "BBS பாதுகாப்பை மேம்படுத்த எதனை சார்ந்துள்ளது?",
      "options": [
        "சிறைதண்டனை",
        "விதிகள் மட்டும்",
        "BBS பாதுகாப்பற்ற நடத்தைமுறைகளை சரிசெய்ய கவனிப்பு மற்றும் பின்னூட்டத்தை சார்ந்துள்ளது.",
        "பாதுகாப்பு போஸ்டர்கள்"
      ]
    },
    {
      "question": "BBS இல் நேர்மறை ஊக்குவிப்பு ஏன் முக்கியமானது?",
      "options": [
        "சம்பளத்தை குறைக்க",
        "நேர்மறை ஊக்குவிப்பு பாதுகாப்பான நடவடிக்கைகளை ஊக்குவிக்கிறது.",
        "வருகையை கண்காணிக்க",
        "பணியாளர்களை தண்டிக்க"
      ]
    },
    {
      "question": "BBS என்பது முன்னெச்சரிக்கையா அல்லது பின்விளைவா?",
      "options": [
        "விபத்துக்குப் பிறகு மட்டும்",
        "அவசரநிலைகளில் மட்டும்",
        "BBS என்பது முன்னெச்சரிக்கையாகும், சம்பவங்களுக்கு முன் நடத்தை மீது கவனம் செலுத்துகிறது.",
        "இது ஒரு பின்விளைவு முறை"
      ]
    },
    {
      "question": "BBS செயல்படுத்தலில் யார் ஈடுபடுகின்றனர்?",
      "options": [
        "மேலாளர் மட்டும்",
        "அனைத்து நிலை பணியாளர்களும் பாதுகாப்பை மேம்படுத்த இணைக்கப்படுவர்.",
        "பாதுகாப்பு அலுவலர்கள் மட்டும்",
        "விருந்தினர்கள்"
      ]
    },
    {
      "question": "BBS பாதுகாப்பை சொந்தமாகக் கையாள உதவுகிறதா?",
      "options": [
        "இல்லை, இது பொறுப்பை அகற்றுகிறது",
        "ஆம், இது பணியாளர்களை பாதுகாப்பை பொறுப்பாக ஏற்க வலுவூட்டுகிறது.",
        "மேல் நிலைக்கானது மட்டும்",
        "இடத்தில்ப் பொருந்தும்"
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
              title: Text("வினாடி வினா: BBS முக்கியக் கொள்கைகள்"),
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
                  Navigator.pushNamed(context, '/observation_process_ta');
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
        title: Text("BBS முக்கியக் கொள்கைகள்"),
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
                    "🔍 கவனிப்பு மற்றும் பின்னூட்டம்",
                    "BBS இல், பணியாளர்களின் செயலை கவனித்து உகந்த பின்னூட்டத்தை வழங்குவது முக்கியமானது. இது பாதுகாப்பற்ற பழக்கங்களை அடையாளம் காண உதவுகிறது.",
                    imagePath: 'assets/bbs_core_1.png',
                  ),
                  _buildQA(
                    "🎁 ஊக்குவிப்பு",
                    "BBS பாதுகாப்பான நடைமுறைகளை ஊக்குவிக்க நேர்மறை ஊக்குவிப்பைப் பயன்படுத்துகிறது — இது பணியாளர்களை ஊக்கப்படுத்துகிறது.",
                  ),
                  _buildQA(
                    "🛡️ முன்னெச்சரிக்கையான பாதுகாப்பு",
                    "BBS விபத்துகளுக்குப் பிறகு பதிலளிப்பதைவிட முன்னெச்சரிக்கையாக செயல்படுகிறது. இது பழக்கங்களை முன்பே மாற்ற முயல்கிறது.",
                    imagePath: 'assets/bbs_core_3.png',
                  ),
                  _buildQA(
                    "🤝 பணியாளர் ஈடுபாடு",
                    "BBS இல் மேலாண்மை முதல் தரணி பணியாளர்கள் வரை அனைவரும் பங்கு பெறுகிறார்கள்.",
                  ),
                  _buildQA(
                    "📌 பொறுப்புணர்வு",
                    "ஒவ்வொருவரும் தங்களின் பாதுகாப்பிற்கும் மற்றவர்களின் பாதுகாப்பிற்கும் பொறுப்பானவராக இருக்க BBS ஊக்குவிக்கிறது.",
                    imagePath: 'assets/bbs_core_5.png',
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
