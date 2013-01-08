import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import haxe.Timer;

class FuzzyTest extends TestCase
{

  public function new()
  {
    super();
  }

  public static function main()
  {
    var r = new TestRunner();

    r.add(new FuzzyTest());
    r.add(new LexerTest());
    r.add(new ParserTest());
    r.add(new EngineTest());

    r.run();
  }

}