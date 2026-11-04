#import "@preview/typstage:0.2.0": *

#presentation(
  slide([A parabola], {
    desmos(api-key: demo-key, height: 300pt,
           expressions: (a: "a=1", kurve: "y=a x^2"),
           bounds: (-5, 5, -2, 12))
    dsm-set(("gerade": "y=2x"), at: 2)
  }),
)

#dsm-hide("gerade", at: 3)
#dsm-show("gerade", at: 4)
#dsm-remove("gerade", at: 5)

