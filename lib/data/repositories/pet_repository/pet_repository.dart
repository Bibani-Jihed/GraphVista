import 'package:pets_weight_graph/data/network/apis/pets/pets_api.dart';
import 'package:pets_weight_graph/data/repositories/pet_repository/i_pet_repository.dart';
import 'package:pets_weight_graph/models/pet/pet.dart';

class PetRepository extends IPetRepository{
  final PetsApi _petsApi;

  PetRepository(this._petsApi);

  @override
  Future<Pet> add(Pet pet) => _petsApi.addPet(pet).then((res) => res);

  @override
  Future<List<Pet>> getAll() => _petsApi.getAll().then((res) => res);

  @override
  Future<Pet>? getById(String id)=> _petsApi.getById(id);

  @override
  Future<Pet>? patch(Pet pet) => _petsApi.patchPet(pet);

}