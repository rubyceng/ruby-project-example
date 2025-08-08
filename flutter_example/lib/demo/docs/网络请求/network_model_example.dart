class Album {
  final int userId;
  final int id;
  final String title;

  Album({required this.userId, required this.id, required this.title});

  /// 本质上就是一个静态方法
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(userId: json['userId'], id: json['id'], title: json['title']);
  }

  factory Album.fromString(String jsonString) {
    return Album(userId: 1, id: 1, title: 'test');
  }
}
