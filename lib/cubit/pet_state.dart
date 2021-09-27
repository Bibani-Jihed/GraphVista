part of 'pet_cubit.dart';

@immutable
abstract class PetState {}


class PetInitial extends PetState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PetInitial &&
              runtimeType == other.runtimeType;
}

class PetLoaded extends PetState {
  final Pet pet;
  PetLoaded({required this.pet});

  //used to succeed bloc_test
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PetLoaded &&
              runtimeType == other.runtimeType  &&
              pet == other.pet ;
}
class PetErrorState extends PetState {
  final message;

  PetErrorState({this.message});
}
