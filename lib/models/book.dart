class Book {
  final int id;
  final String title;
  final String description;
  final String coverImage;
  final String pdfFile;
  final int ageGroup;
  final bool doublePage;
  final String bookSlug;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.pdfFile,
    required this.ageGroup,
    required this.doublePage,
    required this.bookSlug,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      coverImage: json['cover_image'],
      pdfFile: json['pdf_file'],
      ageGroup: json['age_group'],
      doublePage: json['double_page'] ?? false,
      bookSlug: json['slug'] ?? '',
    );
  }
}