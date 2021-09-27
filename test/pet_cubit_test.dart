import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pets_weight_graph/cubit/pet_cubit.dart';
import 'package:pets_weight_graph/data/repositories/pet_repository/i_pet_repository.dart';
import 'package:pets_weight_graph/models/pet/pet.dart';
import 'package:pets_weight_graph/models/pet/weight.dart';

class MockPetRepository extends Mock implements IPetRepository {}

void main() {
  late MockPetRepository petRepository;

  final _pet = Pet(
      id: "614d756d1817433224770ef8",
      weights: [
        Weight(value: 20.1, date: DateTime.parse("2020-07-17")),
        Weight(value: 35.1, date: DateTime.parse("2020-09-22")),
        Weight(value: 42.1, date: DateTime.parse("2020-10-16")),
        Weight(value: 58.1, date: DateTime.parse("2021-02-10")),
      ]
  );

  setUp(() {
    petRepository = MockPetRepository();
  });
  group('Cubit test',(){

    //When Getting The pet first time
    blocTest('emits [PetInitial, PetLoaded] when successful',
        build: () => PetCubit(petRepository),
        act: (PetCubit cubit) {
          when(petRepository.getById("d756d1817433224770ef8")).thenAnswer((_) async => _pet);
          cubit.getById("d756d1817433224770ef8");
        },
        expect: ()=>[PetInitial(),PetLoaded(pet: _pet)]
    );


    //When Patching Pet, adding a new weight
    blocTest('emits [PetLoaded] when successful',
        build: () => PetCubit(petRepository),
        act: (PetCubit cubit) {
          when(petRepository.patch(_pet)).thenAnswer((_) async => _pet);
          cubit.patchPet(_pet);
        },
        expect: ()=>[PetLoaded(pet: _pet)]
    );
  });

}
