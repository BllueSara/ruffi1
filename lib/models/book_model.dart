class BookModel {
  final String id;
  final String title;
  final String? subtitle;
  final List<String> authors;
  final String? publisher;
  final String? publishedDate;
  final String? description;
  final String? thumbnail;
  final String? previewLink;
  final String? infoLink;
  final int? pageCount;
  final List<String> categories;
  final double? averageRating;
  final int? ratingsCount;
  final String? language;

  BookModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.thumbnail,
    this.previewLink,
    this.infoLink,
    this.pageCount,
    this.categories = const [],
    this.averageRating,
    this.ratingsCount,
    this.language,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    
    return BookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'عنوان غير محدد',
      subtitle: volumeInfo['subtitle'],
      authors: List<String>.from(volumeInfo['authors'] ?? []),
      publisher: volumeInfo['publisher'],
      publishedDate: volumeInfo['publishedDate'],
      description: volumeInfo['description'],
      thumbnail: imageLinks['thumbnail']?.replaceAll('http:', 'https:'),
      previewLink: json['accessInfo']?['webReaderLink'],
      infoLink: json['volumeInfo']?['infoLink'],
      pageCount: volumeInfo['pageCount'],
      categories: List<String>.from(volumeInfo['categories'] ?? []),
      averageRating: volumeInfo['averageRating']?.toDouble(),
      ratingsCount: volumeInfo['ratingsCount'],
      language: volumeInfo['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'authors': authors,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'description': description,
      'thumbnail': thumbnail,
      'previewLink': previewLink,
      'infoLink': infoLink,
      'pageCount': pageCount,
      'categories': categories,
      'averageRating': averageRating,
      'ratingsCount': ratingsCount,
      'language': language,
    };
  }

  @override
  String toString() {
    return 'BookModel(id: $id, title: $title, authors: $authors)';
  }
}
