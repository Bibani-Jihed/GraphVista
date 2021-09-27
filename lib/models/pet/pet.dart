import 'dart:convert';

import 'package:pets_weight_graph/models/pet/weight.dart';

class Pet {
  String id;
  List<Weight> weights;

  Pet({
    required this.id,
    required this.weights,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
      weights: (json['weights'] as List)
          .map((data) => new Weight.fromJson(data))
          .toList(),
      id: json['id']);


  Map<String, dynamic> toJson() => {'id': id, 'weights': weights.map((e) => e.toJson()).toList()};
}
