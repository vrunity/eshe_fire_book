import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonCausesPage extends StatefulWidget {
  @override
  _CommonCausesPageState createState() => _CommonCausesPageState();
}

class _CommonCausesPageState extends State<CommonCausesPage> {
  bool istopic_2_Completed = false;
  int quizScore = 0;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "CommonCauses"; // Unique identifier for this topic

  final Map<int, String> correctAnswers = {
    1: "Overloaded electrical circuits and faulty wiring",
    2: "600°C (1,112°F)",
    3: "Lack of maintenance, frayed wires, leaking gas",
    4: "Static sparks ignite flammable gases or dust",
    5: "Proper storage, electrical inspections, fire safety training",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Which of the following is a common cause of fire?",
      "options": [
        "Overloaded electrical circuits and faulty wiring",
        "Cold weather conditions",
        "Pure oxygen atmosphere",
        "None of the above"
      ]
    },
    {
      "question": "At what temperature do cigarettes burn and cause fire hazards?",
      "options": [
        "100°C (212°F)",
        "300°C (572°F)",
        "600°C (1,112°F)",
        "900°C (1,652°F)"
      ]
    },
    {
      "question": "What increases the likelihood of fire outbreaks?",
      "options": [
        "Lack of maintenance, frayed wires, leaking gas",
        "Regular equipment checks",
        "Emergency preparedness",
        "Fire extinguishers"
      ]
    },
    {
      "question": "How does static electricity cause fires?",
      "options": [
        "It powers fire alarms",
        "Static sparks ignite flammable gases or dust",
        "It cools down hot surfaces",
        "It prevents electric shocks"
      ]
    },
    {
      "question": "Which of the following helps prevent workplace fires?",
      "options": [
        "Proper storage, electrical inspections, fire safety training",
        "Ignoring fire drills",
        "Overloading power sockets",
        "Leaving flammable liquids open"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _load_topic_2_CompletionStatus();
  }

  Future<void> _load_topic_2_CompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      istopic_2_Completed = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? 0;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _save_topic_2_CompletionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      istopic_2_Completed = value;
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
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Common Causes of Fire Quiz"),
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
                      Navigator.of(dialogContext, rootNavigator: true).pop();
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
          title: Text("Quiz Result"),
          content: Text("You scored $score out of ${quizQuestions.length}.\nSaved under topic: $topicName"),
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
      appBar: AppBar(title: Text("Common Causes of Fire")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer(
                      "🔥 What are the main causes of fire?",
                      "Fires can be caused by multiple factors, including **human negligence, electrical faults, and improper handling of flammable materials**. "
                          "Many fires start due to **unattended open flames**, careless disposal of cigarette butts, and **accidental ignition of combustible materials** such as gasoline, paper, or chemicals. "
                          "Additionally, **overloaded electrical circuits and faulty wiring** can lead to short circuits, which often result in electrical fires."
                  ),
                  _buildQuestionAnswer(
                      "🔥 What is the danger of smoking near flammable substances?",
                      "Smoking near **flammable substances** such as **gasoline, propane, chemicals, and dry vegetation** is highly dangerous because cigarette butts can ignite these materials even if they appear extinguished. "
                          "Cigarettes burn at temperatures exceeding **600°C (1,112°F)**, which is more than enough to ignite flammable liquids and gases. "
                          "Improperly discarded cigarette butts are one of the leading causes of wildfires and industrial fires."
                  ),
                  _buildQuestionAnswer(
                      "🔥 Why is poor maintenance a fire risk?",
                      "Lack of **proper maintenance** of electrical equipment, gas appliances, and industrial machines can lead to fire hazards. "
                          "Frayed electrical wires, **malfunctioning circuits**, and **leaking gas connections** increase the likelihood of fire outbreaks. "
                          "Dust buildup in **electrical panels** and **overheated motors** in machinery can cause sparks that ignite nearby flammable materials. "
                          "Regular inspections and maintenance of appliances, wiring, and fuel lines are crucial in preventing fire incidents."
                  ),
                  _buildQuestionAnswer(
                      "🔥 How does static electricity cause fires?",
                      "Static electricity is the buildup of electric charge on a surface, and when discharged, it can create a spark. "
                          "In environments containing **flammable gases, vapors, or fine combustible dust**, a static spark can ignite an explosion. "
                          "For example, in **fuel storage facilities and chemical plants**, improperly grounded equipment can allow **static charges to accumulate**, increasing the risk of accidental ignition. "
                          "To prevent static electricity-related fires, workers should wear **anti-static clothing**, and equipment should be properly grounded to discharge static buildup safely."
                  ),
                  _buildQuestionAnswer(
                      "🔥 What should be done to prevent fires at workplaces?",
                      "Fire prevention at workplaces requires a combination of **awareness, training, and proper safety measures**. Here are essential steps to prevent workplace fires:\n\n"
                          "✅ **Proper storage of flammable materials** – Keep chemicals, gases, and combustible liquids in designated storage areas away from heat sources.\n"
                          "✅ **Routine electrical inspections** – Ensure that wiring, outlets, and electrical appliances are checked regularly to avoid malfunctions.\n"
                          "✅ **Fire safety training** – Employees should be trained to handle fire extinguishers and know evacuation procedures.\n"
                          "✅ **Good housekeeping** – Avoid clutter and accumulation of waste materials that could catch fire easily.\n"
                          "✅ **Installation of fire alarms and sprinklers** – Early detection and suppression systems help control fires before they spread."
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: istopic_2_Completed,
              onChanged: (value) {
                _save_topic_2_CompletionStatus(value ?? false);
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
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
