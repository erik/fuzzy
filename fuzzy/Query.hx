package fuzzy;

import fuzzy.ast.RuleNode;

class Query
{
  public function new(e : FuzzyEngine)
  {
    eng = e;
    facts     = new Hash<Bool>();
    values    = new Hash<Value>();
  }

  public function addFact(fact : String) : Query
  {
    facts.set(fact, true);
    return this;
  }

  public function addFacts(facts : Array<String>) : Query
  {
    for(fact in facts) {
      this.addFact(fact);
    }
    return this;
  }

  public function addValue(name : String, val : Value) : Query
  {
    values.set(name, val);
    return this;
  }

  public function dispatch(?threshhold : Int = 0) : Void
  {
    var choice : { matched : Int, rule: RuleNode} =
      {matched : 0, rule : null};

    for(rule in eng)
    {
      if(rule.facts.length < threshhold ||
         rule.facts.length <= choice.matched)
        continue;

      var matched : Bool = true;
      for(fact in rule.facts) {
        if(!facts.exists(fact.toString()) && !eng.hasFact(fact.toString())) {
          matched = false;
          break;
        }
      }

      if(matched) {
        choice = { matched : rule.facts.length,
                   rule : rule };
      }
    }

    if(choice.rule != null) {
      eng.runResponse(choice.rule.response.name);
    }
  }

  var eng : FuzzyEngine;
  var facts: Hash<Bool>;
  var values:Hash<Value>;
}