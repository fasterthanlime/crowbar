
import Ast

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
  
  m toString() println()

}

