package fuzzy.ast;

class ValueNode extends ASTNode
{
  public function new()
  {
    super();
  }

  public override function toString() : String
  {
    return "<VALUE>";
  }
}