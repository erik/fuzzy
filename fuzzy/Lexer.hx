package fuzzy;

using StringTools;

class SyntaxError
{
  public function new(lex : Lexer, msg : String)
  {
    this.msg = msg;
    line = lex.eol_pos.length + 1;
  }

  public function toString() : String
  {
    return "Syntax error: " + msg + "\n\t at line " + Std.string(line);
  }

  public var msg : String;
  public var line : Int;
}

class Lexer
{
  public function new(source : String)
  {
    this.source = source;
    this.idx = -1;
    this.eol_pos = new Array<Int>();
  }

  private function current() : String
  {
    return source.charAt(idx);
  }

  private function next() : String
  {
    return source.charAt(++idx);
  }

  private function peek() : String
  {
    return source.charAt(idx + 1);
  }

  private function isNumeric(c : String) : Bool
  {
    switch(c) {
      case "0","1","2","3","4","5","6","7","8","9":
        return true;
      default:
        return false;
    }
  }

  private function isAlpha(chr : String) : Bool
  {
    var c : Int = chr.charCodeAt(0);
    return chr == "_" || (c >= "A".code && c <= "Z".code) ||
      (c >= "a".code && c <= "z".code);
  }

  private function parseNumber() : Token
  {
    var num : String = this.current();

    while(isNumeric(this.peek())) {
      num += this.next();
    }

    // invalid number
    if(isAlpha(this.peek())) {
      throw new SyntaxError(this, 'Invalid number: ' + num + this.next());
    }

    return new Token(TNumber, num);
  }

  private function parseIdent() : Token
  {
    var id : String = this.current();

    while(isAlpha(this.peek()) || isNumeric(this.peek())) {
      id += this.next();
    }

    switch(id) {
    case "rule": return new Token(TRule);
    case "when": return new Token(TWhen);
    case "set": return new Token(TSet);
    case "respond": return new Token(TRespond);
    }

    return new Token(TIdentifier, id);
  }

  private function parseString(delim : String) : Token
  {
    var str : String = this.next();

    while(this.next() != delim) {
      str += this.current();
    }

    return new Token(TString, str);
  }

  private function skipWhitespace() : Void
  {
    while(true) {
      switch(this.peek()) {

      case " ", "\t":
        null;

      case "\n":
        eol_pos.push(idx);

      default:
        return;
      }
      this.next();
    }
  }

  public function nextToken() : Token
  {
    skipWhitespace();

    var min = idx + 1;
    var tok = this.lex();
    var max = idx;

    tok.location = {min:min, max:max};

    return tok;
  }

  public function lex() : Token
  {
    while(true) {
      switch(this.next()) {
      case null, "":
        return new Token(TEOF);

      case " ", "\t", "\n":
          continue;

      case "#":
        while(this.current() != "\n" && this.current() != "") {
          this.next();
        }
        continue;

      case ";": return new Token(TSemi);

      case "{": return new Token(TOpenBrace);
      case "}": return new Token(TCloseBrace);
      case ".":
        if(this.peek() == ".") {
          this.next(); // eat dot
          return new Token(TDotDot);
        } else
          return new Token(TDot);
      case "=":
        if(this.peek() == "=") { this.next(); return new Token(TEq); }
        else return new Token(TAssign);
      case "<":
        if(this.peek() == "=") { this.next(); return new Token(TLTE); }
        else return new Token(TLT);
      case ">":
        if(this.peek() == "=") { this.next(); return new Token(TGTE); }
        else return new Token(TGT);
      case '"': return parseString('"');
      case "'": return parseString("'");
      case ":": return new Token(TColon);
      case ",": return new Token(TComma);

      default:
        if(isNumeric(this.current()))
          return parseNumber();
        else if(isAlpha(this.current())) {
          return parseIdent();
        }
      }
    }
    throw new SyntaxError(this, "Unexpected character: " + this.current());
  }

  public var eol_pos : Array<Int>;
  public var idx : Int;
  public var source : String;
}