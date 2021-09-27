import 'dart:convert';

import 'package:pets_weight_graph/data/network/constants/endpoints.dart';
import 'package:pets_weight_graph/data/network/rest_client.dart';
import 'package:pets_weight_graph/models/pet/pet.dart';

class PetsApi {
  // rest-client instance
  final RestClient _restClient;

  // injecting instance
  PetsApi(this._restClient);

  //post
  Future<Pet> addPet(Pet pet) {
    return _restClient
        .post(Uri.parse(Endpoints.PETS), body: jsonEncode(pet))
        .then((res) => Pet.fromJson(res));
  }

  //get
  Future<Pet>? getById(String id) {
    return _restClient
        .get(Uri.parse("${Endpoints.PETS}/$id"))
        .then((res) => Pet.fromJson(res))
        .catchError((e) => {
              //throw exception
            });
  }

  Future<List<Pet>> getAll() {
    return _restClient
        .get(
      Uri.parse(Endpoints.PETS),
    )
        .then((res) {
      List<Pet> pets = new List<Pet>.from((res != null && res.isNotEmpty)
          ? res.map((c) => Pet.fromJson(c)).toList()
          : []);
      return pets;
    });
  }

  //patch
  Future<Pet>? patchPet(pet) {
    print(jsonEncode(pet));
    return _restClient
        .patch(Uri.parse("${Endpoints.PETS}/${pet.id}"), body: jsonEncode(pet))
        .then((res) => Pet.fromJson(res));
  }
}
