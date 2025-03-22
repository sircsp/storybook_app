class Book {
  final int id;
  final String title;
  final String description;
  final String coverImage;
  final String pdfFile;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.pdfFile,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      coverImage: json['cover_image'],
      pdfFile: json['pdf_file'],
    );
  }
}