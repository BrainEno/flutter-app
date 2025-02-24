import 'package:flutter/material.dart';

class SavedBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const SavedBlogPage());
  const SavedBlogPage({super.key});

  @override
  State<SavedBlogPage> createState() => _SavedBlogPageState();
}

class _SavedBlogPageState extends State<SavedBlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: const Text('no saved blog yet'));
  }
}
