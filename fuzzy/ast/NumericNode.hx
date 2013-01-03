package fuzzy.ast;

class NumericNode extends ValueNode
{
  public function new(num : String)
  {
    super();
    this.num = Std.parseInt(num);
  }

  public override function toString() : String
  {
    return Std.string(num);
  }

  public var num : Int;
}