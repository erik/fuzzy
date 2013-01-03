package fuzzy.ast;

class StringNode extends ValueNode
{
  public function new(str : String)
  {
    super();
    string = str;
  }

  public override function toString() : String
  {
    return '"' + string + '"';
  }

  public var string : String;
}