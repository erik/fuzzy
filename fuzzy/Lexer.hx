package fuzzy;

using StringTools;

class SyntaxError
{
  public function new(msg : String)
  {
    this.msg = msg;
  }

  public var msg : String;
}

class Lexer
{
  public function new(source : String)
  {
    this.source = source;
    this.idx = -1;
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
      throw new SyntaxError('Invalid number: ' + num + this.next());
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

  public function nextToken() : Token
  {
    while(true) {
      switch(this.next()) {
      case null, "":
        return new Token(TEOF);

      case " ", "\t", "\n":
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
    throw new SyntaxError("Unexpected character: " + this.current());
  }

  var source : String;
  var idx : Int;
}