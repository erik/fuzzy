package fuzzy.ast;

class RulesNode extends ASTNode
{
  public function new()
  {
    super();
    rules = new Array<RuleNode>();
  }

  public function add(r : RuleNode) : Void
  {
    rules.push(r);
  }

  public override function toString() : String
  {
    return "<RULESNODE>";
  }


  public var rules(default, null) : Array<RuleNode>;
}