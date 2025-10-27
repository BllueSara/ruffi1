class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final List<String> favoriteBooks;
  final List<String> readingHistory;
  final DateTime? lastLoginDate;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.favoriteBooks = const [],
    this.readingHistory = const [],
    this.lastLoginDate,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      favoriteBooks: List<String>.from(json['favoriteBooks'] ?? []),
      readingHistory: List<String>.from(json['readingHistory'] ?? []),
      lastLoginDate: json['lastLoginDate'] != null 
          ? DateTime.parse(json['lastLoginDate']) 
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'favoriteBooks': favoriteBooks,
      'readingHistory': readingHistory,
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    List<String>? favoriteBooks,
    List<String>? readingHistory,
    DateTime? lastLoginDate,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      favoriteBooks: favoriteBooks ?? this.favoriteBooks,
      readingHistory: readingHistory ?? this.readingHistory,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email)';
  }
}
