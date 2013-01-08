import haxe.unit.TestCase;

import fuzzy.Parser;
import fuzzy.Lexer;
import fuzzy.FuzzyEngine;


class EngineTest extends TestCase
{
  function testDummy()
  {
    var eng = new FuzzyEngine();
    eng.loadString(
      "rules { \n" +
      "  rule a {} \n" +
      "}\n\n" +
      "responses {\n" +
      "  response a {}\n" +
      "}");

    assertTrue(true);
  }
}