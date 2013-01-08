package fuzzy;

enum TokenType
{
  TNone;
  TEOF;
  TOpenBrace; TCloseBrace;
  TDot; TDotDot;
  TColon; TComma; TSemi;
  TAssign;
  TEq; TGTE; TLTE; TGT; TLT;
  TString; TNumber; TIdentifier;
  TRule; TRules; TWhen; TSet; TRespond; TResponse; TResponses;
}

typedef Location =
{
  var min : Int;
  var max : Int;
}

class Token
{
  public var type : TokenType;
  public var value : String;
  public var location : Location;

  public function new(t : TokenType, ?v : String, ?loc : Location)
  {
    type = t;
    value = v;
    location = loc;
  }

  public function equal(other : Token) : Bool
  {
    return type == other.type && (value == null || value == other.value);
  }

  public function isConditional() : Bool
  {
    switch(type) {
    case TEq, TGTE, TLTE, TGT, TLT: return true;
    default: return false;
    }
  }

  public function toString() : String
  {
    return ("<" + Std.string(type) + (value == null ? "" : ": " + value) + ">");
  }
}