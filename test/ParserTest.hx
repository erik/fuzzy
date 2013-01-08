import haxe.unit.TestCase;

import fuzzy.ast.RangeNode;
import fuzzy.ast.BinaryNode;
import fuzzy.ast.NumericNode;
import fuzzy.ast.StringNode;
import fuzzy.ast.IdNode;

import fuzzy.Parser;
import fuzzy.Lexer;

@:access(fuzzy)
@:access(fuzzy.Parser)
class ParserTest extends TestCase
{
  function testParseValue() : Void
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

  function testParseAssignment() : Void
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

  function testParseResponse()
  {
    var lex = new Lexer("response some_response {\n" +
                        "  say 'foo' 'bar' 'baz'\n" +
                        "    this_too;" +
                        "  do 1 'two' _3;\n" +
                        "  asdf;\n" +
                        "}");
    var parse = new Parser(lex);

    var response = parse.parseResponse();

    assertEquals("some_response", response.name);
    assertEquals(3, response.options.length);
    assertEquals(0, response.options[2].args.length);
  }

  function testParseResponses()
  {
    var lex = new Lexer("responses {\n" +
                        "  response resp {\n" +
                        "    do x y z;\n" +
                        "  }" +
                        "  response resp2 {\n" +
                        "    do x y z;\n" +
                        "  }" +
                        "}");
    var parse = new Parser(lex);

    var responses = parse.parseResponses();

    assertEquals(2, responses.length);
  }

  function testParseRule()
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

  function testParseRules()
  {
    var lex = new Lexer("rules {\n" +
                        "  rule some_rule : limit once {\n" +
                        "    when FooBar;\n" +
                        "    respond Baz;\n" +
                        "  }\n" +
                        "  rule other_rule {\n" +
                        "    when Baz;\n" +
                        "    respond FooBar;\n" +
                        "  }\n" +
                        "}");
    var parse = new Parser(lex);
    var rules = parse.parseRules();

    assertEquals(2, rules.length);

    assertEquals("some_rule", rules[0].name);
    assertEquals("other_rule",rules[1].name);
  }

}