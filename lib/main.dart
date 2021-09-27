import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_weight_graph/cubit/pet_cubit.dart';
import 'package:pets_weight_graph/data/network/rest_client.dart';
import 'package:pets_weight_graph/data/repositories/pet_repository/i_pet_repository.dart';
import 'package:pets_weight_graph/data/repositories/pet_repository/pet_repository.dart';
import 'data/network/apis/pets/pets_api.dart';
import 'file:///C:/Users/ASUS/AndroidStudioProjects/pets_weight_graph/lib/ui/weight_graph/weight_graph.dart';

import 'constants/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    IPetRepository petRepository=PetRepository(PetsApi(RestClient()));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: AppColors.primaryBlack,
          scaffoldBackgroundColor: Colors.black
      ),
      home: BlocProvider(
          create: (BuildContext context) => PetCubit(petRepository),
          child: WeightGraph()),

    );
  }
}


