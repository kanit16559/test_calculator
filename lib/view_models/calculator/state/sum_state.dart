
import '../../../models/calculator/keyboard_model.dart';

class SumState {
  String mainNumber;
  String number;
  LabelType? typeSign;

  SumState({
    this.mainNumber = "0",
    this.number = "0",
    this.typeSign,
  });



  SumState copyWith({
    String? mainNumber,
    String? number,
    Wrapped<LabelType>? typeSign
  }){
    return SumState(
      mainNumber: mainNumber ?? this.mainNumber,
      number: number ?? this.number,
      // typeSign: typeSign ?? this.typeSign
      typeSign: typeSign != null ? typeSign.value : this.typeSign
    );
  }

  SumState clear(){
    return SumState(
      mainNumber: "0",
      number: "0",
      typeSign: null,
    );
  }

}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}