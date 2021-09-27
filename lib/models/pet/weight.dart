class Weight {
  double value;
  DateTime date;

  Weight({
    required this.value,
    required this.date,
  });

  factory Weight.fromJson(Map<String, dynamic> json) => Weight(
        value: double.parse(json["value"].toString()),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {'value': value, 'date': date.toString()};
}
