import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pets_weight_graph/cubit/pet_cubit.dart';
import 'package:pets_weight_graph/data/network/constants/endpoints.dart';
import 'package:pets_weight_graph/models/pet/pet.dart';
import 'package:pets_weight_graph/models/pet/weight.dart';
import 'package:pets_weight_graph/ui/weight_graph/graph_painter.dart';

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
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  //Widgets------------------------------------------
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      actions: [],
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildBlocBuilder(),
          _buildAddWeightButton(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Text(
        "Weight Graph",
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildAddWeightButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: 160,
          height: 40.0,
          child: ElevatedButton(
            onPressed: () {
              _buildBottomSheet();
            },
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Color(0xffffa04c),
                  size: 30,
                ),
                Text(
                  ' Weight',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xffffa04c).withOpacity(0.2),
              onPrimary: Color(0xffffa04c),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
            ),
          ),
        )
      ],
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
        cursorColor: Colors.white30,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Click and select the date",
          hintStyle: TextStyle(color: Colors.white30),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: MediaQuery.of(context).size.width - 60,
      height: 50.0,
      child: ElevatedButton(
        onPressed: () {
          if (DateTime.tryParse(_control.text) != null &&
              _selectedWeight > 0.0) {
            Navigator.pop(context);
            _pet!.weights
                .add(new Weight(date: _selectedDate, value: _selectedWeight));
            BlocProvider.of<PetCubit>(context).patchPet(_pet!);
          }
        },
        child: Text(
          ' ADD',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(0xffffa04c).withOpacity(0.2),
          onPrimary: Color(0xffffa04c),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
        ),
      ),
    );
  }

  void _buildBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.black,
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
                          color: Colors.white60,
                        ),
                      ),
                      DecimalNumberPicker(
                        value: _selectedWeight,
                        textStyle: TextStyle(color: Colors.white),
                        selectedTextStyle: TextStyle(
                            color: Colors.white,
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
                          color: Colors.white60,
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildDatePickerButton(),
                      SizedBox(height: 30),
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
      color: Colors.black,
      border: Border.all(
          color: Colors.white30, // border color
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
                style: TextStyle(color: Colors.white),
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
            color: Colors.red,
            child: CustomPaint(
                painter: GraphPainter(_pet!),
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
            style: TextStyle(color: Colors.white),
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
        lastDate: DateTime(2101));
    if (picked != null && picked != _control.text) _selectedDate = picked;
    setState(() {
      _control.text = "${picked!.month}/${picked.day}/${picked.year}";
    });
  }
}
