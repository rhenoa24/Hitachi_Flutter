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
      name: (json['name'] ?? json['title'] ?? '').toString(),
      history: (json['history'] ?? json['description'] ?? json['about'] ?? '')
          .toString(),
      iconUrl: (json['iconUrl'] ?? json['icon'] ?? json['logo'] ?? '')
          .toString(),
      imgUrl:
          (json['imgUrl'] ??
                  json['imageUrl'] ??
                  json['image'] ??
                  json['img'] ??
                  '')
              .toString(),
      webUrl: (json['webUrl'] ?? json['url'] ?? json['link'] ?? '').toString(),
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
