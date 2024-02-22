class KnowledgeAnswer {
  final String source;
  final String faqQuestion;
  final String answer;
  final String matchConfidenceLevel;
  final double matchConfidence;

  KnowledgeAnswer({
    required this.source,
    required this.faqQuestion,
    required this.answer,
    required this.matchConfidenceLevel,
    required this.matchConfidence,
  });

  factory KnowledgeAnswer.fromJson(Map<String, dynamic> json) {
    return KnowledgeAnswer(
      source: json['source'],
      faqQuestion: json['faqQuestion'],
      answer: json['answer'],
      matchConfidenceLevel: json['matchConfidenceLevel'],
      matchConfidence: json['matchConfidence'],
    );
  }
}

class KnowledgeAnswers {
  final List<KnowledgeAnswer> answers;

  KnowledgeAnswers({required this.answers});

  factory KnowledgeAnswers.fromJson(Map<String, dynamic> json) {
    var list = json['answers'] as List;
    List<KnowledgeAnswer> answerList =
    list.map((e) => KnowledgeAnswer.fromJson(e)).toList();

    return KnowledgeAnswers(answers: answerList);
  }
}
