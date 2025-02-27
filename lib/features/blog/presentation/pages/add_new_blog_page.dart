import 'dart:io';

import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/common/widgets/loader.dart';
import 'package:belog/core/theme/app_pallete.dart';
import 'package:belog/core/utils/pick_image.dart';
import 'package:belog/core/utils/show_snackbar.dart';
import 'package:belog/features/blog/presentation/bloc/listedBlogs/bloc/blog_bloc.dart';
import 'package:belog/features/blog/presentation/pages/blog_page.dart';
import 'package:belog/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final formKey = GlobalKey<FormState>();
  List<String> selectedTags = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTags.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(BlogUpload(
          image: image!,
          title: titleControler.text.trim(),
          content: contentControler.text.trim(),
          posterId: posterId,
          tags: selectedTags));
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleControler.dispose();
    contentControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode ? AppPallete.blackColor : AppPallete.lightBackground,
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? AppPallete.blackColor : AppPallete.lightBackground,
        elevation: 0,
        iconTheme: IconThemeData(
            color: isDarkMode ? AppPallete.whiteColor : AppPallete.lightBlack),
        title: Text(
          '撰写新文章', // "Write new article" in Chinese
          style: TextStyle(
            color: isDarkMode ? AppPallete.whiteColor : AppPallete.lightBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center the title for Medium-like style
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton(
              onPressed: () {
                uploadBlog();
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    isDarkMode ? AppPallete.whiteColor : AppPallete.lightBlack,
                textStyle: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              child: const Text('发布'),
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogUploadFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            showSnackBar(context, '上传成功');
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogUploadLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical:
                      20.0), // Adjusted horizontal padding, consistent vertical
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      child: image != null
                          ? SizedBox(
                              height:
                                  250, // Increased image height for better visual impact
                              width: double.infinity,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      12), // Slightly more rounded image corners
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  )),
                            )
                          : DottedBorder(
                              color: isDarkMode
                                  ? AppPallete.greyColorLight
                                      .withAlpha((0.6 * 255).toInt())
                                  : AppPallete.lightBorder.withAlpha((0.8 * 255)
                                      .toInt()), // More subtle dotted border
                              radius: const Radius.circular(
                                  12), // More rounded dotted border corners
                              borderType: BorderType.RRect,
                              dashPattern: const [6, 3], // Finer dash pattern
                              strokeCap: StrokeCap.round,
                              child: Container(
                                height: 250, // Increased height of dotted area
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isDarkMode
                                      ? AppPallete.blackColorLight
                                          .withAlpha((0.3 * 255).toInt())
                                      : AppPallete.lightGrey.withAlpha((0.15 *
                                              255)
                                          .toInt()), // Even more subtle background for dotted area
                                ),
                                child: Center(
                                  // Center content within dotted border using Center widget
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        size: 55, // Slightly larger icon
                                        color: isDarkMode
                                            ? AppPallete.greyColor
                                            : AppPallete.lightGreyText,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        '点击上传封面', // "Click to upload cover" - more interactive text
                                        style: TextStyle(
                                            fontSize:
                                                17, // Slightly larger upload text
                                            fontWeight: FontWeight
                                                .w500, // Medium font weight for upload text
                                            color: isDarkMode
                                                ? AppPallete.greyColor
                                                : AppPallete.lightGreyText),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                    ),
                    const SizedBox(
                        height: 36), // Increased spacing below image area
                    Wrap(
                      spacing: 10.0, // Slightly increased spacing between chips
                      runSpacing: 10.0, // Slightly increased row spacing
                      children: ["诗歌", "小说", "原创", "其他"]
                          .map((e) => InputChip(
                                label: Text(e,
                                    style: TextStyle(
                                        fontSize:
                                            15, // Slightly reduced tag font size
                                        fontWeight: FontWeight
                                            .w500, // Medium font weight for tags
                                        color: selectedTags.contains(e)
                                            ? AppPallete.whiteColor
                                            : isDarkMode
                                                ? AppPallete.whiteColor
                                                : AppPallete.lightBlack)),
                                selected: selectedTags.contains(e),
                                elevation: 0,
                                showCheckmark: false,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 12.0), // Adjusted chip padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25), // More rounded tag chips (pill-shaped)
                                  side: BorderSide(
                                      color: isDarkMode
                                          ? AppPallete.greyColorLight
                                              .withAlpha((0.7 * 255).toInt())
                                          : AppPallete.lightBorder.withAlpha((0.7 *
                                                  255)
                                              .toInt())), // More subtle tag border
                                ),
                                backgroundColor: isDarkMode
                                    ? AppPallete.blackColorLight
                                        .withAlpha((0.6 * 255).toInt())
                                    : AppPallete.lightGrey.withAlpha((0.4 * 255)
                                        .toInt()), // More subtle tag background
                                selectedColor: AppPallete.gradient1.withAlpha(
                                    (0.9 * 255)
                                        .toInt()), // Slightly less opaque selected tag gradient
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight
                                        .w500, // Medium font weight for tag labels
                                    color: selectedTags.contains(e)
                                        ? AppPallete.blackColor
                                        : null // Selected tag label color
                                    ),
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedTags.add(e);
                                    } else {
                                      selectedTags.remove(e);
                                    }
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 40), // Increased spacing below tags
                    BlogEditor(
                      controller: titleControler,
                      hintText: '标题',
                      contentType: BlogEditorContentType.title,
                    ),
                    const SizedBox(height: 30), // Increased spacing below title
                    BlogEditor(
                      controller: contentControler,
                      hintText: '正文',
                      maxLines: null,
                      expands: true,
                      contentType: BlogEditorContentType.body,
                    ),
                    const SizedBox(height: 60), // Increased bottom spacing
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
