class FetchPosts {
  final int id;
  final String title;
  final String body;
  final int userId;

  FetchPosts({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });
}

class FetchPostsModel extends FetchPosts {
  FetchPostsModel({
    required super.id,
    required super.title,
    required super.userId,
    required super.body,
  });

  factory FetchPostsModel.fromJson(Map<String, dynamic> json) {
    return FetchPostsModel(
      id: json["id"],
      title: json["title"],
      body: json["body"],
      userId: json["userId"],
    );
  }
}
