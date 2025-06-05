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
    1: "தீ என்பது வேகமான ஆக்ஸிடேஷன் செயல்முறை ஆகும்",
    2: "எரிபொருள், வெப்பம், ஆக்ஸிஜன்",
    3: "எரிபொருளும் ஆக்ஸிஜனும் சேர்ந்து நடக்கும் வெப்பமுள்ள வேதியியல் எதிர்வினை",
    4: "ஒரு பொருள் தீ பற்றும் வகையில் வாயுவாக மாறக்கூடிய குறைந்த வெப்பநிலை",
    5: "உட்புற வேதியியல் எதிர்வினையால் ஒரு பொருள் தானாகவே தீ பற்றுவது",
    6: "ஆக்ஸிஜன் தீயை பரப்ப ஆக்ஸிடைசராக செயல்படுகிறது",
    7: "ஆக்ஸிஜன் இல்லாமல் தீ அணைந்து விடும்",
    8: "கம்பிமுறை, ஒதுக்கும் முறை, கதிர்வீச்சு",
    9: "வெப்பநிலையும் எரியும் பொருளும் தீவின் நிறங்களை தீர்மானிக்கின்றன",
    10: "உயிரிழப்பு, சொத்து சேதம், நச்சுவாயுக்கள், வெடிப்பு அபாயங்கள், தீ பரவல்"
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "தீயின் அறிவியல் வரையறை என்ன?",
      "options": [
        "தீ என்பது வேகமான ஆக்ஸிடேஷன் செயல்முறை ஆகும்",
        "தீ என்பது நீர் மற்றும் காற்றின் கலவை",
        "தீ என்பது வெப்பம் மற்றும் காற்றின் உணர்வு",
        "தீ என்பது புகை மட்டுமே"
      ]
    },
    {
      "question": "தீக்காக தேவையான மூன்று கூறுகள் எவை?",
      "options": [
        "எரிபொருள், வெப்பம், ஆக்ஸிஜன்",
        "தண்ணீர், காற்று, இடம்",
        "நீர், வெப்பம், நபர்",
        "காற்று, நெருப்பு, அடுப்பு"
      ]
    },
    {
      "question": "எரிப்பு (Combustion) என்றால் என்ன?",
      "options": [
        "சாதாரண சூடு",
        "நீர் வேகும் செயல்முறை",
        "எரிபொருளும் ஆக்ஸிஜனும் சேர்ந்து நடக்கும் வெப்பமுள்ள வேதியியல் எதிர்வினை",
        "மின்சாரம் செல்லும் செயல்முறை"
      ]
    },
    {
      "question": "Flashpoint என்றால் என்ன?",
      "options": [
        "வெப்பத்துடன் மின்னல்",
        "ஒரு பொருள் தீ பற்றும் வகையில் வாயுவாக மாறக்கூடிய குறைந்த வெப்பநிலை",
        "மின்சாரம் செலுத்தும் அளவு",
        "காற்றின் அழுத்தம்"
      ]
    },
    {
      "question": "தானாகவே தீ பற்றுவது (Spontaneous Combustion) என்றால் என்ன?",
      "options": [
        "தீயை தூண்டுதல்",
        "போட்டியால் ஏற்படும் வெடிப்பு",
        "உட்புற வேதியியல் எதிர்வினையால் ஒரு பொருள் தானாகவே தீ பற்றுவது",
        "வெளிப்புற தீ கொளுத்துதல்"
      ]
    },
    {
      "question": "தீ பரவ ஆக்ஸிஜன் ஏன் தேவை?",
      "options": [
        "ஆக்ஸிஜன் தீயை அணைக்கும்",
        "ஆக்ஸிஜன் தீயை பரப்ப ஆக்ஸிடைசராக செயல்படுகிறது",
        "ஆக்ஸிஜன் வெப்பத்தை குளிர்விக்கிறது",
        "தேவை இல்லை"
      ]
    },
    {
      "question": "தீக்கு ஆக்ஸிஜன் இல்லாமல் போனால் என்ன ஆகும்?",
      "options": [
        "தீ வேகமாக பரவும்",
        "தீ சிறிது நேரம் அழுங்கும்",
        "ஆக்ஸிஜன் இல்லாமல் தீ அணைந்து விடும்",
        "தீ நிறம் மாறும்"
      ]
    },
    {
      "question": "தீ வேகமாக பரவுவதற்கான மூன்று முறை என்ன?",
      "options": [
        "காற்று, நீர், மண்",
        "கம்பிமுறை, ஒதுக்கும் முறை, கதிர்வீச்சு",
        "ஒலி, ஒளி, வெப்பம்",
        "பூமி, காற்று, தீ"
      ]
    },
    {
      "question": "தீ வெவ்வேறு நிறங்களை ஏன் காட்டுகிறது?",
      "options": [
        "வேதியியல் மாற்றங்கள் மற்றும் வெப்பநிலை காரணமாக",
        "மழை காரணமாக",
        "பூமியின் சுழற்சி காரணமாக",
        "தீயில் புகை இருக்காததால்"
      ]
    },
    {
      "question": "தீயின் முக்கிய ஆபத்துகள் என்ன?",
      "options": [
        "உயிரிழப்பு, சொத்து சேதம், நச்சுவாயுக்கள், வெடிப்பு அபாயங்கள், தீ பரவல்",
        "நீர் வெப்பம் அதிகரிப்பு",
        "காற்று மாசுபாடு மட்டும்",
        "பூமியின் குளிர்ச்சி"
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
              title: Text("தீ அறிவியல் வினாடி வினா"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${index}. ${question["question"]}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("அனைத்து கேள்விகளையும் பதிலளிக்கவும்")));
                    } else {
                      Navigator.of(dialogContext, rootNavigator: true).pop();
                      _evaluateQuiz();
                    }
                  },
                  child: Text("சமர்ப்பிக்கவும்"),
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
        title: Text("வினாடி வினா முடிவு"),
        content: Text("நீங்கள் பெற்ற மதிப்பெண்: $score / ${quizQuestions.length}"),
        actions: [
          TextButton(
            child: Text("சரி"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("மீண்டும் முயற்சிக்கவும்"),
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
        title: Text("தீ அறிவியல்"),
        backgroundColor: const Color(0xFFB22222),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () => _saveCompletion(true),
                child: Text("வினாடி வினா தொடங்கு"),
              ),
            ),
          ),
          if (hasTakenQuiz)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("கடைசியாக பெற்ற மதிப்பெண்: $quizScore / ${quizQuestions.length}"),
            ),
        ],
      ),
    );
  }
}
