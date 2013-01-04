package fuzzy.ast;

class ResponseNode extends ASTNode
{
  public function new(name : String)
  {
    super();

    this.name = name;
  }

  public override function evaluate() : ASTNode
  {
    return this;
  }

  public override function toString() : String
  {
    return "<RESPONSENODE>";
  }

  public var name : String;
}