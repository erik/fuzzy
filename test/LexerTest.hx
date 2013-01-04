import haxe.unit.TestCase;

import fuzzy.Lexer;
import fuzzy.Token;

class LexerTest extends TestCase
{
  public function new()
  {
    super();
  }

  public function testLexEOF() : Void
  {
    var lex = new Lexer("");
    assertEquals(lex.nextToken().type, TEOF);

    lex = new Lexer(" ");
    assertEquals(lex.nextToken().type, TEOF);
  }

  public function testLexLocation() : Void
  {
    var lex = new Lexer("0 234 6789");

    var tok = lex.nextToken();
    assertEquals(0, tok.location.min);
    assertEquals(0, tok.location.max);

    tok = lex.nextToken();
    assertEquals(2, tok.location.min);
    assertEquals(4, tok.location.max);

    tok = lex.nextToken();
    assertEquals(6, tok.location.min);
    assertEquals(9, tok.location.max);
  }

  public function testLexNumber() : Void
  {
    var lex = new Lexer("0 100 3000a");
    assertTrue(lex.nextToken().equal(new Token(TNumber, "0")));
    assertTrue(lex.nextToken().equal(new Token(TNumber, "100")));

    // 3000a is invalid number
    var error : Bool = false;
    try {
      lex.nextToken();
    } catch(ex : SyntaxError) {
      error = true;
    }
    assertTrue(error);

  }

  public function testLexComment() : Void
  {
    var lex = new Lexer("#\n1\n# on own line\n2 # on same line\n#");
    assertTrue(lex.nextToken().equal(new Token(TNumber, "1")));
    assertTrue(lex.nextToken().equal(new Token(TNumber, "2")));
    assertTrue(lex.nextToken().equal(new Token(TEOF)));
  }

  public function testLexIdentifier() : Void
  {
    var lex = new Lexer("a __abc _123 a1b b2_b");
    assertTrue(lex.nextToken().equal(new Token(TIdentifier, "a")));
    assertTrue(lex.nextToken().equal(new Token(TIdentifier,"__abc")));
    assertTrue(lex.nextToken().equal(new Token(TIdentifier,"_123")));
    assertTrue(lex.nextToken().equal(new Token(TIdentifier,"a1b")));
    assertTrue(lex.nextToken().equal(new Token(TIdentifier, "b2_b")));
  }

  public function testLexString() : Void
  {
    var lex = new Lexer("'abc' \"a'b'c\"");
    assertTrue(lex.nextToken().equal(new Token(TString,"abc")));
    assertTrue(lex.nextToken().equal(new Token(TString,"a'b'c")));
  }

  public function testLexOper() : Void
  {
    var lex = new Lexer(". .. ... <= < = == >= >");
    assertTrue(lex.nextToken().equal(new Token(TDot)));
    assertTrue(lex.nextToken().equal(new Token(TDotDot)));
    assertTrue(lex.nextToken().equal(new Token(TDotDot)));
    assertTrue(lex.nextToken().equal(new Token(TDot)));
    assertTrue(lex.nextToken().equal(new Token(TLTE)));
    assertTrue(lex.nextToken().equal(new Token(TLT)));
    assertTrue(lex.nextToken().equal(new Token(TAssign)));
    assertTrue(lex.nextToken().equal(new Token(TEq)));
    assertTrue(lex.nextToken().equal(new Token(TGTE)));
    assertTrue(lex.nextToken().equal(new Token(TGT)));
  }

  public function testLexEdgeCases() : Void
  {
    var lex = new Lexer("1,a,2");
    assertTrue(lex.nextToken().equal(new Token(TNumber, "1")));
    assertTrue(lex.nextToken().equal(new Token(TComma)));
    assertTrue(lex.nextToken().equal(new Token(TIdentifier, "a")));
    assertTrue(lex.nextToken().equal(new Token(TComma)));
    assertTrue(lex.nextToken().equal(new Token(TNumber, "2")));
  }

}