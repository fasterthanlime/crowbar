
import Ast // duh.

Visitor: abstract class {

  visitType: abstract func (t: Type)
  visitVar: abstract func (v: Var)

}
