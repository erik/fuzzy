package fuzzy;

import fuzzy.ast.RuleNode;
import fuzzy.ast.ResponseNode;
import fuzzy.ast.ValueNode;

class FuzzyEngine
{
  public function new()
  {
    hooks     = new Hash<Array<ValueNode> -> Void>();
    facts     = new Hash<Bool>();
    values    = new Hash<Value>();
    rules     = new Hash<RuleNode>();
    responses = new Hash<ResponseNode>();
  }

  public function loadString(string : String) : Void
  {
    var parser = new Parser(new Lexer(string));
    var script = parser.parse();

    for(rule in script.rules) {
      if(rules.exists(rule.name))
        throw "duplicate rule: " + rule.name;

      rules.set(rule.name, rule);
    }

    for(resp in script.responses) {
      if(responses.exists(resp.name))
        throw "duplicate response: " + resp.name;

      responses.set(resp.name, resp);
    }
  }

  public function addFact(fact : String) : Void
  {
    facts.set(fact, true);
  }

  public function addFacts(facts : Array<String>) : Void
  {
    for(fact in facts) {
      this.addFact(fact);
    }
  }

  public function addValue(name : String, val : Value) : Void
  {
    values.set(name, val);
  }

  public function addResponseHook(name : String, hook : Array<ValueNode> -> Void)
  {
    hooks.set(name, hook);
  }

  public function hasFact(fact : String) : Bool
  {
    return facts.exists(fact);
  }

  public function getValue(name : String) : Value
  {
    return values.get(name);
  }

  public function runResponse(name : String) : Void
  {
    var resp = responses.get(name);
    if(resp == null) {
      throw "no response " + name;
    }

    var opt = resp.run();
    var hook = hooks.get(opt.func);
    hook(opt.args);
  }

  public function iterator() : Iterator<RuleNode>
  {
    return rules.iterator();
  }

  var facts     : Hash<Bool>;
  var hooks     : Hash<Array<ValueNode> -> Void>;
  var responses : Hash<ResponseNode>;
  var rules     : Hash<RuleNode>;
  var values    : Hash<Value>;
}
