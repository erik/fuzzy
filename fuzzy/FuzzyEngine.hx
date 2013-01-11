package fuzzy;

import fuzzy.ast.RuleNode;
import fuzzy.ast.ResponseNode;

class FuzzyEngine
{
  public function new()
  {
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

  public function addValue(name : String, val : Value) : Void
  {
    values.set(name, val);
  }

  public function addResponseHook(name : String, hook : Array<String> -> Void)
  {
    hooks.set(name, hook);
  }

  var facts     : Hash<Bool>;
  var hooks     : Hash<Array<String> -> Void>;
  var responses : Hash<ResponseNode>;
  var rules     : Hash<RuleNode>;
  var values    : Hash<Value>;
}
