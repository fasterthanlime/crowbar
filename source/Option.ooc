
Option: class <T> {
  data: T
  none := false
  
  init: func ~withData (=data) {}
  
  init: func ~none {
      none = true
  }
  
  unwrap: func (f: Func (T), g: Func ) {
    if(none)
      g()
    else
      f(data)
  }
}
