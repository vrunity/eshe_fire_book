import 'package:e_she_book/tamil/fire_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireEmergencyPage extends StatefulWidget {
  @override
  _FireEmergencyPageState createState() => _FireEmergencyPageState();
}

class _FireEmergencyPageState extends State<FireEmergencyPage> {
  bool istopic_5_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FireEmergency"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "மற்றவர்களை எச்சரிக்கவும், தீ அலாரத்தை இயக்கவும், அவசர சேவையை அழைக்கவும்",
    2: "லிப்ட் சிக்கி விடலாம், மக்கள் அதில் சிக்கிக்கொள்ளலாம்",
    3: "உடையில் தீ பிடித்தால், நின்று, தரையில் விழுந்து, சுழன்று தீயை அணைக்க வேண்டும்",
    4: "புகையிலிருந்து விலக கீழாக இருங்கள், உதவிக்காக சைகை காட்டுங்கள், மூக்கு/வாயை துணியால் மூடுங்கள்",
    5: "பாதுகாப்பாக வெளியேறவும், பதற்றம் தவிர்க்கவும் உதவுகிறது",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "தீயின் அவசரநிலையிலே முதலில் என்ன செய்ய வேண்டும்?",
      "options": [
        "தீயைக் கவனிக்காமல் வேலை தொடரவும்",
        "மற்றவர்களை எச்சரிக்கவும், தீ அலாரத்தை இயக்கவும், அவசர சேவையை அழைக்கவும்",
        "தீயை விட்டுவிட்டு ஓடிவிடவும்",
        "வேறு ஒருவர் செய்யும்வரை காத்திருக்கவும்"
      ]
    },
    {
      "question": "தீ ஏற்பட்டால் லிப்ட் ஏன் பயன்படுத்தக்கூடாது?",
      "options": [
        "லிப்ட் சிக்கி விடலாம், மக்கள் அதில் சிக்கிக்கொள்ளலாம்",
        "லிப்ட் தீயில் எரியாது",
        "அது விரைவாக வெளியேற உதவும்",
        "மேலே உள்ளவை எதுவும் இல்லை"
      ]
    },
    {
      "question": "'நிறுத்து, விழு, சுழற்று' நுட்பம் என்றால் என்ன?",
      "options": [
        "உடையில் தீ பிடித்தால், நின்று, தரையில் விழுந்து, சுழன்று தீயை அணைக்க வேண்டும்",
        "உடனே நீரில் குதிக்கவும்",
        "சுழன்று ஓடவும்",
        "தீ அணைப்பானை தங்கள்மேல் பயன்படுத்தவும்"
      ]
    },
    {
      "question": "எரியும் கட்டடத்தில் சிக்கிக்கொண்டால் என்ன செய்ய வேண்டும்?",
      "options": [
        "புகையிலிருந்து விலக கீழாக இருங்கள், உதவிக்காக சைகை காட்டுங்கள், மூக்கு/வாயை துணியால் மூடுங்கள்",
        "அனைத்து ஜன்னல்களையும் உடைத்து குதிக்கவும்",
        "தீ அடங்கும் வரை காத்திருக்கவும்",
        "பதற்றத்தில் அலையுங்கள்"
      ]
    },
    {
      "question": "தீ வெளியேறும் திட்டம் ஏன் அவசியம்?",
      "options": [
        "பாதுகாப்பாக வெளியேறவும், பதற்றம் தவிர்க்கவும் உதவுகிறது",
        "வல்லரசு கட்டடங்களுக்கு மட்டும் தேவை",
        "அலுவலகங்களுக்கு மட்டும் தேவை",
        "முக்கியமல்ல"
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
      istopic_5_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_5_Completed = value;
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
              title: Text("Fire Emergency Quiz"),
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
                  Navigator.pushNamed(context, '/handling_extinguishers_ta'); // Navigate to next topic page
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
          ),title: Text("தீ அவசரநிலை நடவடிக்கைகள்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 தீ அவசரநிலையிலே முதன்மை நடவடிக்கை என்ன?", "மற்றவர்களை எச்சரித்து, தீ அலாரம் இயக்கி, அவசர உதவிக்கு அழைக்க வேண்டும்.",imagePath: 'assets/banner_5.1.jpg'),
                  _buildQuestionAnswer("🔥 தீ ஏற்பட்டால் ஏன் லிப்ட் பயன்படுத்தக்கூடாது?", "லிப்ட் செயலிழக்கலாம் மற்றும் உள்ளே சிக்கிக்கொள்ள வாய்ப்பு உள்ளது."),
                  _buildQuestionAnswer("🔥 'நிறுத்து, விழு, சுழற்று' நுட்பம் என்ன?", "உடையணியில் தீ பிடித்தால், நின்று, தரையில் விழுந்து, சுழன்று தீயை அணைக்க வேண்டும்.",imagePath: 'assets/banner_5.2.png'),
                  _buildQuestionAnswer("🔥 எரியும் கட்டடத்தில் சிக்கிக்கொண்டால் என்ன செய்ய வேண்டும்?", "புகையிலிருந்து விலக கீழாக இருங்கள், உதவிக்காக சைகை காட்டுங்கள், மற்றும் மூக்கு/வாயை துணியால் மூடுங்கள்."),
                  _buildQuestionAnswer("🔥 தீ அவசரநிலைக்கு வெளியேறும் திட்டம் ஏன் முக்கியம்?", "பதற்றம் இல்லாமல் பாதுகாப்பாக வெளியேற உதவுகிறது.",imagePath: 'assets/banner_5.3.jpg'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: istopic_5_Completed,
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
