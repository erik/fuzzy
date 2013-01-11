package fuzzy;

enum Value {
  IntValue (v : Int);
  StringValue (v : String);
  RangeValue (low : Int, high : Int);
}