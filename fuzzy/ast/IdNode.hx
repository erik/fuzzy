package fuzzy.ast;

class IdNode extends ValueNode
{
  public function new(name : String)
  {
    super();
    this.name = name;
  }

  public override function toString() : String
  {
    return name;
  }

  public var name : String;
}