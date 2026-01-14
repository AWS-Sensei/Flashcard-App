import 'dart:convert';
import 'dart:math';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/flashcard.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/meta_chip.dart';
import '../widgets/skeleton_line.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({
    super.key,
    required this.onSignedOut,
    required this.onToggleTheme,
  });

  final VoidCallback onSignedOut;
  final void Function(Brightness brightness) onToggleTheme;

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  static const _developerSubjects = [
    'Deployment',
    'Security',
    'Development with AWS Services',
    'Troubleshooting and Optimization',
  ];
  static const _architectSubjects = [
    'Design Cost-Optimized Architectures',
    'Design High-Performing Architectures',
    'Design Resilient Architectures',
    'Design Secure Architectures',
  ];

  bool _isLoading = false;
  String? _errorMessage;
  FlashcardQuestion? _question;
  FlashcardAnswer? _answer;
  bool _showAnswer = false;
  late final AnimationController _flipController;
  String? _selectedCareer;
  String? _selectedSubject;
  bool _showMultipleChoice = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fetchRandomQuestion();
  }

  List<String> _subjectOptions() {
    if (_selectedCareer == 'Developer Associate') {
      return _developerSubjects;
    }
    if (_selectedCareer == 'Architect Associate') {
      return _architectSubjects;
    }
    return [..._developerSubjects, ..._architectSubjects];
  }

  Map<String, String> _buildQueryParameters() {
    final params = <String, String>{};
    if (_selectedSubject != null) {
      params['subject'] = _selectedSubject!;
    }
    if (_selectedCareer != null) {
      params['career'] = _selectedCareer!;
    }
    return params;
  }

  Future<void> _fetchRandomQuestion() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _answer = null;
      _showAnswer = false;
    });
    _flipController.value = 0.0;

    try {
      final queryParameters = _buildQueryParameters();
      final response = await Amplify.API.get(
        '/items/random',
        apiName: 'flashcardsApi',
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      ).response;
      final body = await response.body.transform(utf8.decoder).join();
      final payload = jsonDecode(body);
      setState(() {
        _question = FlashcardQuestion.fromJson(payload);
      });
    } catch (error) {
      if (error is ApiException) {
        final underlying = error.underlyingException?.toString() ?? '';
        if (underlying.contains('404')) {
          setState(() {
            _question = null;
            _errorMessage = 'No questions found for the selected filters.';
          });
          return;
        }
      }
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchAnswer() async {
    final question = _question;
    if (question == null) {
      setState(() => _errorMessage = 'Load a question first.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await Amplify.API.get(
        '/items/${question.id}/answer',
        apiName: 'flashcardsApi',
      ).response;
      final body = await response.body.transform(utf8.decoder).join();
      final payload = jsonDecode(body);
      setState(() {
        _answer = FlashcardAnswer.fromJson(payload);
        _showAnswer = true;
      });
      _flipController.forward();
    } catch (error) {
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleAnswer() {
    if (_showAnswer) {
      setState(() => _showAnswer = false);
      _flipController.reverse();
      return;
    }

    if (_answer != null) {
      setState(() => _showAnswer = true);
      _flipController.forward();
      return;
    }

    _fetchAnswer();
  }

  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut();
      widget.onSignedOut();
    } catch (error) {
      setState(() => _errorMessage = error.toString());
    }
  }

  Future<void> _openBlog() async {
    final uri = Uri.parse('https://aws-sensei.cloud');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _normalizeMarkdown(String text) {
    return text
        .replaceAll('[code]', '```\n')
        .replaceAll('[/code]', '\n```');
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = _question;
    final answer = _answer;
    final hasQuestion = question != null;
    final showAnswer = _showAnswer && answer != null;

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          IconButton(
            tooltip: 'AWS Sensei',
            onPressed: _openBlog,
            icon: const Icon(Icons.language),
          ),
          IconButton(
            tooltip: 'Switch theme',
            onPressed: () => widget.onToggleTheme(
              Theme.of(context).brightness,
            ),
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
          TextButton(
            onPressed: _signOut,
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 520;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: isNarrow
                              ? double.infinity
                              : (constraints.maxWidth - 24) / 2,
                          child: DropdownButtonFormField<String>(
                            value: _selectedCareer,
                            decoration:
                                const InputDecoration(labelText: 'Career'),
                            isExpanded: true,
                            selectedItemBuilder: (context) => const [
                              Text(
                                'Developer Associate',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Architect Associate',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            items: const [
                              DropdownMenuItem(
                                value: 'Developer Associate',
                                child: Text(
                                  'Developer Associate',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Architect Associate',
                                child: Text(
                                  'Architect Associate',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            onChanged: _isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedCareer = value;
                                      final options = _subjectOptions();
                                      if (_selectedSubject != null &&
                                          !options.contains(_selectedSubject)) {
                                        _selectedSubject = null;
                                      }
                                    });
                                  },
                          ),
                        ),
                        SizedBox(
                          width: isNarrow
                              ? double.infinity
                              : (constraints.maxWidth - 24) / 2,
                          child: DropdownButtonFormField<String>(
                            value: _selectedSubject,
                            decoration:
                                const InputDecoration(labelText: 'Subject'),
                            isExpanded: true,
                            items: _subjectOptions()
                                .map(
                                  (subject) => DropdownMenuItem(
                                    value: subject,
                                    child: Text(
                                      subject,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: _isLoading
                                ? null
                                : (value) {
                                    setState(() => _selectedSubject = value);
                                  },
                          ),
                        ),
                        SizedBox(
                          width: isNarrow ? double.infinity : null,
                          child: OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    setState(() {
                                      _selectedSubject = null;
                                      _selectedCareer = null;
                                    });
                                    _fetchRandomQuestion();
                                  },
                            child: const Text('Clear'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                CheckboxListTile(
                  value: _showMultipleChoice,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Show multiple choice'),
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _showMultipleChoice = value ?? false;
                          });
                        },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Daily flashcard',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      IconButton(
                        onPressed: _isLoading ? null : _fetchRandomQuestion,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Next card',
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  if (question != null)
                    MouseRegion(
                      cursor: _isLoading
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _isLoading ? null : _toggleAnswer,
                        child: AnimatedBuilder(
                          animation: _flipController,
                          builder: (context, child) {
                            final rotation = _flipController.value * pi;
                            final isBack = rotation > (pi / 2);
                            final displayAnswer = showAnswer && answer != null;
                            final faceCareer =
                                isBack ? answer?.career : question.career;
                            final faceSubject =
                                isBack ? answer?.subject : question.subject;
                            final isQuestionFace = !isBack;
                            final faceText = isBack
                                ? (displayAnswer
                                    ? answer.answer
                                    : 'Loading answer...')
                                : question.question;
                            final faceMarkdown = _normalizeMarkdown(faceText);
                            final multipleChoice = question.multipleChoice;
                            final showMultipleChoice = isQuestionFace &&
                                _showMultipleChoice &&
                                multipleChoice != null &&
                                multipleChoice.trim().isNotEmpty;
                            final multipleChoiceMarkdown = showMultipleChoice
                                ? _normalizeMarkdown(multipleChoice)
                                : null;
                            final hasCodeBlock = multipleChoiceMarkdown != null &&
                                multipleChoiceMarkdown.contains('```');
                            final multipleChoiceLines = showMultipleChoice &&
                                    !hasCodeBlock
                                ? multipleChoiceMarkdown!
                                    .split('\n')
                                    .where((line) => line.trim().isNotEmpty)
                                    .toList()
                                : const <String>[];
                            final multipleChoiceListMarkdown =
                                showMultipleChoice && !hasCodeBlock
                                    ? multipleChoiceLines
                                        .map((line) => '- $line')
                                        .join('\n')
                                    : multipleChoiceMarkdown;
                            final questionMarkdownStyle =
                                MarkdownStyleSheet.fromTheme(
                              Theme.of(context),
                            ).copyWith(
                              p: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(height: 1.4),
                              code: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    height: 1.4,
                                    fontFamily: 'monospace',
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                  ),
                            );
                            final choiceMarkdownStyle =
                                MarkdownStyleSheet.fromTheme(
                              Theme.of(context),
                            ).copyWith(
                              code: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontFamily: 'monospace',
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                  ),
                            );
                            final cardContent = Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      if (faceCareer != null)
                                        MetaChip(
                                          label: 'Career: $faceCareer',
                                        ),
                                      if (faceSubject != null)
                                        MetaChip(
                                          label: 'Subject: $faceSubject',
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  MarkdownBody(
                                    data: faceMarkdown,
                                    styleSheet: questionMarkdownStyle,
                                    onTapLink: (text, href, title) {
                                      if (href == null) {
                                        return;
                                      }
                                      launchUrl(
                                        Uri.parse(href),
                                        mode: LaunchMode.externalApplication,
                                      );
                                    },
                                  ),
                                  if (showMultipleChoice) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      'Multiple choice',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (multipleChoiceListMarkdown != null)
                                      MarkdownBody(
                                        data: multipleChoiceListMarkdown,
                                        styleSheet: choiceMarkdownStyle,
                                      ),
                                  ],
                                ],
                              ),
                            );

                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(rotation),
                              child: Card(
                                color: isBack
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : null,
                                child: isBack
                                    ? Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(pi),
                                        child: cardContent,
                                      )
                                    : cardContent,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  const SizedBox(height: 20),
                  const SizedBox(height: 8),
                  if (_isLoading) ...[
                    const SizedBox(height: 16),
                    const SkeletonLine(widthFactor: 0.7),
                    const SizedBox(height: 8),
                    const SkeletonLine(widthFactor: 0.5),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
