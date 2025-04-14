class Recommendation {
  String content;
  String diabetesType;
  String country;

  Recommendation({
    required this.content,
    required this.diabetesType,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'diabetesType': diabetesType,
      'country': country,
    };
  }

  static Recommendation fromJson(Map<String, dynamic> json) {
    return Recommendation(
      content: json['content'],
      diabetesType: json['diabetesType'],
      country: json['country'],
    );
  }
}
