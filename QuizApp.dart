import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: QuizScreen(),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imageAsset; // Optional image for the question

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.imageAsset,
  });
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // List of quiz questions with added image-based questions
  late List<QuizQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
  }

  void _initializeQuestions() {
    _questions = [
      QuizQuestion(
        question: "What is Flutter's primary programming language?",
        options: ["Java", "Kotlin", "Dart", "Swift"],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: "Who developed Flutter?",
        options: ["Apple", "Google", "Microsoft", "Facebook"],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: "What is a Widget in Flutter?",
        options: [
          "A mobile device",
          "A UI component",
          "A database",
          "A database query"
        ],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: "Which mobile logo is this?",
        options: ["Apple", "Samsung", "Google", "Microsoft"],
        correctAnswerIndex: 1,
        imageAsset: 'assets/samsung_logo.png',
      ),
      QuizQuestion(
        question: "Identify this programming language logo",
        options: ["Python", "Java", "JavaScript", "Ruby"],
        correctAnswerIndex: 0,
        imageAsset: 'assets/python_logo.png',
      ),
      QuizQuestion(
        question: "Which social media logo is shown?",
        options: ["Facebook", "Twitter", "Instagram", "LinkedIn"],
        correctAnswerIndex: 2,
        imageAsset: 'assets/instagram_logo.png',
      ),
    ];

    // Randomize the entire list of questions
    _questions.shuffle(Random());

    // For each question, shuffle its options while maintaining the correct answer
    for (var question in _questions) {
      final correctOption = question.options[question.correctAnswerIndex];
      final shuffledOptions = List<String>.from(question.options)..shuffle();
      final newCorrectIndex = shuffledOptions.indexOf(correctOption);

      // Update the question with shuffled options and new correct answer index
      question = QuizQuestion(
        question: question.question,
        options: shuffledOptions,
        correctAnswerIndex: newCorrectIndex,
        imageAsset: question.imageAsset,
      );
    }
  }

  int _currentQuestionIndex = 0;
  int _score = 0;

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == _questions[_currentQuestionIndex].correctAnswerIndex) {
      setState(() {
        _score++;
      });
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Navigate to results screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(score: _score, totalQuestions: _questions.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Flutter Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Conditionally render image if available
            if (currentQuestion.imageAsset != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  currentQuestion.imageAsset!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),

            // Generate answer buttons
            ...List.generate(
              currentQuestion.options.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(index),
                  child: Text(
                    currentQuestion.options[index],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  ResultScreen({required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Completed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Your Score: $score / $totalQuestions',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(),
                  ),
                );
              },
              child: Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
