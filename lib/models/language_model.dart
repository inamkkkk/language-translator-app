class LanguageModel {
  final String code;
  final String name;

  LanguageModel({required this.code, required this.name});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}