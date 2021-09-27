import 'package:pets_weight_graph/models/pet/pet.dart';

abstract class IPetRepository {
  //post
  Future<Pet> add(Pet pet);

  //get
  Future<List<Pet>> getAll();

  Future<Pet>? getById(String id);

  //patch
  Future<Pet?>? patch(Pet pet);
}
