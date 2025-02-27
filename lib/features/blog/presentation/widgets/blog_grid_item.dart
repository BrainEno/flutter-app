import 'package:belog/core/utils/extract_description.dart';
import 'package:flutter/material.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';

class BlogGridItem extends StatelessWidget {
  final Blog blog;
  final VoidCallback onTap;

  const BlogGridItem({super.key, required this.blog, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final description = extractDescription(blog.content);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            children: [
              // Background image with gradient overlay
              Positioned.fill(
                child: blog.imageUrl.isNotEmpty
                    ? Image.network(
                        blog.imageUrl,
                        fit: BoxFit.cover,
                        color: Colors.black.withAlpha((0.3 * 255).toInt()),
                        colorBlendMode: BlendMode.darken,
                      )
                    : Container(color: Colors.grey[300]),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      blog.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white70,
                      ),
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Poster info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: blog.posterAvatar != null
                              ? NetworkImage(blog.posterAvatar!)
                              : null,
                          child: blog.posterAvatar == null
                              ? const Icon(Icons.person, size: 12)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          blog.posterName ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Date
                    Text(
                      blog.updatedAt.toString().substring(0, 10),
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
