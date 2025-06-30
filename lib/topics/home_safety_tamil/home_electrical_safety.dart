import 'package:e_she_book/topics/kids_safety_tamil/home_safety.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/home_safety_tamil.dart';

class ElectricalSafetyTamilPage extends StatefulWidget {
  @override
  _ElectricalSafetyTamilPageState createState() => _ElectricalSafetyTamilPageState();
}

class _ElectricalSafetyTamilPageState extends State<ElectricalSafetyTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "HomeElectricalSafety";

  final Map<int, String> correctAnswers = {
    1: "மின்சாதனங்களை பயன்படுத்தும் போது ஈரமான கைகள் அல்லது தண்ணீர் தவிர்க்க வேண்டும்.",
    2: "சர்க்யூட் பிரேக்கர் மற்றும் இன்சுலேட்டட் கருவிகளை பயன்படுத்த வேண்டும்.",
    3: "ஓவர்லோடிங் தவிர்க்க வேண்டும் மற்றும் சரியான பியூஸ் ரேட்டிங் பயன்படுத்த வேண்டும்.",
    4: "ஆம், பழைய அல்லது சேதமடைந்த கம்பிகள் தீ அல்லது மின்சட்டு ஏற்படுத்தும்.",
    5: "சாதன நிலையை சரிபார்த்து உற்பத்தியாளர் வழிகாட்டுதலின்படி பயன்படுத்த வேண்டும்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "வீட்டில் மின்சட்டிலிருந்து எப்படி பாதுகாப்பாக இருக்கலாம்?",
      "options": [
        "மின்சாதனங்களை பயன்படுத்தும் போது ஈரமான கைகள் அல்லது தண்ணீர் தவிர்க்க வேண்டும்.",
        "சாக்கெட்டுகளை ஈரமான துணியால் சுத்தம் செய்ய வேண்டும்.",
        "எல்லா சாதனங்களையும் எப்போதும் இணைத்தே வைத்திருக்க வேண்டும்.",
        "நேரடியாக கம்பிகளை தொட வேண்டும்."
      ]
    },
    {
      "question": "அடிப்படை மின்சாதன பாதுகாப்பு நடைமுறைகள் என்ன?",
      "options": [
        "சர்க்யூட் பிரேக்கர் மற்றும் இன்சுலேட்டட் கருவிகளை பயன்படுத்த வேண்டும்.",
        "பல சாதனங்களை ஒரு பிளக்கில் இணைக்க வேண்டும்.",
        "சாக்கெட்டுகளில் இருந்து வினோத ஒளிர்வை பொருட்படுத்த வேண்டாம்.",
        "சாக்கெட்டுகளில் உலோக பொருட்களை போட வேண்டும்."
      ]
    },
    {
      "question": "மின்சாதனங்களில் இருந்து அதிக வெப்பம் அல்லது தீ ஏற்படுவதைக் எப்படி தடுப்பது?",
      "options": [
        "ஓவர்லோடிங் தவிர்க்க வேண்டும் மற்றும் சரியான பியூஸ் ரேட்டிங் பயன்படுத்த வேண்டும்.",
        "எல்லா சாதனங்களையும் ஒரே பிளக்கில் இணைக்க வேண்டும்.",
        "சேதமடைந்த கம்பிகளை சுதந்திரமாக பயன்படுத்த வேண்டும்.",
        "கம்பிகளை துணியால் மூட வேண்டும்."
      ]
    },
    {
      "question": "பழைய அல்லது சேதமடைந்த கம்பிகள் ஆபத்தானதா?",
      "options": [
        "ஆம், பழைய அல்லது சேதமடைந்த கம்பிகள் தீ அல்லது மின்சட்டு ஏற்படுத்தும்.",
        "இல்லை, அவை நன்றாக வேலை செய்யும்.",
        "மிக பழையதாயிருந்தால் மட்டுமே ஆபத்து.",
        "நேரடியாக தொடும்போது மட்டுமே ஆபத்து."
      ]
    },
    {
      "question": "மின்சாதனங்களை பாதுகாப்பாக பயன்படுத்துவது எப்படி?",
      "options": [
        "சாதன நிலையை சரிபார்த்து உற்பத்தியாளர் வழிகாட்டுதலின்படி பயன்படுத்த வேண்டும்.",
        "பயனர் கையேடுகளை தவிர்க்க வேண்டும்.",
        "எப்போதும் சாதனங்களை இயங்கவைக்க வேண்டும்.",
        "பாகங்களை யாதாகமாய் மாற்றலாம்."
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
              title: Text("வினா-விலுக்கு: மின்சாதன பாதுகாப்பு"),
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
                        SnackBar(content: Text("தயவுசெய்து அனைத்து வினாக்களுக்கும் பதில் அளிக்கவும்")),
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
      if (correctAnswers[key] == value) score++;
    });
    _saveQuizScore(score);
    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("வினாத்தாள் முடிவு"),
          content: Text("நீங்கள் ${quizQuestions.length} இலிருந்து $score மதிப்பெண்கள் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/kids_safety_home_ta');
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
        title: Text("🔌 மின்சாதன பாதுகாப்பு"),
        backgroundColor: Colors.red[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeSafetyTamilPage()),
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
                  _buildQA("⚡ மின்சாதன பாதுகாப்பு என்றால் என்ன?", "மின் உபகரணங்களை பாதுகாப்பாக பயன்படுத்தி மின்சட்டு, தீ மற்றும் சேதங்களைத் தவிர்ப்பது.", imagePath: 'assets/home_4.0.png'),
                  _buildQA("🔌 மின்சட்டிலிருந்து பாதுகாப்பு", "ஈரமான கைகளால் சாதனங்களைப் பயன்படுத்த வேண்டாம், சேதமடைந்த கம்பிகளை மாற்ற வேண்டும்."),
                  _buildQA("🧰 பாதுகாப்பு குறிப்பு", "சர்க்யூட் பிரேக்கர், இன்சுலேட்டட் கருவிகள் மற்றும் சரியான பியூஸ் பயன்படுத்த வேண்டும்.", imagePath: 'assets/home_4.1.png'),
                  _buildQA("⚠️ பொதுவான அபாயங்கள்", "ஓவர்லோடிங் பிளக்குகள், வெளிப்படையான கம்பிகள் மற்றும் பழைய சாதனங்கள்."),
                  _buildQA("📋 சாதன பராமரிப்பு", "பயனர் கையேட்டின்படி செயல்படவும், தரமான பிளக்குகள் பயன்படுத்தவும்.", imagePath: 'assets/home_4.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("பாடத்தை முடித்துவிட்டேன்"),
              value: isCompleted,
              onChanged: (value) => _saveCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி வினாத்தாள் மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி")),
          ],
        ),
      ),
    );
  }
}
