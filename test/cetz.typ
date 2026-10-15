#import "@preview/cetz:0.5.2"

#set page(width: auto, height: auto)

// #show math.equation: block.with(fill: white, inset: 1pt)

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  circle((), radius: 2pt, fill: red, stroke: none)

  circle((90deg, 3), radius: 0, name: "content")
  circle((210deg, 3), radius: 0, name: "structure")
  circle((-30deg, 3), radius: 0, name: "form")

  for (c, a) in (
    ("content", "south"),
    ("structure", "north"),
    ("form", "north"),
  ) {
    content(c, align(center, c + [\ oriented]), padding: .1, anchor: a)
  }

  stroke(gray + 1.2pt)
  line("content", "structure", "form", close: true)

  for (c, s, f, cont) in (
    (0.5, 0.1, 1, "PostScript"),
    (1, 0, 0.4, "DVI"),
    (0.5, 0.5, 1, "PDF"),
    (0, 0.25, 1, "CSS"),
    (0.5, 1, 0, "XML"),
    (0.5, 1, 0.4, "HTML"),
    (1, 0.2, 0.8, "LaTeX"),
    (1, 0.6, 0.8, "TeX"),
    (0.8, 0.8, 1, "Word"),
    (1, 0.05, 0.05, "ASCII"),
  ) {
    content(
      (
        bary: (
          content: c,
          structure: s,
          form: f,
        ),
      ),
      cont,
      fill: rgb(50, 50, 255, 100),
      stroke: none,
      frame: "circle",
    )
  }
})

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  grid(
    (0, 0),
    (3, 2),
    help-lines: true,
  )

  circle((3, 2), name: "a", radius: 2pt)
  circle((1, 1), name: "c", radius: 0.75)
  content("c", $ c $, anchor: "north-east", padding: .1)

  line(
    // The starting point or element
    "a",
    // The tangent coordinate
    (element: "c", point: "a", solution: 1),
    // The center of the circle
    "c",
    // The other tangent coordinate
    (element: "c", point: "a", solution: 2),
    "a",
    stroke: red,
  )
})



#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  circle((), fill: red, stroke: none, radius: 2pt)
  set-style(content: (padding: .05))
  content((30deg, 1), $ p_1 $, name: "p1")
  content((75deg, 1), $ p_2 $, name: "p2")

  line((-0.2, 0), (1.2, 0), name: "xline")
  content("xline.end", $ q_1 $, anchor: "west")

  line((2, -0.2), (2, 1.2), name: "yline")
  content("yline.end", $ q_2 $, anchor: "south")

  line("p1.south-east", (horizontal: "p1.south-east", vertical: "xline.end"))
  line("p2.south-east", ((), "|-", "xline.end"))
  line("p1.south-east", (vertical: (), horizontal: "yline.end"))
  line("p2.south-east", ((), "-|", "yline.end"))
})


#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  set-style(fill: black, radius: 0.1)

  circle(name: "A", (0, 0))
  circle(name: "B", (3, 1))
  circle(name: "P", (1.9, -1.6))

  line("A", "B")
  line("P", (project: "P", onto: ("A", "B")))
})


#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  line((1, 0), (1, 1), name: "upward line")
  line((0, 0), (30deg, 1.5cm), name: "sloped line") 
  // a bit longer, so that there is an intersection
  hide({
})

intersections("x", "upward line", "sloped line")
line((1, 0), "x.0", stroke: orange + 1.2pt)
})


#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  intersections("i", {
  circle((0, 0))
  bezier((0,0), (3,0), (1,-1), (2,1))
  line((0,-1), (0,1))
  rect((1.5,-1),(2.5,1))
})
for-each-anchor("i", (name) => {
  circle("i." + name, radius: .1, fill: blue)
})
})


#cetz.canvas(length: 1cm, {
  import cetz.draw: *
})

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
})

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
})

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
})

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
})

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
})

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
})
