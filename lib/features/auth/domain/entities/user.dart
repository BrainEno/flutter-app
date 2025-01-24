class User {
  final String id;
  final String email;
  final String name;
  final String avartarUrl;

  User(
      {required this.id,
      required this.email,
      required this.name,
      this.avartarUrl = ""});
}
