
enum LabelType{
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  zero,
  add,
  subtract,
  multiply,
  divide,
  point,
  clear,
  equal,
  empty,
}

class KeyboardModel {
  LabelType type;
  String label;

  KeyboardModel({
    required this.type,
    required this.label
  });
}