class FlashcardQuestion {
  FlashcardQuestion({
    required this.id,
    required this.locale,
    required this.question,
    this.career,
    this.subject,
    this.multipleChoice,
  });

  final String id;
  final String locale;
  final String question;
  final String? career;
  final String? subject;
  final String? multipleChoice;

  factory FlashcardQuestion.fromJson(Map<String, dynamic> json) {
    return FlashcardQuestion(
      id: json['id'] as String,
      locale: json['locale'] as String? ?? 'en',
      question: json['question'] as String,
      career: json['career'] as String?,
      subject: json['subject'] as String?,
      multipleChoice: json['multiple_choice'] as String?,
    );
  }
}

class FlashcardAnswer {
  FlashcardAnswer({
    required this.id,
    required this.locale,
    required this.answer,
    this.career,
    this.subject,
  });

  final String id;
  final String locale;
  final String answer;
  final String? career;
  final String? subject;

  factory FlashcardAnswer.fromJson(Map<String, dynamic> json) {
    return FlashcardAnswer(
      id: json['id'] as String,
      locale: json['locale'] as String? ?? 'en',
      answer: json['answer'] as String,
      career: json['career'] as String?,
      subject: json['subject'] as String?,
    );
  }
}
