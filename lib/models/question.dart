class Question {
  final int id;
  final int bookId;
  final int pageNumber;
  final String type;
  final String question;
  final List<String> options;
  final int answerIndex;

  Question({
    required this.id,
    required this.bookId,
    required this.pageNumber,
    required this.type,
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      bookId: json['book'] ?? 0,
      pageNumber: json['page'] ?? 1,
      type: json['type'] ?? 'choice',                 
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      answerIndex: json['answer_index'] ?? -1,
    );
}
}