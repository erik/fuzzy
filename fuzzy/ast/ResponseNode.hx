package fuzzy.ast;

typedef ResponseOption = {func : String, args : Array<ValueNode>}

class ResponseNode extends ASTNode
{
  public function new(name : String)
  {
    super();

    this.name = name;
    this.options = new Array<ResponseOption>();
    this.spent = new Array<ResponseOption>();
  }

  public function run() : ResponseOption
  {
    if(options.length == 0) {
      options = spent;
      spent = new Array<ResponseOption>();
    }

    var idx = Std.random(options.length);
    var choice = options.splice(idx, 1)[0];

    spent.push(choice);

    return choice;
  }

  public override function toString() : String
  {
    return "<RESPONSENODE>";
  }

  public var name    : String;
  public var options : Array<ResponseOption>;
  var spent          : Array<ResponseOption>;
}