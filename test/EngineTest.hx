import haxe.unit.TestCase;

import fuzzy.Parser;
import fuzzy.Lexer;
import fuzzy.FuzzyEngine;
import fuzzy.Query;

import fuzzy.ast.ValueNode;

class EngineTest extends TestCase
{

  function testDummy()
  {
    var eng = new FuzzyEngine();

    eng.loadString(
      "rules { \n" +
      "  rule a {\n" +
      "    when CatA, this, that, the_other;\n" +
      "    respond a;\n" +
      "  } \n" +
      "  rule b {\n" +
      "    when CatB, this, that, the_other;\n" +
      "    respond b;\n" +
      "  } \n" +
      "}\n\n" +
      "responses {\n" +
      "  response a { func a; }\n" +
      "  response b { func b; }\n" +
      "}");

    eng.addFacts(['this','that','the_other']);

    var resp : String = null;

    eng.addResponseHook(
      'func', function(vals : Array<ValueNode>) : Void
      {
        resp = vals[0].toString();
      });

    new Query(eng)
      .addFact('CatA')
      .dispatch();

    assertEquals("a", resp);
  }
}