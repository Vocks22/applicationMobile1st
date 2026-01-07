import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _quizCompleted = false;
  bool _showingHistory = false;
  List<Map<String, dynamic>> _quizHistory = [];

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Votre entreprise utilise-t-elle des outils d\'IA au quotidien ?',
      'answers': [
        {'text': 'Oui, plusieurs outils sont intégrés', 'score': 3},
        {'text': 'Oui, quelques outils ponctuellement', 'score': 2},
        {'text': 'Non, mais nous y réfléchissons', 'score': 1},
        {'text': 'Non, pas du tout', 'score': 0},
      ],
    },
    {
      'question': 'Avez-vous une stratégie IA définie pour votre entreprise ?',
      'answers': [
        {'text': 'Oui, avec une feuille de route claire', 'score': 3},
        {'text': 'Oui, mais encore en cours de définition', 'score': 2},
        {'text': 'Non, mais c\'est prévu', 'score': 1},
        {'text': 'Non, pas encore', 'score': 0},
      ],
    },
    {
      'question': 'Vos équipes sont-elles formées aux outils d\'IA ?',
      'answers': [
        {'text': 'Oui, formations régulières', 'score': 3},
        {'text': 'Oui, formation initiale effectuée', 'score': 2},
        {'text': 'Partiellement, quelques personnes', 'score': 1},
        {'text': 'Non, pas encore', 'score': 0},
      ],
    },
    {
      'question': 'Utilisez-vous l\'IA pour automatiser des tâches répétitives ?',
      'answers': [
        {'text': 'Oui, plusieurs processus automatisés', 'score': 3},
        {'text': 'Oui, quelques automatisations', 'score': 2},
        {'text': 'En cours de mise en place', 'score': 1},
        {'text': 'Non, pas encore', 'score': 0},
      ],
    },
    {
      'question': 'Comment évaluez-vous la qualité de vos données ?',
      'answers': [
        {'text': 'Excellente, données structurées et documentées', 'score': 3},
        {'text': 'Bonne, mais peut être améliorée', 'score': 2},
        {'text': 'Moyenne, données dispersées', 'score': 1},
        {'text': 'Faible, données non structurées', 'score': 0},
      ],
    },
    {
      'question': 'Avez-vous un budget dédié aux projets IA ?',
      'answers': [
        {'text': 'Oui, budget annuel défini', 'score': 3},
        {'text': 'Oui, budget ponctuel par projet', 'score': 2},
        {'text': 'En discussion', 'score': 1},
        {'text': 'Non, pas de budget prévu', 'score': 0},
      ],
    },
    {
      'question': 'Utilisez-vous des chatbots ou assistants virtuels ?',
      'answers': [
        {'text': 'Oui, pour clients et/ou employés', 'score': 3},
        {'text': 'Oui, en phase de test', 'score': 2},
        {'text': 'Non, mais c\'est prévu', 'score': 1},
        {'text': 'Non, pas prévu', 'score': 0},
      ],
    },
    {
      'question': 'L\'IA fait-elle partie de votre avantage concurrentiel ?',
      'answers': [
        {'text': 'Oui, c\'est un différenciateur clé', 'score': 3},
        {'text': 'Oui, partiellement', 'score': 2},
        {'text': 'Pas encore, mais nous y travaillons', 'score': 1},
        {'text': 'Non, pas vraiment', 'score': 0},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('quiz_history');
    if (historyJson != null) {
      setState(() {
        _quizHistory = List<Map<String, dynamic>>.from(
          json.decode(historyJson).map((x) => Map<String, dynamic>.from(x)),
        );
      });
    }
  }

  Future<void> _saveResult() async {
    final prefs = await SharedPreferences.getInstance();
    final result = {
      'date': DateTime.now().toIso8601String(),
      'score': _score,
      'maxScore': _questions.length * 3,
      'percentage': ((_score / (_questions.length * 3)) * 100).round(),
      'level': _getLevel(),
    };
    _quizHistory.insert(0, result);
    if (_quizHistory.length > 10) {
      _quizHistory = _quizHistory.sublist(0, 10);
    }
    await prefs.setString('quiz_history', json.encode(_quizHistory));
  }

  String _getLevel() {
    final percentage = (_score / (_questions.length * 3)) * 100;
    if (percentage >= 75) return 'Expert';
    if (percentage >= 50) return 'Intermédiaire';
    if (percentage >= 25) return 'Débutant';
    return 'Novice';
  }

  Color _getLevelColor() {
    final percentage = (_score / (_questions.length * 3)) * 100;
    if (percentage >= 75) return Colors.green;
    if (percentage >= 50) return Colors.blue;
    if (percentage >= 25) return Colors.orange;
    return Colors.red;
  }

  String _getLevelDescription() {
    final level = _getLevel();
    switch (level) {
      case 'Expert':
        return 'Félicitations ! Votre entreprise est très mature en IA. Continuez à innover et à optimiser vos processus.';
      case 'Intermédiaire':
        return 'Bonne progression ! Vous avez de bonnes bases. Concentrez-vous sur la formation et l\'automatisation.';
      case 'Débutant':
        return 'Vous êtes sur la bonne voie ! Il est temps de définir une stratégie IA et de former vos équipes.';
      default:
        return 'C\'est le moment de commencer votre transformation IA ! Contactez-nous pour un audit personnalisé.';
    }
  }

  void _answerQuestion(int score) {
    setState(() {
      _score += score;
      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
      } else {
        _quizCompleted = true;
        _saveResult();
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _quizCompleted = false;
    });
  }

  void _shareResult() {
    final percentage = ((_score / (_questions.length * 3)) * 100).round();
    final level = _getLevel();
    Share.share(
      '🤖 J\'ai évalué ma maturité IA avec INFIA !\n\n'
      '📊 Score : $percentage%\n'
      '🎯 Niveau : $level\n\n'
      'Évaluez aussi votre entreprise avec l\'app INFIA !\n'
      'https://inf-ia.com',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: _showingHistory ? _buildHistoryView(theme, colorScheme) :
             _quizCompleted ? _buildResultView(theme, colorScheme) :
             _buildQuizView(theme, colorScheme),
    );
  }

  Widget _buildQuizView(ThemeData theme, ColorScheme colorScheme) {
    final question = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quiz Maturité IA',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_quizHistory.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () => setState(() => _showingHistory = true),
                  tooltip: 'Historique',
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Question ${_currentQuestion + 1}/${_questions.length}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.psychology,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  question['question'],
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(
            (question['answers'] as List).length,
            (index) {
              final answer = question['answers'][index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _answerQuestion(answer['score']),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              answer['text'],
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(ThemeData theme, ColorScheme colorScheme) {
    final percentage = ((_score / (_questions.length * 3)) * 100).round();
    final level = _getLevel();
    final levelColor = _getLevelColor();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Résultats',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  levelColor.withValues(alpha: 0.2),
                  levelColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: levelColor.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: levelColor.withValues(alpha: 0.2),
                    border: Border.all(color: levelColor, width: 4),
                  ),
                  child: Center(
                    child: Text(
                      '$percentage%',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: levelColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: levelColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Niveau $level',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _getLevelDescription(),
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _shareResult,
                  icon: const Icon(Icons.share),
                  label: const Text('Partager'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetQuiz,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refaire'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_quizHistory.length > 1)
            TextButton.icon(
              onPressed: () => setState(() => _showingHistory = true),
              icon: const Icon(Icons.history),
              label: const Text('Voir l\'historique'),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryView(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _showingHistory = false),
              ),
              Text(
                'Historique',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_quizHistory.isEmpty)
            Center(
              child: Text(
                'Aucun historique disponible',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ...List.generate(_quizHistory.length, (index) {
              final result = _quizHistory[index];
              final date = DateTime.parse(result['date']);
              final formattedDate = '${date.day}/${date.month}/${date.year}';

              Color levelColor;
              switch (result['level']) {
                case 'Expert':
                  levelColor = Colors.green;
                  break;
                case 'Intermédiaire':
                  levelColor = Colors.blue;
                  break;
                case 'Débutant':
                  levelColor = Colors.orange;
                  break;
                default:
                  levelColor = Colors.red;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: levelColor.withValues(alpha: 0.2),
                      ),
                      child: Center(
                        child: Text(
                          '${result['percentage']}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: levelColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result['level'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index == 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Dernier',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
