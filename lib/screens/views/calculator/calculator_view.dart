import 'package:flutter/material.dart';

import '../../../core/app_injection.dart';
import '../../../view_models/calculator/calculator_viewmodel.dart';
import '../../../view_models/calculator/state/sum_state.dart';
import '../../widgets/calculator/keyboardnumber_widget.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  late CalculatorViewModel controller;
  @override
  void initState() {
    controller = AppInjections.internal.getItInstance<CalculatorViewModel>();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Calculator"
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: StreamBuilder<SumState>(
                stream: controller.sumBehavior,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    final data = snapshot.data;
                    bool isShowMainNumber = controller.isShowMainNumber.value;
                    String? strText = isShowMainNumber == true ? data?.mainNumber : data?.number;
                    // print('===== isShowMainNumber : ${isShowMainNumber}');
                    // print('===== data.mainNumber : ${data?.mainNumber}');
                    // print('===== data.number : ${data?.number}');
                    // print('===== data.typeSign : ${data?.typeSign}');
                    // print('-------------------------------------');
                    return Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        controller.formatNumber(strText ?? "0"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 70
                        ),
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }
              )
            ),
            KeyBoardNumBerWidget(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
