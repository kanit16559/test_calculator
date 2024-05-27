import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_calculator/models/calculator/keyboard_model.dart';
import 'package:test_calculator/view_models/calculator/calculator_viewmodel.dart';

import '../../../core/app_injection.dart';
import 'circlebutton_widget.dart';

class KeyBoardNumBerWidget extends StatelessWidget {

  KeyBoardNumBerWidget({super.key, required this.controller});

  final CalculatorViewModel controller;

  final List<KeyboardModel> labelTypeList = [
    KeyboardModel(
        type: LabelType.clear,
        label: 'C'
    ),
    KeyboardModel(
        type: LabelType.empty,
        label: '-+'
    ),
    KeyboardModel(
        type: LabelType.empty,
        label: '%'
    ),
    KeyboardModel(
        type: LabelType.divide,
        label: '/'
    ),

    KeyboardModel(
      type: LabelType.seven,
      label: '7'
    ),
    KeyboardModel(
        type: LabelType.eight,
        label: '8'
    ),
    KeyboardModel(
        type: LabelType.nine,
        label: '9'
    ),
    KeyboardModel(
        type: LabelType.multiply,
        label: 'x'
    ),

    KeyboardModel(
        type: LabelType.four,
        label: '4'
    ),
    KeyboardModel(
        type: LabelType.five,
        label: '5'
    ),
    KeyboardModel(
        type: LabelType.six,
        label: '6'
    ),
    KeyboardModel(
        type: LabelType.subtract,
        label: '-'
    ),

    KeyboardModel(
        type: LabelType.one,
        label: '1'
    ),
    KeyboardModel(
        type: LabelType.two,
        label: '2'
    ),
    KeyboardModel(
        type: LabelType.three,
        label: '3'
    ),
    KeyboardModel(
        type: LabelType.add,
        label: '+'
    ),

    KeyboardModel(
        type: LabelType.zero,
        label: '0'
    ),
    KeyboardModel(
        type: LabelType.point,
        label: '.'
    ),
    KeyboardModel(
        type: LabelType.empty,
        label: '?'
    ),
    KeyboardModel(
        type: LabelType.equal,
        label: '='
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: buildButton(),
      )
    );
  }


  List<Widget> buildButton(){
    const int rows = 5;
    const int columns = 4;
    int currentIndex = 0;
    List<Widget> listWidget = [];

    for (int i = 0; i < rows; i++) {
      List<Widget> rowList = [];
      for (int j = 0; j < columns; j++) {
        final keyboardModel = labelTypeList[currentIndex];
        late Widget circleButton;
        if(controller.isSign(keyboardModel) == true){
          circleButton = StreamBuilder<bool>(
            stream: controller.getBehaviorSign(keyboardModel),
            builder: (context, snapshot) {
              return circleButton = CircleButton(
                onTap: (){
                  controller.onTapInput(keyboardModel);
                },
                label: keyboardModel.label,
                isNumber: controller.isNumber(keyboardModel),
                isSign: snapshot.data ?? false,
              );
            }
          );
        }else{
          circleButton = CircleButton(
            onTap: (){
              controller.onTapInput(keyboardModel);
            },
            label: keyboardModel.label,
            isNumber: controller.isNumber(keyboardModel),
            isSign: false,
          );
        }

        rowList.add(
          Expanded(
            child: circleButton
          )
        );

        currentIndex++;
      }

      Row row = Row(
        children: rowList,
      );

      listWidget.add(const SizedBox(
        height: 8
      ));
      listWidget.add(Expanded(child: row));
    }

    return listWidget;
  }

}
