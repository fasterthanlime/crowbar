
import io/FileWriter
import Ast
import Visitor

CodeWriter: class {

  tabLevel := 0
  path: String
  fw: FileWriter
  visitor: Visitor

  init: func (=path, =visitor) {
    fw = FileWriter new(path)
  }

  // good karma.
  tab: func ~withClosure (f: Func) {
    tab()
    f()
    untab()
  }

  // use carefully - or better yet, not at all
  tab: func {
    tabLevel += 1
  }

  // use carefully - or better yet, not at all  
  untab: func {
    tabLevel -= 1
  }
  
  app: func (s: String) {
    fw write(s)
  }
  
  app: func ~type (t: Type) {
    visitor visitType(t)
  }
  
  app: func ~var (v: Var) {
    visitor visitVar(v)
  }
  
  nl: func {
    app("\n")
    tabLevel times(|x| app(" "))
  }
  
  close: func {
    fw close()
    "Wrote file to %s" printfln(path)
  }

}
