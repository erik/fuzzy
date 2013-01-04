package fuzzy;

import fuzzy.ast.AssignmentNode;
import fuzzy.ast.BinaryNode;
import fuzzy.ast.IdNode;
import fuzzy.ast.NumericNode;
import fuzzy.ast.RangeNode;
import fuzzy.ast.RuleNode;
import fuzzy.ast.RulesNode;
import fuzzy.ast.StringNode;
import fuzzy.ast.ValueNode;


import fuzzy.ASTNode;
import fuzzy.Token;

class ParseError
{
  public function new(msg : String)
  {
    this.msg = msg;
  }

  public var msg : String;
}

class Parser
{
  public function new(lex : Lexer)
  {
    this.lexer = lex;
    this.nodes = new Array<ASTNode>();
    this.tokens = new Array<Token>();
    this.current_token = lex.nextToken();
  }

  public function parseValue() : ValueNode
  {
    var tok = current_token;
    if(accept(new Token(TNumber))) {
      if(accept(new Token(TDotDot))) {
        var high = expect(new Token(TNumber));
        return new RangeNode(tok.value, high.value);
      }

      return new NumericNode(tok.value);

    } else if(accept(new Token(TString))) {
      return new StringNode(tok.value);
    } else if(accept(new Token(TIdentifier))) {
      return new IdNode(tok.value);
    }

    throw new ParseError("expected value, but got " +
                         tok.toString());
  }

  public function parseCondition(t : Token) : BinaryNode
  {
    var node : BinaryNode = new BinaryNode(null, null, null);

    switch(current_token.type)
    {
    case TEq, TGTE, TLTE, TGT, TLT:
      node.op = current_token.type;
      nextToken();
      expect(new Token(TNumber));
    default:
      throw new ParseError("Bad conditional");
    }

    return node;
  }

  public function parseAssignment() : AssignmentNode
  {
    var name = expect(new Token(TIdentifier));

    expect(new Token(TAssign));

    var value = parseValue();

    return new AssignmentNode(name.value, value);
  }

  public function parseRule() : RuleNode
  {
    expect(new Token(TRule));

    var name = expect(new Token(TIdentifier));

    var rule = new RuleNode(name.value);

    if(accept(new Token(TColon))) {
      do {
        var key = expect(new Token(TIdentifier));
        var value = nextToken();
      } while(accept(new Token(TComma)));
    }

    expect(new Token(TOpenBrace));

    if(accept(new Token(TWhen))) {

      do {
        var tok = expect(new Token(TIdentifier));
        if(current_token.type != TComma && current_token.type != TSemi) {
          if(current_token.isConditional()) {
            var cond = parseCondition(tok);
            rule.facts.push(cond);
          } else {
            throw new ParseError("Unexpected " + current_token.toString() + " expected operator or ','");
          }
        } else {
          // just the token
          rule.facts.push(new IdNode(tok.value));
        }
      } while(accept(new Token(TComma)));

      expect(new Token(TSemi));
    }

    if(accept(new Token(TSet))) {
      do {
        rule.assignments.push(parseAssignment());
      } while(accept(new Token(TComma)));

      expect(new Token(TSemi));
    }

    if(accept(new Token(TRespond))) {
      rule.response = new IdNode(expect(new Token(TIdentifier)).value);

      expect(new Token(TSemi));
    }

    expect(new Token(TCloseBrace));

    return rule;
  }

  public function parseRules() : RulesNode
  {
    var rules = new RulesNode();

    expect(new Token(TOpenBrace));

    while(true) {
      rules.add(parseRule());

      if(this.current_token.type != TRule) {
        break;
      }
    }

    expect(new Token(TCloseBrace));

    return rules;
  }

  public function parse() : Array<ASTNode>
  {

    return nodes;
  }

  private function accept(t : Token) : Bool
  {
    if(t.equal(current_token)) {
      nextToken();
      return true;
    }
    return false;
  }

  private function expect(t : Token) : Token
  {
    var tok = current_token;
    if(accept(t))
      return tok;

    throw new ParseError('unexpected ' + current_token.toString() +
                         ': expected ' + t.toString());
  }

  private function nextToken() : Token
  {
    if(tokens.length > 0) {
      current_token = tokens.shift();
    } else {
      current_token = lexer.nextToken();
    }

    return current_token;
  }

  private function peekToken() : Token
  {
    var tok = lexer.nextToken();
    tokens.push(tok);
    return tok;
  }

  var nodes : Array<ASTNode>;
  var lexer : Lexer;

  var tokens : Array<Token>;
  var current_token : Token;
}