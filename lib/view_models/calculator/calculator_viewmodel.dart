
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_calculator/view_models/calculator/state/sum_state.dart';

import '../../core/dispose.dart';
import '../../models/calculator/keyboard_model.dart';

class CalculatorViewModel extends Dispose {

  CalculatorViewModel(){
    initMyState();
  }

  final BehaviorSubject<SumState> _sumBehavior = BehaviorSubject<SumState>();
  final BehaviorSubject<bool> _isShowMainNumber = BehaviorSubject<bool>.seeded(true);
  final BehaviorSubject<bool> _additionBehavior = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _subtractionBehavior = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _multiplicationBehavior = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _divisionBehavior = BehaviorSubject<bool>.seeded(false);

  BehaviorSubject<SumState> get sumBehavior => _sumBehavior;
  BehaviorSubject<bool> get isShowMainNumber => _isShowMainNumber;
  BehaviorSubject<bool> get additionBehavior => _additionBehavior;
  BehaviorSubject<bool> get subtractionBehavior => _subtractionBehavior;
  BehaviorSubject<bool> get multiplicationBehavior => _multiplicationBehavior;
  BehaviorSubject<bool> get divisionBehavior => _divisionBehavior;

  initMyState(){
    _sumBehavior.sink.add(SumState());
  }

  @override
  void dispose() {
    _sumBehavior.close();
    _isShowMainNumber.close();
    _additionBehavior.close();
    _subtractionBehavior.close();
    _multiplicationBehavior.close();
    _divisionBehavior.close();
  }

  BehaviorSubject<bool> getBehaviorSign(KeyboardModel keyboard){
    switch(keyboard.type){
      case LabelType.add :
        return _additionBehavior;
      case LabelType.subtract :
        return _subtractionBehavior;
      case LabelType.multiply:
        return _multiplicationBehavior;
      case LabelType.divide:
        return _divisionBehavior;
      default:
        return _additionBehavior;
    }
  }

  bool isNumber(KeyboardModel keyboard){
    return [
      LabelType.one,
      LabelType.two,
      LabelType.three,
      LabelType.four,
      LabelType.five,
      LabelType.six,
      LabelType.seven,
      LabelType.eight,
      LabelType.nine,
      LabelType.zero,
      LabelType.point,
    ].contains(keyboard.type);
  }

  bool isSign(KeyboardModel keyboard){
    return [
      LabelType.add,
      LabelType.subtract,
      LabelType.multiply,
      LabelType.divide,
    ].contains(keyboard.type);
  }

  bool getValueSign(KeyboardModel keyboard){
    switch(keyboard.type){
      case LabelType.add:
        return _additionBehavior.value;
      case LabelType.subtract:
        return _subtractionBehavior.value;
      case LabelType.multiply:
        return _multiplicationBehavior.value;
      case LabelType.divide:
        return _divisionBehavior.value;
      default:
        return false;
    }

  }

  String formatNumber(String str) {
    List<String> parts = str.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    final NumberFormat numberFormat = NumberFormat('#,###');
    String formattedIntegerPart = numberFormat.format(int.parse(integerPart));

    return decimalPart.isNotEmpty ? '$formattedIntegerPart.$decimalPart' : formattedIntegerPart;
  }

  String formatTypeNumber(String str) {
    double num = double.parse(str);
    if (num == num.toInt()) {
      return num.toInt().toString();
    } else {
      return str;
    }
  }

  void _updateStateMainNumber(KeyboardModel keyboard){
    bool isFirstZero = (_sumBehavior.value.mainNumber[0] == "0" && _sumBehavior.value.mainNumber.length == 1);
    if(keyboard.type == LabelType.point &&  isFirstZero){
      SumState newState = _sumBehavior.value.copyWith(
          mainNumber: "0."
      );
      _sumBehavior.sink.add(newState);
      return;
    }else if(isFirstZero){
      _sumBehavior.value = _sumBehavior.value.copyWith(
          mainNumber: ""
      );
    }

    SumState newState = _sumBehavior.value.copyWith(
        mainNumber: (_sumBehavior.value.mainNumber += keyboard.label)
    );
    _sumBehavior.sink.add(newState);
  }

  void _updateStateNumber(KeyboardModel keyboard){
    bool isFirstZero = (_sumBehavior.value.number[0] == "0" && _sumBehavior.value.number.length == 1);
    if(keyboard.type == LabelType.point &&  isFirstZero){
      SumState newState = _sumBehavior.value.copyWith(
          number: "0."
      );
      _sumBehavior.sink.add(newState);
      return;
    }else if(isFirstZero){
      _sumBehavior.value = _sumBehavior.value.copyWith(
          number: ""
      );
    }

    SumState newState = _sumBehavior.value.copyWith(
      number: (_sumBehavior.value.number += keyboard.label)
    );
    _sumBehavior.sink.add(newState);
  }

  void _updateClearSignBehavior(){
    _additionBehavior.sink.add(false);
    _subtractionBehavior.sink.add(false);
    _multiplicationBehavior.sink.add(false);
    _divisionBehavior.sink.add(false);
  }

  void updateClearUserSignBehavior(){
    _isShowMainNumber.sink.add(false);
  }

  void equalTotal(){
    double doubleMainNumber = double.parse(_sumBehavior.value.mainNumber);
    double doubleNumber = double.parse(_sumBehavior.value.number);

    double total = 0;
    switch(_sumBehavior.value.typeSign){
      case LabelType.add:
        total = doubleMainNumber + doubleNumber;
      case LabelType.subtract:
        total = doubleMainNumber - doubleNumber;
      case LabelType.multiply:
        total = doubleMainNumber * doubleNumber;
      case LabelType.divide:
        total = doubleMainNumber / doubleNumber;
      default:
        total = 0;
    }

    SumState newSumState = _sumBehavior.value.copyWith(
        mainNumber: formatTypeNumber(total.toString()),
        typeSign: null
      // number: "0"
    );
    _updateClearSignBehavior();
    _isShowMainNumber.sink.add(true);
    _sumBehavior.sink.add(newSumState);
  }

  void updateUiSign(KeyboardModel keyboard){
    switch(keyboard.type){
      case LabelType.add: {
        _subtractionBehavior.sink.add(false);
        _multiplicationBehavior.sink.add(false);
        _divisionBehavior.sink.add(false);

        _additionBehavior.sink.add(!_additionBehavior.value);
        _sumBehavior.sink.add(_sumBehavior.value.copyWith(
            typeSign: const Wrapped.value(LabelType.add)
        ));
      }
      case LabelType.subtract: {
        _additionBehavior.sink.add(false);
        _multiplicationBehavior.sink.add(false);
        _divisionBehavior.sink.add(false);

        _subtractionBehavior.sink.add(!_subtractionBehavior.value);
        sumBehavior.sink.add(_sumBehavior.value.copyWith(
            typeSign: const Wrapped.value(LabelType.subtract)
        ));
      }
      case LabelType.multiply: {
        _additionBehavior.sink.add(false);
        _subtractionBehavior.sink.add(false);
        _divisionBehavior.sink.add(false);

        _multiplicationBehavior.sink.add(!_multiplicationBehavior.value);
        sumBehavior.sink.add(_sumBehavior.value.copyWith(
            typeSign: const Wrapped.value(LabelType.multiply)
        ));
      }
      case LabelType.divide: {
        _additionBehavior.sink.add(false);
        _subtractionBehavior.sink.add(false);
        _multiplicationBehavior.sink.add(false);

        _divisionBehavior.sink.add(!_divisionBehavior.value);
        sumBehavior.sink.add(_sumBehavior.value.copyWith(
            typeSign: const Wrapped.value(LabelType.divide)
        ));
      }
      default:
        {

        }
    }
  }

  void onTapInput(KeyboardModel keyboard){
    if(keyboard.type == LabelType.equal){
      return equalTotal();
    }else if(isNumber(keyboard) == true){
      bool isUserSign = _sumBehavior.value.typeSign != null;

      if(isUserSign == true){
        _isShowMainNumber.sink.add(false);
        _updateClearSignBehavior();
      }else{
        _isShowMainNumber.sink.add(true);
      }

      if(isUserSign == true){
        return _updateStateNumber(keyboard);
      }
      _updateClearSignBehavior();
      return _updateStateMainNumber(keyboard);
    }else if(keyboard.type == LabelType.clear){
      _sumBehavior.sink.add(_sumBehavior.value.clear());
      _isShowMainNumber.sink.add(true);
      _updateClearSignBehavior();
    }else if(isSign(keyboard) == true){

      if(_sumBehavior.value.typeSign != null){
        equalTotal();
        _sumBehavior.add(_sumBehavior.value.copyWith(
            number: "0"
        ));

      }

      updateUiSign(keyboard);

    }
  }

  void additionNumber(){
    if(_sumBehavior.value.mainNumber == "0") return;
    _additionBehavior.sink.add(!_additionBehavior.value);
  }

  void subtractionNumber(){
    if(_sumBehavior.value.mainNumber == "0") return;
  }

  void multiplicationNumber(){
    if(_sumBehavior.value.mainNumber == "0") return;
  }

  void divisionNumber(){
    if(_sumBehavior.value.mainNumber == "0") return;
  }

}