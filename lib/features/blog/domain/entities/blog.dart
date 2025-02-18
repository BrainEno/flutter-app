class Blog {
  final String id;
  final String title;
  final String content;
  final String posterId;
  final String imageUrl;
  final List<String> tags;
  final DateTime updatedAt;

  Blog(
      {required this.id,
      required this.title,
      required this.content,
      required this.posterId,
      required this.imageUrl,
      required this.tags,
      required this.updatedAt});
}
