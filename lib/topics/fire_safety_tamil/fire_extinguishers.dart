import 'package:e_she_book/tamil/fire_safety_tamil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireExtinguishersPage extends StatefulWidget {
  @override
  _FireExtinguishersPageState createState() => _FireExtinguishersPageState();
}

class _FireExtinguishersPageState extends State<FireExtinguishersPage> {
  bool istopic_3_Completed = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FireExtinguishers"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "தண்ணீர், நுரை, உலர் தூள், கார்பன் டையாக்சைடு (CO₂), மற்றும் ஈர வேதிப்பொருள்",
    2: "CO₂ அல்லது உலர் தூள் அணைப்பான்",
    3: "நுரை அல்லது உலர் தூள் அணைப்பான்",
    4: "தண்ணீர் எரியும் எண்ணெயை பரப்பி தீயை மோசமாக்கும்",
    5: "பின்-ஐ இழுக்கவும், அடிப்பகுதியை நோக்கி குறிக்கவும், கைப்பிடியை அழுத்தவும், இடம் மாற்றிச் சுழற்றவும்",
  };


  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "தீ அணைப்பான்கள் எவ்வளவாக வகைப்படுத்தப்பட்டுள்ளன?",
      "options": [
        "தண்ணீர், நுரை, உலர் தூள், கார்பன் டையாக்சைடு (CO₂), மற்றும் ஈர வேதிப்பொருள்",
        "தண்ணீர் மற்றும் நுரை மட்டும்",
        "கார்பன் டையாக்சைடு மட்டும்",
        "மேலே எதுவும் இல்லை"
      ]
    },
    {
      "question": "மின்சார தீயில் எந்த அணைப்பான் பயன்படுத்த வேண்டும்?",
      "options": [
        "தண்ணீர் அணைப்பான்",
        "CO₂ அல்லது உலர் தூள் அணைப்பான்",
        "நுரை அணைப்பான்",
        "ஈர வேதிப்பொருள் அணைப்பான்"
      ]
    },
    {
      "question": "எரிபொருள் திரவ தீயில் எந்த அணைப்பான் பயன்படுத்தப்படும்?",
      "options": [
        "தண்ணீர் அணைப்பான்",
        "நுரை அல்லது உலர் தூள் அணைப்பான்",
        "CO₂ அணைப்பான்",
        "மேலே எதுவும் இல்லை"
      ]
    },
    {
      "question": "எண்ணெய் தீயில் தண்ணீர் பயன்படுத்துவது ஏன் ஆபத்தானது?",
      "options": [
        "தண்ணீர் எண்ணெயை வேகமாக குளிர்விக்கிறது",
        "தண்ணீர் எரியும் எண்ணெயை பரப்பி தீயை மோசமாக்கும்",
        "தண்ணீர் பாதுகாப்பாக தீயை அணைக்கும்",
        "மேலே எதுவும் இல்லை"
      ]
    },
    {
      "question": "PASS முறையின் முழு விளக்கம் என்ன?",
      "options": [
        "பின்-ஐ இழுக்கவும், அடிப்பகுதியை நோக்கி குறிக்கவும், கைப்பிடியை அழுத்தவும், இடம் மாற்றிச் சுழற்றவும்",
        "பினை தள்ளவும், மேல்பகுதியை நோக்கி குறிக்கவும், மேலே கீழே தூவவும்",
        "பினை இழுக்கவும், தீயை நோக்கி குறிக்கவும், தொடர்ந்து தெளிக்கவும்",
        "மேலே எதுவும் இல்லை"
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
      istopic_3_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_3_Completed = value;
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
              title: Text("Fire Extinguishers Quiz"),
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
                  Navigator.pushNamed(context, '/fire_prevention_ta'); // Navigate to next topic page
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
          ),title: Text("தீ அணைப்பான்களின் வகைகள் மற்றும் பயன்பாடுகள்"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🔥 தீ அணைப்பான் வகைகள் என்னென்ன?", "தண்ணீர், நுரை, உலர் தூள், கார்பன் டையாக்சைடு (CO₂), மற்றும் ஈர வேதிப்பொருள்.",imagePath: 'assets/banner_3.1.jpg'),
                  _buildQuestionAnswer("🔥 மின்சாரம் காரணமாக ஏற்பட்ட தீயை அணைக்க ஏது சிறந்தது?", "CO₂ அல்லது உலர் தூள் அணைப்பான்."),
                  _buildQuestionAnswer("🔥 எரிபொருள் திரவங்கள் தீயை அணைக்க ஏது பயன்படுத்தப்படுகிறது?", "நுரை அல்லது உலர் தூள் அணைப்பான்.",imagePath: 'assets/banner_3.2.jpg'),
                  _buildQuestionAnswer("🔥 எண்ணெய் தீயில் தண்ணீர் அணைப்பான் பயன்படுத்துவது ஏன் ஆபத்தானது?", "தண்ணீர் எரியும் எண்ணெயை பரப்பி தீயை மேலும் மோசமாக்கும்."),
                  _buildQuestionAnswer("🔥 PASS முறை என்ன?", "பின்-ஐ இழுக்கவும், அடிப்பகுதியை நோக்கி குறிக்கவும், கைப்பிடியை அழுத்தவும், இடம் மாற்றிச் சுழற்றவும்.",imagePath: 'assets/banner_3.3.jpg'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிந்ததாக குறிக்கவும்"),
              value: istopic_3_Completed,
              onChanged: (value) {
                _saveTopicCompletionStatus(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("கடைசி மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("	மீண்டும் முயற்சி"),
              ),
          ],
        ),
      ),
    );
  }
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

