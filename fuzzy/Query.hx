package fuzzy;

class Query
{
  public function new(eng : FuzzyEngine)
  {
    engine = eng;
  }

  public function dispatch() : Void
  {
  }

  var engine : FuzzyEngine;
}