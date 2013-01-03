import haxe.unit.TestCase;

import fuzzy.ast.RangeNode;
import fuzzy.ast.NumericNode;
import fuzzy.ast.StringNode;
import fuzzy.ast.IdNode;

import fuzzy.Parser;
import fuzzy.Lexer;

class ParserTest extends TestCase
{
  public function new()
  {
    super();
  }

  public function testParseValue() : Void
  {
    var lex = new Lexer("123 'string' fact 1..2");
    var parse = new Parser(lex);

    var val = parse.parseValue();
    assertTrue(Std.is(val, NumericNode));
    assertEquals(123, cast(val, NumericNode).num);

    val = parse.parseValue();
    assertTrue(Std.is(val, StringNode));
    assertEquals("string", cast(val, StringNode).string);

    val = parse.parseValue();
    assertTrue(Std.is(val, IdNode));
    assertEquals("fact", cast(val, IdNode).name);

    val = parse.parseValue();
    assertTrue(Std.is(val, RangeNode));
    assertEquals(1, cast(val, RangeNode).low);
    assertEquals(2, cast(val, RangeNode).high);

  }

  public function testParseRule()
  {
    var lex = new Lexer("rule myrule : limit once {\n" +
                        "  when health >= 0, IsNotSelf;\n" +
                        "  set asdf=2,asdfg=3;\n" +
                        "  respond myrule;\n" +
                        "}");
    var parse = new Parser(lex);
    var rule = parse.parseRule();
    assertEquals("myrule", rule.name);
    assertEquals(2, rule.facts.length);
    assertEquals(2, rule.assignments.length);
  }

}