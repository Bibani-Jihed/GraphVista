import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pets_weight_graph/constants/colors.dart';
import 'package:pets_weight_graph/cubit/pet_cubit.dart';
import 'package:pets_weight_graph/data/network/constants/endpoints.dart';
import 'package:pets_weight_graph/models/pet/pet.dart';
import 'package:pets_weight_graph/models/pet/weight.dart';
import 'package:pets_weight_graph/provider/settings.dart';
import 'package:pets_weight_graph/ui/weight_graph/graph_painter.dart';
import 'package:provider/provider.dart';

class WeightGraph extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeightGraphState();
}

class WeightGraphState extends State<WeightGraph> {
  Pet? _pet;
  TextEditingController _control = new TextEditingController();
  DateTime _selectedDate = DateTime.now();
  double _selectedWeight = 0.0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PetCubit>(context).getById(Endpoints.PET_ID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  //Widgets------------------------------------------
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      actions: [
        IconButton(
            onPressed: () {
              changeTheme(
                  Provider.of<Settings>(context, listen: false).isDarkMode
                      ? false
                      : true,
                  context);
            },
            icon: Icon(
              Provider.of<Settings>(context, listen: false).isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.light_mode_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ))
      ],
      title: _buildTitle(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBlocBuilder(),
          _buildAddWeightButton(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      child: Text(
        "Weight Graph",
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 25.0,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildAddWeightButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0),
            backgroundColor: MaterialStateProperty.all<Color>(
                AppColors.ORANGE.withOpacity(0.2)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
          child: Container(
            height: 50,
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: AppColors.ORANGE,
                  size: 30,
                ),
                Text(
                  ' Weight',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ORANGE),
                ),
              ],
            ),
          ),
          onPressed: () {
            _buildBottomSheet();
          },
        ),
      ),
    );
  }

  Widget _buildDatePickerButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      alignment: Alignment.centerLeft,
      height: 50.0,
      decoration: _buildDecoration(),
      child: TextField(
        controller: _control,
        onTap: () {
          _selectDate();
        },
        readOnly: true,
        onChanged: (text) {},
        cursorColor: Theme.of(context).colorScheme.secondary,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Click and select the date",
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0),
            backgroundColor: MaterialStateProperty.all<Color>(
                AppColors.ORANGE.withOpacity(0.2)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'ADD',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ORANGE),
              ),
            ),
          ),
          onPressed: () {
            if (_control.text.isNotEmpty && _selectedWeight > 0.0) {
              Navigator.pop(context);
              _pet!.weights
                  .add(new Weight(date: _selectedDate, value: _selectedWeight));
              BlocProvider.of<PetCubit>(context).patchPet(_pet!);
            }
          },
        ),
      ),
    );

    return GestureDetector(
      onTap: () => {
        if (_control.text.isNotEmpty && _selectedWeight > 0.0)
          {
            Navigator.pop(context),
            _pet!.weights
                .add(new Weight(date: _selectedDate, value: _selectedWeight)),
            BlocProvider.of<PetCubit>(context).patchPet(_pet!),
          }
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.ORANGE.withAlpha(80),
            borderRadius: BorderRadius.all((Radius.circular(25)))),
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Text(
            'ADD',
            style: TextStyle(
                color: AppColors.ORANGE,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  void _buildBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Wrap(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Select your pet weight",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      DecimalNumberPicker(
                        value: _selectedWeight,
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        selectedTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        haptics: true,
                        maxValue: 100,
                        minValue: 0,
                        decimalPlaces: 2,
                        onChanged: (double value) {
                          setModalState(() {
                            _selectedWeight = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Select the date",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildDatePickerButton(),
                      SizedBox(height: 20),
                      _buildAddButton(),
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      border: Border.all(
          color: Theme.of(context).colorScheme.secondary, // border color
          width: 2.0), // border width
      borderRadius:
          BorderRadius.all(Radius.circular(20.0)), // rounded corner radius
    );
  }

  BlocBuilder<PetCubit, PetState> _buildBlocBuilder() {
    return BlocBuilder<PetCubit, PetState>(builder: (context, state) {
      print(state.toString());
      if (state is PetLoaded) {
        _pet = (state as PetLoaded).pet;

        if (_pet!.weights.length < 3) {
          return Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            height: 300,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'You need at least ${3 - _pet!.weights.length} more data points to show the graph',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            height: 300,
            width: _pet!.weights.length * 50,
            color: Theme.of(context).colorScheme.primary,
            child: CustomPaint(
              painter: GraphPainter(_pet!, context),
            ),
          ),
        );
      }
      return Container(
        height: 300,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Fetching data..',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      );
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: Provider.of<Settings>(context, listen: false)
                          .isDarkMode
                      ? ColorScheme.dark(
                          primary: Theme.of(context).colorScheme.secondary,
                          secondary: Theme.of(context).colorScheme.primary)
                      : ColorScheme.light(
                          primary: Theme.of(context).colorScheme.secondary,
                          secondary: Theme.of(context).colorScheme.primary)),
              child: child!);
        });

    if (picked != null && picked != _control.text) {
      _selectedDate = picked;
      setState(() {
        _control.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void changeTheme(bool set, BuildContext context) {
    Provider.of<Settings>(context, listen: false).setDarkMode(set);
  }
}
