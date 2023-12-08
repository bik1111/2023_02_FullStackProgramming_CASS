class Comment {
  int commentId;
  String content;
  int contentId;
  int communityId;

  Comment({
    required this.commentId,
    required this.content,
    required this.contentId,
    required this.communityId,
  });

  // Add a copyWith method to create a new Comment with updated values
  Comment copyWith({
    int? commentId,
    String? content,
    int? contentId,
    int? communityId,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      content: content ?? this.content,
      contentId: contentId ?? this.contentId,
      communityId: communityId ?? this.communityId,
    );
  }
}
