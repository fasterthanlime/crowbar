
import Ast
import CBackend

main: func {

  m := Module new("natural")
  
  // Nat: cover from Int {
  natCover := CoverDecl new("Nat", "Int")
  m types add(natCover)
  
  // rule this >= 0
  natCover rules add(ExprRule new(
    Comparison new(
      Comp gte,
      Name new("this"),
      NumberLit new("0")
    )
  ))
  
  // }
  
  // fac definition
  facDef := FuncDecl new("fac")
  facDef args add(TypedVar new("a", Type new("Nat")))
  fac2Call := Call new("fac2")
  fac2Call args add(Name new("a"))
  facDef body stats add(fac2Call)
  m funcs add(facDef)
  
  // fac2 definition
  fac2Def := FuncDecl new("fac2")
  fac2Def args add(TypedVar new("a", Type new("Nat")))
  m funcs add(fac2Def)
  
  m toString() println()
  
  CBackend new("crowbar_output.c", m)

}

