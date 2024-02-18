class SurahModel {
  late final int number;
  late final String name;
  late final String englishName;
  late final String englishNameTranslation;
  late final int numberOfAyahs;
  late final String revelationType;
  late final String url;

  SurahModel({
    required this.number,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.url,
    required this.name,
  });

  factory SurahModel.fromJson(Map<String, dynamic> jsonData) {
    return SurahModel(
      number: jsonData['number'],
      englishName: jsonData['englishName'],
      englishNameTranslation: jsonData['englishNameTranslation'],
      numberOfAyahs: jsonData['numberOfAyahs'],
      revelationType: jsonData['revelationType'],
      url: jsonData['url'],
      name: jsonData['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'numberOfAyahs': numberOfAyahs,
      'revelationType': revelationType,
      'url': url,
      'name': name,
    };
  }
}
