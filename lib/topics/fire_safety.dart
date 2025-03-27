import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireSafetyPage extends StatefulWidget {
  @override
  _FireSafetyPageState createState() => _FireSafetyPageState();
}

class _FireSafetyPageState extends State<FireSafetyPage> {
  bool istopic_1_Completed = false;
  int quizScore = -1;  // Default -1 means quiz not taken
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FireSafety";  // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "Loss of life, property damage, environmental destruction",
    2: "Installing smoke alarms and fire extinguishers",
    3: "Get out, stay out, and call for help",
    4: "Elevators can get stuck",
    5: "Stay low, signal for help, cover nose/mouth with a cloth",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What are the main consequences of fire?",
      "options": [
        "Loss of life, property damage, environmental destruction",
        "Only damage to property",
        "Small fires are not dangerous",
        "None of the above"
      ]
    },
    {
      "question": "Which is a common fire safety measure?",
      "options": [
        "Playing with fire",
        "Installing smoke alarms and fire extinguishers",
        "Leaving doors unlocked",
        "Ignoring emergency exits"
      ]
    },
    {
      "question": "What is the ‘Golden Rule’ of fire safety?",
      "options": [
        "Try to fight the fire yourself",
        "Get out, stay out, and call for help",
        "Ignore the fire alarm",
        "Call for help but stay inside"
      ]
    },
    {
      "question": "Why should you avoid using elevators during a fire?",
      "options": [
        "Elevators can get stuck",
        "They help in fast evacuation",
        "They are fireproof",
        "None of the above"
      ]
    },
    {
      "question": "What should you do if trapped in a burning building?",
      "options": [
        "Stay low, signal for help, cover nose/mouth with a cloth",
        "Panic and scream",
        "Run without checking the fire location",
        "Wait for the fire to go out on its own"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _load_topic_1CompletionStatus();
  }

  Future<void> _load_topic_1CompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      istopic_1_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1; // ✅ Load quiz score
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _save_topic_1_CompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_1_Completed = value;
    });

    if (value) {
      // Show quiz **after** status is saved
      Future.delayed(Duration(milliseconds: 300), () {
        _showQuizDialog();
      });
    }
  }

  Future<void> _saveQuizScore(String key,int score) async {
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
              title: Text("Fire Safety Quiz"),
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
                  child: Text("Submit"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please answer all questions")),
                      );
                    } else {
                      Navigator.pop(dialogContext); // ✅ Close the dialog first
                      _evaluateQuiz(); // ✅ Evaluate quiz after closing dialog
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
    _saveQuizScore("FireSafety", score); // ✅ Save the quiz score for this topic
    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quiz Result"),
          content: Text("You scored $score out of ${quizQuestions.length}."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Retest"),
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
      appBar: AppBar(title: Text("Introduction to Fire Safety")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer(
                      "🔥 What is fire safety, and why is it important?",
                      "Fire safety refers to the precautions taken to prevent and reduce the risk of fire.\n\nIt is crucial because fires can cause:\n\n• Loss of life\n• Property damage\n• Environmental destruction\n\nBy following fire safety protocols, we can minimize these risks and ensure safety in homes, workplaces, and public spaces."
                  ),
                  _buildQuestionAnswer(
                      "🔥 What are common fire safety measures?",
                      "Some common fire safety measures include:\n\n1. Installing smoke alarms and fire extinguishers\n2. Regular maintenance of electrical appliances and wiring\n3. Proper storage of flammable materials\n4. Having an emergency fire escape plan\n5. Conducting fire drills to ensure preparedness"
                  ),
                  _buildQuestionAnswer(
                      "🔥 What should be included in a fire safety plan?",
                      "A fire safety plan should include:\n\n1. A clear evacuation procedure\n2. Designated emergency exits\n3. Locations of fire extinguishers and alarms\n4. Contact information for emergency services\n5. Roles and responsibilities of individuals in case of fire"
                  ),
                  _buildQuestionAnswer(
                      "🔥 Why do fire hazards occur in workplaces and homes?",
                      "Fire hazards occur due to various factors such as:\n\n1. Faulty electrical wiring\n2. Overloaded power sockets\n3. Smoking near flammable materials\n4. Improper storage of flammable liquids\n5. Blocked fire exits, preventing a safe escape"
                  ),
                  _buildQuestionAnswer(
                      "🔥 What is the ‘Golden Rule’ of fire safety?",
                      "The ‘Golden Rule’ of fire safety is:\n\n**‘Get out, stay out, and call for help.’**\n\nNever try to fight a fire unless you have been trained to do so and it is safe. Always prioritize personal safety and evacuate the area immediately."
                  ),
                  _buildQuestionAnswer(
                      "🔥 What is the significance of a fire drill?",
                      "Fire drills are essential for:\n\n1. Ensuring everyone knows emergency evacuation procedures\n2. Training people on how to respond in case of fire\n3. Identifying potential escape obstacles\n4. Helping organizations comply with safety regulations\n5. Improving overall emergency preparedness"
                  ),
                  _buildQuestionAnswer(
                      "🔥 What should you do if you hear a fire alarm?",
                      "If you hear a fire alarm:\n\n1. Leave the building immediately using the nearest exit\n2. Stay calm and avoid panicking\n3. Do not use elevators\n4. Call emergency services once safely outside\n5. Assist others if needed, but prioritize personal safety"
                  ),
                  _buildQuestionAnswer(
                      "🔥 What is the role of fire wardens?",
                      "Fire wardens play a crucial role in fire safety by:\n\n1. Monitoring fire risks and ensuring compliance with safety measures\n2. Assisting in evacuations during fire emergencies\n3. Using fire extinguishers when necessary\n4. Communicating with emergency services and staff\n5. Conducting fire drills and training sessions"
                  ),
                  _buildQuestionAnswer(
                      "🔥 Why should fire exits always be kept clear?",
                      "Fire exits must always be kept clear because:\n\n1. Blocked exits can prevent people from escaping in an emergency\n2. Clear exits ensure a fast and safe evacuation\n3. Clutter can become fuel for fire, worsening the situation\n4. Emergency responders need unobstructed access"
                  ),
                  _buildQuestionAnswer(
                      "🔥 How can individuals contribute to fire safety?",
                      "Individuals can contribute to fire safety by:\n\n1. Learning and following fire safety guidelines\n2. Knowing how to use fire extinguishers\n3. Keeping emergency exits clear\n4. Reporting fire hazards immediately\n5. Educating family and coworkers about fire safety"
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: istopic_1_Completed,
              onChanged: (value) {
                _save_topic_1_CompletionStatus(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("Retest"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionAnswer(String question, String answer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16,color: Colors.black)),
          ],
        ),
      ),
    );
  }
}



