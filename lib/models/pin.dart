class Pin {
  String id;
  String title;
  String content;
  List<String> tags;

  Pin({required this.id, required this.title, required this.content, required this.tags});

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'tags': tags,
  };

  factory Pin.fromJson(Map<String, dynamic> json) => Pin(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    tags: List<String>.from(json['tags']),
  );
}
