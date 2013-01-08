package fuzzy;

import fuzzy.ast.RuleNode;
import fuzzy.ast.ResponseNode;

class FuzzyEngine
{
  public function new()
  {
    rules = new Hash<RuleNode>();
    responses = new Hash<ResponseNode>();
  }

  public function loadString(string : String)
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

  // TODO:
  var rules : Hash<RuleNode>;
  var responses : Hash<ResponseNode>;
}
