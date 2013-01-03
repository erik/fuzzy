package fuzzy.ast;

class RangeNode extends ValueNode
{
  public function new(low, high : String)
  {
    super();
    this.low = Std.parseInt(low);
    this.high = Std.parseInt(high);
  }

  public override function toString() : String
  {
    return Std.string(low) + ".." + Std.string(high);
  }

  public var low : Int;
  public var high : Int;
}