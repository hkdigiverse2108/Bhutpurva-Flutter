class TithiCalenderModel {
  final String id;
  final int year;
  final List<CalenderMonthModel> calender;

  TithiCalenderModel({
    required this.id,
    required this.year,
    required this.calender,
  });

  factory TithiCalenderModel.fromJson(Map<String, dynamic> json) {
    return TithiCalenderModel(
      id: json['_id']?.toString() ?? '',
      year: json['year'] is int
          ? json['year']
          : int.tryParse(json['year']?.toString() ?? '') ?? DateTime.now().year,
      calender:
          (json['calender'] as List?)
              ?.map(
                (e) => CalenderMonthModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'year': year,
      'calender': calender.map((e) => e.toJson()).toList(),
    };
  }
}

class CalenderMonthModel {
  final String month;
  final String image;

  CalenderMonthModel({required this.month, required this.image});

  factory CalenderMonthModel.fromJson(Map<String, dynamic> json) {
    return CalenderMonthModel(
      month: json['month'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'month': month, 'image': image};
  }
}
