// lib/topics/environment_safety_tamil/introduction_to_environment.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/tamil/environment_safety_tamil.dart';

class IntroductionToEnvironmentTamilPage extends StatefulWidget {
  @override
  _IntroductionToEnvironmentTamilPageState createState() => _IntroductionToEnvironmentTamilPageState();
}

class _IntroductionToEnvironmentTamilPageState extends State<IntroductionToEnvironmentTamilPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "EnvTopic1";

  final Map<int, String> correctAnswers = {
    1: "சுற்றுச்சூழல் என்பது உயிருள்ளவை மற்றும் உயிரில்லாத அனைத்தையும் உள்ளடக்கியது.",
    2: "இதில் வாழ்வதற்கான காற்று, நீர், உணவு மற்றும் தங்கும் இடம் உள்ளது.",
    3: "இது நமது ஆரோக்கியம் மற்றும் வாழ்வத் தரத்தை பாதிக்கும் என்பதால்.",
    4: "காலநிலையை ஒழுங்குபடுத்துகிறது மற்றும் உயிரினப் பன்மையை ஆதரிக்கிறது.",
    5: "இது உடல் மற்றும் மன நலத்தை நிலைத்திருப்பதில் உதவுகிறது."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "சுற்றுச்சூழல் என்பது என்னை உள்ளடக்கியது?",
      "options": [
        "மூலிகைகள் மற்றும் விலங்குகள் மட்டும்",
        "காற்று மற்றும் நீர் மட்டும்",
        "மனிதர்கள் மட்டும்",
        "சுற்றுச்சூழல் என்பது உயிருள்ளவை மற்றும் உயிரில்லாத அனைத்தையும் உள்ளடக்கியது."
      ]
    },
    {
      "question": "வாழ்வதற்கான சுற்றுச்சூழலின் முக்கியத்துவம் என்ன?",
      "options": [
        "விளையாட்டு வசதி தரும்",
        "இதில் வாழ்வதற்கான காற்று, நீர், உணவு மற்றும் தங்கும் இடம் உள்ளது.",
        "சத்தத்தை உண்டாக்கும்",
        "சூரிய ஒளியை மறைக்கும்"
      ]
    },
    {
      "question": "சுற்றுச்சூழலை நாம் ஏன் கவனிக்க வேண்டும்?",
      "options": [
        "ஏனெனில் அது டிரெண்டியாக உள்ளது",
        "இது நமது ஆரோக்கியம் மற்றும் வாழ்வத் தரத்தை பாதிக்கும் என்பதால்.",
        "மற்றவர்கள் கவனிக்கின்றனர்",
        "இது நம்மிடம் இல்லை"
      ]
    },
    {
      "question": "சுற்றுச்சூழல் காலநிலையை எவ்வாறு பாதிக்கிறது?",
      "options": [
        "காலநிலையை ஒழுங்குபடுத்துகிறது மற்றும் உயிரினப் பன்மையை ஆதரிக்கிறது.",
        "வெப்பநிலையை மட்டும் அதிகரிக்கிறது",
        "எந்தவிதமான தாக்கமும் இல்லை",
        "மழையை தடுக்கும்"
      ]
    },
    {
      "question": "தூய்மையான சுற்றுச்சூழல் எவ்வாறு உதவுகிறது?",
      "options": [
        "இது நம்மை சோம்பேறியாக்கும்",
        "இது உடல் மற்றும் மன நலத்தை நிலைத்திருப்பதில் உதவுகிறது.",
        "மாசு அதிகரிக்கும்",
        "அதிக செலவு"
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
              title: Text("வினாடி வினா: சுற்றுச்சூழல் அறிமுகம்"),
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
                  Navigator.pushNamed(context, '/save_the_environment_ta');
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
        title: Text("சுற்றுச்சூழல் அறிமுகம்"),
        backgroundColor: Colors.green[700],
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
                  _buildQuestionAnswer("🌍 சுற்றுச்சூழல் என்பது என்ன?", "சுற்றுச்சூழல் என்பது உயிருள்ளவை மற்றும் உயிரில்லாத அனைத்தையும் உள்ளடக்கியது.", imagePath: 'assets/env_1.0.png'),
                  _buildQuestionAnswer("💨 சுற்றுச்சூழல் நமக்கு என்ன வழங்குகிறது?", "இதில் வாழ்வதற்கான காற்று, நீர், உணவு மற்றும் தங்கும் இடம் உள்ளது."),
                  _buildQuestionAnswer("❓ சுற்றுச்சூழலை நாம் ஏன் கவனிக்க வேண்டும்?", "இது நமது ஆரோக்கியம் மற்றும் வாழ்வத் தரத்தை பாதிக்கும் என்பதால்.", imagePath: 'assets/env_1.1.png'),
                  _buildQuestionAnswer("🌦 சுற்றுச்சூழல் காலநிலையை எப்படி ஒழுங்குபடுத்துகிறது?", "இது காற்று தரம், வெப்பநிலை மற்றும் உயிரினப் பன்மையை ஆதரிக்கிறது."),
                  _buildQuestionAnswer("🧘‍♂️ இது நம்மை எவ்வாறு நலமாக வைத்திருக்கிறது?", "தூய்மை வாய்ந்த சுற்றுச்சூழல் உடல் மற்றும் மன நலத்திற்கு உதவுகிறது.", imagePath: 'assets/env_1.2.png'),
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
