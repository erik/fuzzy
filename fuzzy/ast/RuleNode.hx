package fuzzy.ast;

class RuleNode extends ASTNode
{

  // TODO: limit once and all that stuff

  public function new(name : String)
  {
    super();

    this.name = name;

    facts = new Array<ASTNode>();
    assignments = new Array<AssignmentNode>();
    response = null;
  }

  public override function evaluate() : ASTNode
  {
    return this;
  }

  public override function toString() : String
  {
    return "<RULENODE>";
  }

  public var facts : Array<ASTNode>;
  public var assignments : Array<AssignmentNode>;
  public var response : ASTNode;
  public var name : String;
}