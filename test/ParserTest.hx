import haxe.unit.TestCase;

import fuzzy.ast.RangeNode;
import fuzzy.ast.BinaryNode;
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

  public function testParseAssignment() : Void
  {
    var lex = new Lexer("a=1 abc = an_ident abcde= 'string'");
    var parse = new Parser(lex);

    var val = parse.parseAssignment();
    assertEquals("a", val.name);
    assertEquals(1, cast(val.value, NumericNode).num);

    val = parse.parseAssignment();
    assertEquals("abc", val.name);
    assertEquals("an_ident", cast(val.value, IdNode).name);

    val = parse.parseAssignment();
    assertEquals("abcde", val.name);
    assertEquals("string", cast(val.value, StringNode).string);
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
    assertTrue(Std.is(rule.facts[0], BinaryNode));

    assertEquals(2, rule.assignments.length);

    assertEquals("myrule", rule.response.name);
  }

}