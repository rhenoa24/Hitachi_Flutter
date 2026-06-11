class Brand {
  final String name;
  final String logoUrl;
  final String webUrl;

  Brand({
    required this.name,
    required this.logoUrl,
    required this.webUrl,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      webUrl: json['webUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logoUrl': logoUrl,
      'webUrl': webUrl,
    };
  }
}
