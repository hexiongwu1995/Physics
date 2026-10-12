
#set page(width:auto,height:auto, margin:0.5cm)

#import "@preview/cetz:0.5.2"
#import calc: sqrt

#cetz.canvas(length:1cm,{
  import cetz.draw: *
  set-style(line: (stroke: (paint: rgb("#55aaaa"), thickness: 1pt), mark: (end: (symbol: "stealth", fill: rgb("#55aaaa"), scale: 0.8))))
  line((-3, 0), (3, 0))
  line((0, -3), (0, 3))
  grid((-3, -3), (3, 3), step:0.5, stroke: (paint: rgb("#55aaaae8"), thickness: 0.1pt))
  // draw an arc
  arc((0, 0), start:45deg,stop:135deg, radius: sqrt(2) * 1.5)
  // how can I use the circle element to draw the same arc?
  // why does cetz not allow to draw the arc with the circle element?
})