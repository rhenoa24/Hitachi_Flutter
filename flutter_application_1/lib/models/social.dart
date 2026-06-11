class Social {
  final String name;
  final String history;
  final String iconUrl;
  final String imgUrl;
  final String webUrl;

  Social({
    required this.name,
    required this.history,
    required this.iconUrl,
    required this.imgUrl,
    required this.webUrl,
  });

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      name: json['name'] as String,
      history: json['history'] as String,
      iconUrl: json['iconUrl'] as String,
      imgUrl: json['imgUrl'] as String,
      webUrl: json['webUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'history': history,
      'iconUrl': iconUrl,
      'imgUrl': imgUrl,
      'webUrl': webUrl,
    };
  }
}
