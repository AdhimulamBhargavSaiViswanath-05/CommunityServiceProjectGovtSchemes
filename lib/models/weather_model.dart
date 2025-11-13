class WeatherModel {
  final String description;
  final double temperature;
  final String city;
  final String country;
  final String icon;

  WeatherModel({
    required this.description,
    required this.temperature,
    required this.city,
    required this.country,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      description: json['weather']?[0]['description'] ?? '',
      temperature: (json['main']?['temp']?.toDouble() ?? 0.0),
      city: json['name'] ?? '',
      country: json['sys']?['country'] ?? '',
      icon: json['weather']?[0]['icon'] ?? '',
    );
  }
}
