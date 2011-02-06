
import structs/ArrayList

import Option

// Type constants
voidType := Type new("Void")
boolType := Type new("Bool")
intType  := Type new("Int")

Type: class {
  name: String
  args := ArrayList<Type> new()

  init: func (=name) {}
  
  toString: func -> String {
    // todo: args
    name
  }
}

Stat: abstract class {
  toString: abstract func -> String
}

Expr: abstract class extends Stat {
  
  /**
   * We return an Option<Type> so we can avoid null types
   * or at least enforce checking
   */
  getType: abstract func -> Option<Type>
}

Call: class extends Expr {
  expr := Option<Expr> new() // (ie. None by default)
  name: String
  args := ArrayList<Expr> new()
  
  init: func (=name) {}
  
  getType: func -> Option<Type> {
    // TODO: resolve, returning None for now
    Option<Type> new()
  }
  
  toString: func -> String {
    name + "(" + args map(|x| x toString()) join(", ") + ")"
  }
}

Name: class extends Expr {
  name: String
  
  init: func (=name) {}
  
  getType: func -> Option<Type> {
    return Option<Type> new()
  }
  
  toString: func -> String {
    name
  }
}

NumberLit: class extends Expr {
  value: String
  
  init: func(=value) {}
  
  getType: func -> Option<Type> {
    return Option<Type> new(intType)
  }
  
  toString: func -> String {
    value
  }
}

Comp: enum {
  gt  // greater than
  gte // greater than or equal
  lt  // lesser than
  lte // lesser than or equal
  e   // equal
  ne  // not equal
}

Comparison: class extends Expr {
  comp: Comp
  left, right: Expr
  
  init: func (=comp, =left, =right) {}
  
  getType: func -> Option<Type> {
      return Option<Type> new(boolType)
  }
  
  toString: func -> String {
    left toString() + " " + match comp {
      case Comp gt  => ">"
      case Comp gte => ">="
      case Comp lt  => "<"
      case Comp lte => "<="
      case Comp e   => "="
      case Comp ne  => "!="
    } + " " + right toString()
    // Yeeeeeeeeeeeehaa.
  }
}

Rule: abstract class {

  toString: abstract func -> String
  
}

ExprRule: class extends Rule {
  expr: Expr
  
  init: func(=expr) {}
  
  toString: func -> String {
    "rule %s" format(expr toString())
  }
}

Var: class {
  name: String
  
  init: func (=name) {}
  
  toString: func -> String {
    "var %s" format(name)
  }
}

TypedVar: class extends Var {
  type: Type
  
  init: func (=name, =type) {}
  
  toString: func {
    "var %s: %s" format(name, type toString())
  }
}

Body: class {
  rules := ArrayList<Rule> new()
  stats := ArrayList<Stat> new()
  
  toString: func -> String {
    // TODO: rules
    "{\n" + stats map(|stat| "  " + stat toString()) join("\n") + "\n}\n"
  }
}

FuncDecl: class {
  name: String
  args := ArrayList<Var> new()
  retType := voidType
  body := Body new()
  
  init: func(=name) {}
  
  toString: func -> String {
    name + ": func (" + args map(|x| x toString()) join(", ") + \
      ") -> " + retType toString() + " " + body toString()
  }
}

TypeDecl: class {
  name: String
  args := ArrayList<String> new()
  
  init: func(=name) {}
  
  toString: func -> String {
    "type %s" format(name)
    // TODO: args (ie. generics)
  }
}

CoverDecl: class extends TypeDecl {
  under: String
  underRef: CoverDecl // TODO: resolve? :D

  rules := ArrayList<Rule> new()
  
  init: func(=name, =under) {}
  
  toString: func -> String {
    b := Buffer new()
    b append(super())
    b append(" cover from %s {\n   // rules:\n" format(under))
    rules each(|rule| b append("   "). append(rule toString()). append("\n"))
    b append("}\n\n")
    b toString()
  }
}

Module: class {
  name: String

  types := ArrayList<TypeDecl> new()
  funcs := ArrayList<FuncDecl> new()
  rules := ArrayList<Rule> new()
  
  init: func(=name) {}
  
  toString: func -> String {
    b := Buffer new()
    b append("// Module %s\n\n" format(name))
    
    b append("// Types:\n")
    types each(|type| b append(type toString()). append("\n"))
    
    b append("// Funcs:\n")
    funcs each(|fun| b append(fun toString()). append("\n"))
    
    // TODO: Rules
    b toString()
  }
}









