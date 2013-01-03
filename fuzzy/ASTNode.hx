package fuzzy;

class ASTNode
{
  public function new()
  {
  }

  public function evaluate() : ASTNode
  {
    return this;
  }

  public function toString() : String
  {
    return "<ASTNODE>";
  }
}