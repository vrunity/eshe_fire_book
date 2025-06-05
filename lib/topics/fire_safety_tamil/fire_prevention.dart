import 'package:e_she_book/tamil/fire_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirePreventionPage extends StatefulWidget {
  @override
  _FirePreventionPageState createState() => _FirePreventionPageState();
}

class _FirePreventionPageState extends State<FirePreventionPage> {
  bool istopic_4_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FirePrevention"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "வழக்கமான ஆய்வுகள், எரிபொருட்கள் சரியான முறையில் சேமித்தல் மற்றும் பாதுகாப்பு பயிற்சி",
    2: "மின்சார ஸ்விட்ச்களை இயக்காதீர்கள்; ஜன்னல்களைத் திறந்து உடனே வெளியேறவும்",
    3: "மாதந்தோறும் சோதனை செய்து ஆண்டுதோறும் பராமரிக்க வேண்டும்",
    4: "கழிவுகள் மற்றும் குழப்பங்களை அகற்றுவது தீ அபாயங்களைத் தவிர்க்க உதவுகிறது",
    5: "அடுப்புகளுக்கு அருகில் எரிபொருட்கள் வைக்க வேண்டாம், சமையலையும் கண்காணிக்காமல் விடக்கூடாது",
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "தொழிற்சாலைகளில் தீயை எவ்வாறு தடுப்பது?",
      "options": [
        "வழக்கமான ஆய்வுகள், எரிபொருட்கள் சரியான முறையில் சேமித்தல் மற்றும் பாதுகாப்பு பயிற்சி",
        "எரிபொருட்கள் எங்கு வேண்டுமானாலும் வைத்தல்",
        "தீ பயிற்சிகளை புறக்கணித்தல்",
        "மேலே எதுவும் இல்லை"
      ]
    },
    {
      "question": "மூடிய அறையில் எரிவாயு வாசனை வந்தால் என்ன செய்ய வேண்டும்?",
      "options": [
        "ஒளி காண எல்லா விளக்குகளையும் ஏற்கவும்",
        "மின்சார ஸ்விட்ச்களை இயக்காதீர்கள்; ஜன்னல்களைத் திறந்து உடனே வெளியேறவும்",
        "அனைத்து ஜன்னல்களையும் மூடிவிட்டு காத்திருங்கள்",
        "அது தானாக மாறும் என்பதால் புறக்கணிக்கவும்"
      ]
    },
    {
      "question": "தீ அலாரங்களை எவ்வளவு அடிக்கடி பரிசோதிக்க வேண்டும்?",
      "options": [
        "ஒவ்வொரு 5 ஆண்டுகளுக்கும் ஒருமுறை",
        "மாதந்தோறும் சோதனை செய்து ஆண்டுதோறும் பராமரிக்க வேண்டும்",
        "அவை சத்தமிடும் போதே பரிசோதிக்கலாம்",
        "தீ விபத்து வந்த பின் மட்டுமே"
      ]
    },
    {
      "question": "தீ தடுப்பில் வீடு சுத்தமாக வைத்திருப்பது ஏன் முக்கியம்?",
      "options": [
        "கழிவுகள் மற்றும் குழப்பங்களை அகற்றுவது தீ அபாயங்களைத் தவிர்க்க உதவுகிறது",
        "வீடு அழகாக இருப்பதற்காக மட்டும்",
        "அவசர நடவடிக்கையை தாமதப்படுத்தும்",
        "தீ பரவ உதவும்"
      ]
    },
    {
      "question": "சமையலறையில் எடுக்க வேண்டிய பாதுகாப்பு நடவடிக்கைகள் என்ன?",
      "options": [
        "அடுப்புகளுக்கு அருகில் எரிபொருட்கள் வைக்க வேண்டாம், சமையலையும் கண்காணிக்காமல் விடக்கூடாது",
        "தீயை எதிர்கொள்ள பிளாஸ்டிக் பாத்திரங்களை பயன்படுத்தவும்",
        "உயர் வெப்பத்திற்கு அருகில் வாயு சிலிண்டர்கள் வைக்கவும்",
        "தீ பாதுகாப்பு முறைகளை புறக்கணிக்கவும்"
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
      istopic_4_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_4_Completed = value;
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
              title: Text("Fire Prevention Quiz"),
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
          content: Text("You scored $score out of ${quizQuestions.length}."),
          actions: [
            TextButton(
              child: Text("சரி"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score > 3) // ✅ Show Next Topic only if score > 3
              TextButton(
                child: Text("அடுத்த தலைப்பு"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/fire_emergency_ta'); // Navigate to next topic page
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
          ),title: Text("தீ தடுப்பு நுட்பங்கள்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 தொழிற்சாலைகளில் தீயை எவ்வாறு தடுப்பது?", "வழக்கமான ஆய்வுகள், எரிபொருட்கள் சரியான முறையில் சேமித்தல் மற்றும் பாதுகாப்பு பயிற்சி.",imagePath: 'assets/banner_4.1.jpeg'),
                  _buildQuestionAnswer("🔥 அடைக்கப்பட்ட அறையில் எரிவாயு வாசனை வந்தால் என்ன செய்ய வேண்டும்?", "மின்சார ஸ்விட்ச்களை இயக்காமல், ஜன்னல்கள் திறந்து உடனே வெளியேற வேண்டும்."),
                  _buildQuestionAnswer("🔥 தீ அலாரங்களை எவ்வளவு அடிக்கடி பரிசோதிக்க வேண்டும்?", "தீ அலாரங்களை மாதந்தோறும் சோதனை செய்து, ஆண்டுதோறும் பராமரிக்க வேண்டும்.",imagePath: 'assets/banner_4.2.jpg'),
                  _buildQuestionAnswer("🔥 வீடுகளில் சுத்தம் வைத்திருக்க முக்கியத்துவம் என்ன?", "கழிவுகள் மற்றும் குழப்பங்களை அகற்றுவது தீ அபாயங்களைத் தவிர்க்க உதவுகிறது."),
                  _buildQuestionAnswer("🔥 சமையலறையில் எடுக்கவேண்டிய பாதுகாப்பு நடவடிக்கைகள் என்ன?", "எரிபொருட்களை அடுப்புகளுக்கு அருகில் வைக்கக்கூடாது மற்றும் சமையலையும் கண்காணிக்காமல் விடக்கூடாது.",imagePath: 'assets/banner_4.3.jpg'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: istopic_4_Completed,
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
