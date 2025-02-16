import 'package:belog/core/theme/app_pallete.dart';
import 'package:belog/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleControler = TextEditingController();
  final contentControler = TextEditingController();
  List<String> selectedTags = [];

  @override
  void dispose() {
    super.dispose();
    titleControler.dispose();
    contentControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DottedBorder(
                  color: AppPallete.borderColor,
                  radius: const Radius.circular(10),
                  borderType: BorderType.RRect,
                  dashPattern: const [10, 4],
                  strokeCap: StrokeCap.round,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image,
                          size: 40,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '上传图片',
                          style: TextStyle(
                              fontSize: 15, color: AppPallete.whiteColor),
                        )
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ["诗歌", "小说", "戏剧", "其他"]
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedTags.contains(e)) {
                                    selectedTags.remove(e);
                                  } else {
                                    selectedTags.add(e);
                                  }

                                  setState(() {});
                                },
                                child: Chip(
                                  label: Text(e),
                                  color: selectedTags.contains(e)
                                      ? const WidgetStatePropertyAll(
                                          AppPallete.gradient2)
                                      : null,
                                  side: selectedTags.contains(e)
                                      ? null
                                      : const BorderSide(
                                          color: AppPallete.borderColor),
                                ),
                              ),
                            ))
                        .toList(),
                  )),
              const SizedBox(height: 10),
              BlogEditor(controller: titleControler, hintText: '标题'),
              const SizedBox(height: 20),
              BlogEditor(controller: contentControler, hintText: '内容')
            ],
          ),
        ),
      ),
    );
  }
}
