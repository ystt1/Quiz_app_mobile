class CommentPayloadModal {
  final String? post;
  final String? idQuiz;
  final String parent;
  final String content;
  final String sortType;
  CommentPayloadModal({
    this.post,
    this.idQuiz,
    required this.parent,
    required this.content,
    required this.sortType
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'content': content,
    };

    if (post != null) {
      data['post'] = post;
    } else if (idQuiz != null) {
      data['quiz'] = idQuiz;
    }

    if (parent.isNotEmpty) {
      data['parent'] = parent;
    }

    return data;
  }
}
