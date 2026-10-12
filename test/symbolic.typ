#import "@preview/symbolica:0.1.0": *

#let x = symbol("x")
#let f = math($x^4 - 5 x^2 + 4$)

$
  f(x) &= #to-typst(f) \
       &= #to-typst(factor(f)) \
  f'(x) &= #to-typst(derivative(f, x))
$
#evaluate(f,values:((x,1.2),))







