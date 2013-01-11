import haxe.unit.TestCase;

import fuzzy.Parser;
import fuzzy.Lexer;
import fuzzy.FuzzyEngine;
import fuzzy.Query;

class EngineTest extends TestCase
{
  function testDummy()
  {
    var eng = new FuzzyEngine();

    eng.loadString(
      "rules { \n" +
      "  rule a {\n" +
      "    \n" +
      "  } \n" +
      "}\n\n" +
      "responses {\n" +
      "  response a {}\n" +
      "}");

    new Query(eng).dispatch();

    assertTrue(true);
  }
}