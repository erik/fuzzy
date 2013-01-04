package fuzzy.ast;

class AssignmentNode extends ASTNode
{
  public function new(name : String, value : ValueNode)
  {
    super();

    this.name = name;
    this.value = value;
  }

  public override function evaluate() : ASTNode
  {
    return this;
  }

  public override function toString() : String
  {
    return name + " = " + value.toString();
  }

  public var name : String;
  public var value : ValueNode;
}