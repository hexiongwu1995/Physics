#import "@preview/animo:0.1.1": *
#show: animo.with(width: 16cm, height: 9cm, margin: 1cm)

#slide(animation: {
  import anim: *
  sub(reveal("punchline"))
})[
  = Hello

  This is static text shown right away.

  #tag("punchline")[This will only appear on the next subslide.]
]