import 'package:flutter/material.dart';

class PostTab extends StatelessWidget {
  PostTab({super.key});

  final List<Map<String, dynamic>> posts = List.generate(
    10,
    (index) => {
      "id": index,
      "content": "This is a sample post content $index.",
      "image": index % 2 == 0 ? "https://via.placeholder.com/150" : null,
      "likes": index * 2,
      "comments": List.generate(
        index,
        (i) => {
          "user": "User $i",
          "comment": "This is comment $i",
          "time": "${i + 1} minutes ago",
          "likes": 0,
          "replies": [],
          "avatar": "https://via.placeholder.com/50", // Dummy avatar URL
        },
      ),
    },
  );

  void _showCommentsModal(BuildContext context, Map<String, dynamic> post) {
    TextEditingController commentController = TextEditingController();
    Map<String, dynamic>? replyingTo;

    void setReplyingTo(Map<String, dynamic>? comment) {
      replyingTo = comment;
      (context as Element).markNeedsBuild(); // Rebuild modal to reflect changes
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Comments (${post['comments'].length})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: post['comments'].length,
                      itemBuilder: (context, index) {
                        final comment = post['comments'][index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      comment['avatar'],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment['user'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        comment['time'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                comment['comment'],
                                style: const TextStyle(fontSize: 14),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          comment['likes'] > 0
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            comment['likes']++;
                                          });
                                        },
                                      ),
                                      Text('${comment['likes']}'),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        setReplyingTo(comment);
                                      });
                                    },
                                    child: const Text("Reply"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (replyingTo != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Replying to ${replyingTo!['user']}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                setReplyingTo(null);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      labelText: "Add a comment...",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          if (commentController.text.isNotEmpty) {
                            setState(() {
                              if (replyingTo != null) {
                                replyingTo!['replies'].add({
                                  "user": "You",
                                  "comment": commentController.text,
                                  "time": "Just now",
                                  "likes": 0,
                                  "avatar": "https://via.placeholder.com/50",
                                });
                              } else {
                                post['comments'].add({
                                  "user": "You",
                                  "comment": commentController.text,
                                  "time": "Just now",
                                  "likes": 0,
                                  "replies": [],
                                  "avatar": "https://via.placeholder.com/50",
                                });
                              }
                              commentController.clear();
                              setReplyingTo(null);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '1 hour ago',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  post['content'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                if (post['image'] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "www.cats.org.uk/media/13136/220325case013.jpg"))),
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border,
                              color: Colors.red),
                          onPressed: () {
                            post['likes']++;
                          },
                        ),
                        Text('${post['likes']}'),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _showCommentsModal(context, post),
                      child: Text(
                        'Comments (${post['comments'].length})',
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
