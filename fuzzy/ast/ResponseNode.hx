package fuzzy.ast;

typedef ResponseOption = {func : String, args : Array<ValueNode>}

class ResponseNode extends ASTNode
{
  public function new(name : String)
  {
    super();

    this.name = name;
    this.options = new Array<ResponseOption>();
  }

  public override function toString() : String
  {
    return "<RESPONSENODE>";
  }

  public var name : String;
  public var options : Array<ResponseOption>;
}