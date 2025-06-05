import 'package:e_she_book/english/ppe_english.dart';
import 'package:e_she_book/tamil/ppe_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionToPPEPage extends StatefulWidget {
  @override
  _IntroductionToPPEPageState createState() => _IntroductionToPPEPageState();
}

class _IntroductionToPPEPageState extends State<IntroductionToPPEPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "IntroductionToPPE";

  final Map<int, String> correctAnswers = {
    1: "பணியாளர்களை காயம் மற்றும் நோயிலிருந்து பாதுகாக்க",
    2: "தனிப்பட்ட பாதுகாப்பு உபகரணம்",
    3: "கண் பாதுகாப்பு, கை தடுப்புகள், தலைக்கவசங்கள், பாதுகாப்பு காலணிகள்",
    4: "சரியான முறையில் மற்றும் தொடர்ந்து பயன்படுத்த வேண்டும்",
    5: "பாதுகாப்பு உணர்வை வளர்க்க",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "PPE இன் முக்கிய நோக்கம் என்ன?",
      "options": [
        "ஆடைகளை அலங்கரிக்க",
        "பணியாளர்களை காயம் மற்றும் நோயிலிருந்து பாதுகாக்க",
        "பணியாளர்களை அழகாக காட்ட",
        "சாதாரண ஆடைகள் தவிர்க்க"
      ]
    },
    {
      "question": "PPE என்பதன் விரிவான பெயர் என்ன?",
      "options": [
        "தொழில்முறை பாதுகாப்பு உபகரணம்",
        "தனிப்பட்ட பாதுகாப்பு உபகரணம்",
        "தனிப்பட்ட பாதுகாப்பு அடிப்படை",
        "பொது பாதுகாப்பு சூழல்"
      ]
    },
    {
      "question": "கீழ்காணும் எது PPE வகை ஆகும்?",
      "options": [
        "ஸ்மார்ட் வாட்ச்",
        "தோல் பெல்ட்",
        "கண் பாதுகாப்பு, கை தடுப்புகள், தலைக்கவசங்கள், பாதுகாப்பு காலணிகள்",
        "அடையாள அட்டை"
      ]
    },
    {
      "question": "PPE பயிற்சி ஏன் அவசியம்?",
      "options": [
        "சரியான முறையில் மற்றும் தொடர்ந்து பயன்படுத்த வேண்டும்",
        "இது விதி என்பதால்",
        "ஆடைகளின் செலவை குறைக்க",
        "அழகு பார்ப்பதற்காக"
      ]
    },
    {
      "question": "பாதுகாப்பு பண்பாட்டை ஏன் ஊக்குவிக்க வேண்டும்?",
      "options": [
        "விற்பனையை அதிகரிக்க",
        "அதிகமாக கூட்டங்களை நடத்த",
        "பாதுகாப்பு உணர்வை வளர்க்க",
        "யூனிஃபாரம் தவிர்க்க"
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
              title: Text("PPE அறிமுகம் வினாடி வினா"),
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
                        SnackBar(content: Text("அனைத்து கேள்விகளுக்கும் பதிலளிக்கவும்")),
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
          content: Text("நீங்கள் ${quizQuestions.length} இல் $score மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/head_protection_en'); // Navigate to next topic page
                },
              ),
            TextButton(
              child: Text("மீண்டும் முயற்சி"),
              onPressed: () {
                Navigator.pop(context);
                _showQuizDialog();
              },
            )
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
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              ),
            if (imagePath != null)
              SizedBox(height: 12),
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
                MaterialPageRoute(builder: (_) => ppe_tamil()),
              );
            },
          ),
          title: Text("PPE அறிமுகம்")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("👷 PPE என்பதன் அர்த்தம் என்ன?", "PPE என்பது தனிப்பட்ட பாதுகாப்பு உபகரணமாகும். இது கைகளுக்கு கையுறைகள், கண்களுக்கு கண்ணாடிகள், தலையிற்குத் தலைக்கவசங்கள் போன்றவை சேர்க்கப்படும்.", imagePath: 'assets/ppe_1.0.png'),
                  _buildQuestionAnswer("👷 PPE ஏன் அவசியம்?", "PPE தொழிலாளர்களை அபாயங்களிலிருந்து பாதுகாக்கும் முக்கியமான பாதுகாப்பு ஆயுதமாகும்."),
                  _buildQuestionAnswer("👷 யார் PPE பயன்படுத்த வேண்டும்?", "அபாயமான சூழலில் பணிபுரியும் ஒவ்வொரு பணியாளரும் PPE பயன்படுத்த வேண்டும்.", imagePath: 'assets/ppe_1.1.png'),
                  _buildQuestionAnswer("👷 PPE மட்டும் பாதுகாப்பை உறுதி செய்யுமா?", "இல்லை. PPE என்பது இறுதி பாதுகாப்பு நிலையாகும். போதுமான பயிற்சி, கட்டுப்பாடுகள் மற்றும் செயல்முறைகள் அவசியம்."),
                  _buildQuestionAnswer("👷 PPE வகைகள் என்ன?", "தலை பாதுகாப்பு, கண் மற்றும் முக பாதுகாப்பு, காது பாதுகாப்பு, மூச்சுத் திணறல் பாதுகாப்பு, கை பாதுகாப்பு, கால் பாதுகாப்பு மற்றும் உடல் பாதுகாப்பு.", imagePath: 'assets/ppe_1.2.png'),
                  _buildQuestionAnswer("👷 சரியான PPE யை எப்படி தேர்வு செய்வது?", "சூழலில் உள்ள அபாயங்களைப் பொருத்து சரியான அளவு மற்றும் வசதியுள்ள PPE தேர்வு செய்ய வேண்டும்."),
                  _buildQuestionAnswer("👷 வேலை வழங்குநரின் பொறுப்பு என்ன?", "வேலை வழங்குநர்கள் பாதுகாப்பான PPE வழங்க வேண்டும் மற்றும் அதன் பராமரிப்பு மற்றும் பயிற்சியை உறுதி செய்ய வேண்டும்."),
                  _buildQuestionAnswer("👷 பணியாளர்களின் பொறுப்புகள் என்ன?", "PPE-ஐ சரியான முறையில் பயன்படுத்தி பராமரிக்க வேண்டும் மற்றும் கோளாறுகள் இருந்தால் மேலாளரிடம் தெரிவிக்க வேண்டும்."),
                  _buildQuestionAnswer("👷 PPE பகிர்ந்துகொள்ளலாமா?", "மிகவும் தவிர்க்க வேண்டும். பகிர்ந்தால் முறையாக சுத்தம் செய்ய வேண்டும்.", imagePath: 'assets/ppe_1.3.png'),
                  _buildQuestionAnswer("👷 PPE எப்பொழுது பரிசோதிக்க வேண்டும்?", "ஒவ்வொரு பயன்பாட்டுக்கும் முன் மற்றும் பராமரிப்பு திட்டத்தின் படி பரிசோதிக்க வேண்டும்."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("மீண்டும் வினாடி வினா"),
              )
          ],
        ),
      ),
    );
  }
}
