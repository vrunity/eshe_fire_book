import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/home_safety_tamil.dart';

class KitchenSafetyTamilPage extends StatefulWidget {
  @override
  _KitchenSafetyTamilPageState createState() => _KitchenSafetyTamilPageState();
}

class _KitchenSafetyTamilPageState extends State<KitchenSafetyTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "KitchenSafety";

  final Map<int, String> correctAnswers = {
    1: "சமையலின் போது கண்காணிக்காமல் விடக்கூடாது.",
    2: "தீ பற்றக்கூடிய பொருட்களை அடுப்பிலிருந்து விலக்கி வைக்கவும்.",
    3: "பானை கைப்பிடிகளை உள்புறமாக திருப்பி வைக்கவும்.",
    4: "சமையலறை வெளியேற்றங்களில் தீ அணைப்பான் பொருத்தவும்.",
    5: "மின்சாதனங்களை பயன்படுத்தும் போது உலர்ந்த கை மற்றும் உலர்ந்த உபகரணங்களை பயன்படுத்தவும்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "அடுப்பைப் பயன்படுத்தும்போது அடிப்படை பாதுகாப்பு என்ன?",
      "options": [
        "விளக்குகள் பயன்படுத்தவும்.",
        "அடுப்பு கதவைத் திறந்தே வைக்கவும்.",
        "சமையலின் போது கண்காணிக்காமல் விடக்கூடாது.",
        "பிளாஸ்டிக் ஸ்பூன் பயன்படுத்தவும்."
      ]
    },
    {
      "question": "அடுப்பிற்கு அருகில் தீ அபாயத்தை குறைப்பது எப்படி?",
      "options": [
        "தீ பற்றக்கூடிய பொருட்களை அடுப்பிலிருந்து விலக்கி வைக்கவும்.",
        "துணிகளை வைத்து மூடவும்.",
        "படுக்கையறை திரைகளை அடுப்பில் கட்டவும்.",
        "மசாலா பாட்டில்கள் அடுப்பில் வைக்கவும்."
      ]
    },
    {
      "question": "பானைகளை எவ்வாறு பாதுகாப்பாக கையாளலாம்?",
      "options": [
        "பானை கைப்பிடிகளை உள்புறமாக திருப்பி வைக்கவும்.",
        "பெரிய பானைகள் மட்டும் பயன்படுத்தவும்.",
        "முழுவதும் நிரப்பவும்.",
        "எப்போதும் அதிக சூட்டில் சமைக்கவும்."
      ]
    },
    {
      "question": "முக்கியமான பாதுகாப்பு நடவடிக்கை என்ன?",
      "options": [
        "சமையலறை வெளியேற்றங்களில் தீ அணைப்பான் பொருத்தவும்.",
        "படுக்கையறையில் அணைப்பான் வைக்கவும்.",
        "அணைப்பானை மரச்சாளரத்தில் மறைக்கவும்.",
        "அணைப்பானை வைத்திருப்பதே தேவையில்லை."
      ]
    },
    {
      "question": "மின்சாதனங்களை பயன்படுத்தும் போது பாதுகாப்பு எதிலிருந்து?",
      "options": [
        "மின்சாதனங்களை பயன்படுத்தும் போது உலர்ந்த கை மற்றும் உலர்ந்த உபகரணங்களை பயன்படுத்தவும்.",
        "சாக்கெட்டுகளை தண்ணீர் ஊற்றி சுத்தம் செய்யவும்.",
        "நூல் கம்பிகளை இழுத்து உதிர்த்தெடுக்கவும்.",
        "படுப்பதற்கான நனவான இடத்தில் வைத்திருக்கவும்."
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
              title: Text("வினா: சமையலறை பாதுகாப்பு"),
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
          title: Text("வினா முடிவு"),
          content: Text("நீங்கள் ${quizQuestions.length} வினாக்களில் $score மதிப்பெண் பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/lpg_safety_ta');
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
        title: Text("🍳 சமையலறை பாதுகாப்பு"),
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQA("🔥 அடுப்பு பாதுகாப்பு", "சமையலின் போது கண்காணிக்காமல் விடக்கூடாது.", imagePath: 'assets/kitchen_1.0.png'),
                  _buildQA("🧯 தீ தடுப்பு", "தீ பற்றக்கூடிய பொருட்களை அடுப்பிலிருந்து விலக்கி வைக்கவும்."),
                  _buildQA("🍲 பானைகள் கையாளுதல்", "பானை கைப்பிடிகளை உள்புறமாக திருப்பி வைக்கவும்.", imagePath: 'assets/kitchen_1.1.png'),
                  _buildQA("🚨 முன்னெச்சரிக்கை", "சமையலறை வெளியேற்றங்களில் தீ அணைப்பான் பொருத்தவும்."),
                  _buildQA("⚡ மின்சாதனங்கள்", "மின்சாதனங்களை பயன்படுத்தும் போது உலர்ந்த கை மற்றும் உலர்ந்த உபகரணங்களை பயன்படுத்தவும்.", imagePath: 'assets/kitchen_1.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடித்ததாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) => _saveCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("மீண்டும் முயற்சி")),
          ],
        ),
      ),
    );
  }
}
