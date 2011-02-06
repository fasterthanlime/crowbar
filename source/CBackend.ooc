
import Ast // OH NOES.
import CodeWriter // cause FileWriter sucks, right?
import Visitor

CBackend: class extends Visitor {

  out: CodeWriter
  
  init: func (path: String, m: Module) {
    out = CodeWriter new(path, this)
    m funcs each(|fun|
      visitFunc(fun)
    )
    out close()
  }
  
  visitFunc: func (f: FuncDecl) {
    out app(f retType). app(" "). app(f name). app("(")
    
    first := true
    f args each(|arg|
      if(first) first = false
      else      out app(", ")
      out app(arg)
    )
    
    out app(") {}"). nl(). nl() // TODO: body
  }
  
  visitType: func (t: Type) {
    // TODO: proper handling
    out app(t name)
  }
  
  visitVar: func (v: Var) {
    match v {
      case tv: TypedVar =>
        out app(tv type). app(" "). app(tv name)
      case =>
        "Uninferenced variable %s, bailing out!" printfln(v toString())
        exit(1)
    }
  }

}


