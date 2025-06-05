// lib/topics/environment_safety_tamil/save_the_environment.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/environment_safety_tamil.dart';

class SaveTheEnvironmentTamilPage extends StatefulWidget {
  @override
  _SaveTheEnvironmentTamilPageState createState() => _SaveTheEnvironmentTamilPageState();
}

class _SaveTheEnvironmentTamilPageState extends State<SaveTheEnvironmentTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EnvTopic2";

  final Map<int, String> correctAnswers = {
    1: "உலக வெப்பமடைதல், மாசுபாடு மற்றும் காடழிப்பு முக்கியமான அச்சுறுத்தல்களாகும்.",
    2: "சுற்றுச்சூழல் என்பது எதிர்காலத்தை 위해 பாதுகாக்க வேண்டிய இயற்கையின் பரிசு.",
    3: "சுற்றுச்சூழலை பாதுகாப்பது எதிர்காலத்திற்கு வாழத்தக்க கிரகத்தை உறுதி செய்கிறது.",
    4: "மாசுபாட்டை குறைத்து இயற்கை வளங்களை பாதுகாக்க வேண்டும்.",
    5: "பிளாஸ்டிக் குறைவாக பயன்படுத்தவும், மறுசுழற்சி செய்யவும், நீரை சேமிக்கவும்."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "சுற்றுச்சூழலுக்கான அச்சுறுத்தல்கள் எவை?",
      "options": [
        "அதிக பூங்காக்கள் மற்றும் தோட்டங்கள்",
        "தூய்மையான ஆறுகள்",
        "உலக வெப்பமடைதல், மாசுபாடு மற்றும் காடழிப்பு முக்கியமான அச்சுறுத்தல்களாகும்.",
        "மரங்களை நடுவது"
      ]
    },
    {
      "question": "சுற்றுச்சூழல் ஏன் பரிசாக கருதப்படுகிறது?",
      "options": [
        "அது பசுமையாக இருக்கிறது",
        "இது இலவசம் என்பதால்",
        "சுற்றுச்சூழல் என்பது எதிர்காலத்திற்காக பாதுகாக்க வேண்டிய இயற்கையின் பரிசு.",
        "இதற்கு மதிப்பு இல்லை"
      ]
    },
    {
      "question": "நாம் சுற்றுச்சூழலை ஏன் பாதுகாக்க வேண்டும்?",
      "options": [
        "பணம் காக",
        "சுற்றுச்சூழலை பாதுகாப்பது எதிர்காலத்திற்கு வாழத்தக்க கிரகத்தை உறுதி செய்கிறது.",
        "விதிகளை தவிர்க்க",
        "அது சலிப்பாக உள்ளது"
      ]
    },
    {
      "question": "நாம் சுற்றுச்சூழலை எவ்வாறு பாதுகாக்கலாம்?",
      "options": [
        "மாசுபாட்டை குறைத்து இயற்கை வளங்களை பாதுகாக்க வேண்டும்.",
        "பிளாஸ்டிக் அதிகமாக பயன்படுத்தவும்",
        "மரங்களை வெட்டவும்",
        "நீரை வீணாக்கவும்"
      ]
    },
    {
      "question": "சுற்றுச்சூழலுக்காக தினசரி பழக்கங்கள் என்ன?",
      "options": [
        "பிளாஸ்டிக் குறைவாக பயன்படுத்தவும், மறுசுழற்சி செய்யவும், நீர் மற்றும் மின்சாரத்தை சேமிக்கவும்.",
        "அங்கங்கே குப்பையை வீசவும்",
        "விளக்குகளை எப்போதும் ஆன் நிலையில் வைக்கவும்",
        "சுற்றுச்சூழல் செய்திகள் அனைத்தையும் தவிர்க்கவும்"
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
              title: Text("வினாடி வினா: சுற்றுச்சூழலை பாதுகாக்கும் வழிகள்"),
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
                  child: Text("சமர்ப்பிக்கவும்"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("தயவுசெய்து அனைத்து வினாக்களையும் பதிலளிக்கவும்")),
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
          title: Text("வினா முடிவுகள்"),
          content: Text("நீங்கள் ${quizQuestions.length} இல் $score மதிப்பெண்களை பெற்றுள்ளீர்கள்."),
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
                  Navigator.pushNamed(context, '/environmental_pollution_types_ta');
                },
              ),
            TextButton(
              child: Text("மீண்டும் முயற்சிக்கவும்"),
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
                child: Image.asset(imagePath, fit: BoxFit.cover, height: 180, width: double.infinity),
              ),
            if (imagePath != null) SizedBox(height: 10),
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
        title: Text("சுற்றுச்சூழலை பாதுகாப்பது"),
        backgroundColor: Colors.green[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => EnvironmentalSafetyTamil()),
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
                  _buildQuestionAnswer("🌍 சுற்றுச்சூழலுக்கான முக்கியமான அச்சுறுத்தல்கள் என்ன?", "உலக வெப்பமடைதல், மாசுபாடு மற்றும் காடழிப்பு முக்கியமான அச்சுறுத்தல்களாகும்.", imagePath: 'assets/env_2.0.png'),
                  _buildQuestionAnswer("🎁 சுற்றுச்சூழல் இயற்கையின் பரிசாக இருப்பதற்கான காரணம்?", "இதை எதிர்காலக் தலைமுறைகளுக்காக பாதுகாக்க வேண்டும்."),
                  _buildQuestionAnswer("🌱 சுற்றுச்சூழலை ஏன் பாதுகாக்க வேண்டும்?", "அனைத்து உயிரினங்களின் வாழ்வும் நலனும் உறுதிசெய்யும்.", imagePath: 'assets/env_2.1.png'),
                  _buildQuestionAnswer("♻ நாம் சுற்றுச்சூழலுக்கு எவ்வாறு உதவலாம்?", "மாசுபாட்டை குறைத்து, வளங்களை பாதுகாத்து, மரங்களை நடுவது போன்ற வழிகள்."),
                  _buildQuestionAnswer("🚰 சுற்றுச்சூழலை பாதுகாக்கும் பழக்கங்கள் என்ன?", "மறுசுழற்சி, பிளாஸ்டிக் உபயோகத்தை குறைத்தல், நீர் மற்றும் மின்சார சேமிப்பு.", imagePath: 'assets/env_1.0.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("முடிக்கப்பட்டதாக குறிக்கவும்"),
              value: isCompleted,
              onChanged: (value) {
                _saveTopicCompletion(value ?? false);
              },
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
