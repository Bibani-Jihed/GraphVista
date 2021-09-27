import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_weight_graph/data/repositories/pet_repository/i_pet_repository.dart';
import 'package:pets_weight_graph/models/pet/pet.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  PetCubit(this._petRepository) : super(PetInitial());

  final IPetRepository _petRepository;

  Future<Pet?>getById(String id) async {
    try {
      emit(PetInitial());
      _petRepository.getById(id)!.then((pet) {
        if (pet != null)
          emit(PetLoaded(pet: pet));
        else
          emit(PetErrorState(message: "Error while fetching data"));
      });
    } catch (e) {
      emit(PetErrorState(message: e.toString()));
    }
  }
  Future<Pet?>patchPet(Pet pet) async{
    try {
      _petRepository.patch(pet)!.then((pet) {
        if (pet != null)
          emit(PetLoaded(pet: pet));
        else
          emit(PetErrorState(message: "Error while updating data"));
      });
    } catch (e) {
      print(e.toString());
      emit(PetErrorState(message: e.toString()));
    }
  }

}
