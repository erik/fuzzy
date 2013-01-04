package fuzzy.ast;

import fuzzy.Token;

class BinaryNode extends ASTNode
{
  public function new(left : ASTNode, op : TokenType, right : ASTNode)
  {
    super();

    this.left = left;
    this.op = op;
    this.right = right;
  }

  public override function toString() : String
  {
    return left.toString() + " " + Std.string(op) + " " + right.toString();
  }

  public var left : ASTNode;
  public var right : ASTNode;
  public var op : TokenType;
}