import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireSciencePage extends StatefulWidget {
  @override
  _FireSciencePageState createState() => _FireSciencePageState();
}

class _FireSciencePageState extends State<FireSciencePage> {
  bool istopicCompleted = false;
  int quizScore = 0;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FireScience";

  final Map<int, String> correctAnswers = {
    1: "Fire is a rapid oxidation process known as combustion",
    2: "Fuel, Heat, Oxygen",
    3: "A chemical reaction between fuel and oxygen producing heat and light",
    4: "The lowest temperature at which a substance emits enough vapor to ignite",
    5: "It occurs when internal chemical reaction causes self-heating to ignition",
    6: "Oxygen acts as an oxidizer that supports the combustion reaction",
    7: "The fire will die out due to lack of oxygen",
    8: "Conduction, Convection, Radiation",
    9: "Depends on temperature and chemical composition",
    10: "Life loss, property damage, toxic gases, explosions, fire spread"
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What is the scientific definition of fire?",
      "options": [
        "Fire is a rapid oxidation process known as combustion",
        "Fire is heat mixed with wind",
        "Fire is smoke and temperature",
        "Fire is only visible flame"
      ]
    },
    {
      "question": "What are the three main components required for fire?",
      "options": [
        "Fuel, Heat, Oxygen",
        "Air, Water, Ground",
        "Water, Heat, Person",
        "Wind, Fire, Stove"
      ]
    },
    {
      "question": "What is combustion?",
      "options": [
        "Regular heating",
        "Water boiling",
        "A chemical reaction between fuel and oxygen producing heat and light",
        "Electricity flow"
      ]
    },
    {
      "question": "What is a flashpoint?",
      "options": [
        "Lightning with heat",
        "The lowest temperature at which a substance emits enough vapor to ignite",
        "Electricity capacity",
        "Air pressure value"
      ]
    },
    {
      "question": "What is spontaneous combustion?",
      "options": [
        "External ignition",
        "Short circuit fire",
        "It occurs when internal chemical reaction causes self-heating to ignition",
        "When exposed to flame"
      ]
    },
    {
      "question": "Why is oxygen necessary for fire?",
      "options": [
        "Oxygen puts out fire",
        "Oxygen acts as an oxidizer that supports the combustion reaction",
        "Oxygen cools the fire",
        "It is not required"
      ]
    },
    {
      "question": "What happens when fire runs out of oxygen?",
      "options": [
        "Fire spreads more",
        "Fire burns slowly",
        "The fire will die out due to lack of oxygen",
        "The flame turns blue"
      ]
    },
    {
      "question": "How does fire spread rapidly?",
      "options": [
        "Water, Smoke, Dust",
        "Conduction, Convection, Radiation",
        "Sound, Light, Heat",
        "Soil, Air, Fire"
      ]
    },
    {
      "question": "Why does fire emit different colors?",
      "options": [
        "Due to temperature and chemical composition",
        "Because of rain",
        "Due to Earth's rotation",
        "Because there is no smoke"
      ]
    },
    {
      "question": "What are the main dangers of fire?",
      "options": [
        "Life loss, property damage, toxic gases, explosions, fire spread",
        "Hot weather",
        "Only air pollution",
        "Water evaporation"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCompletion();
  }

  Future<void> _loadCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      istopicCompleted = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? 0;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopicCompleted = value;
    });
    _showQuizDialog();
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
              title: Text("Fire Science Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$index. ${question["question"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[index],
                            onChanged: (value) {
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
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please answer all questions")));
                    } else {
                      Navigator.of(dialogContext, rootNavigator: true).pop();
                      _evaluateQuiz();
                    }
                  },
                  child: Text("Submit"),
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
      if (correctAnswers[key] == value) score++;
    });
    _saveQuizScore(score);
    _showResult(score);
  }

  void _showResult(int score) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Quiz Result"),
        content: Text("You scored $score out of ${quizQuestions.length}"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Retake"),
            onPressed: () {
              Navigator.pop(context);
              _showQuizDialog();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fire Science Quiz"),
        backgroundColor: const Color(0xFFB22222),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () => _saveCompletion(true),
                child: Text("Start Quiz"),
              ),
            ),
          ),
          if (hasTakenQuiz)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Last Score: $quizScore / ${quizQuestions.length}"),
            ),
        ],
      ),
    );
  }
}
