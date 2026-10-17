#import "@preview/cetz:0.5.2"
#set page(width: auto, height: auto, margin: 4mm)
#set text(font: ("Helvetica Neue", "Arial"), size: 10pt, fill: black)

// 2³ factorial design: each vertex is one run, each axis one factor at levels −/+.
// 2³ 因子设计：每个顶点代表一次试验（run），每条轴代表一个因子，取 −/+ 两个水平。
// Oblique projection: the canvas draws the z unit vector as (.45, .25).
// 斜投影：画布将 z 轴单位向量画为 (-0.45, -0.25)。
#cetz.canvas(length: 3cm, z: ( 0.45,  0.25), {
  import cetz.draw: *
  set-style(stroke: black, mark: (fill: black))

  for x in (0, 1) { for y in (0, 1) { for z in (0, 1) {
    let p = (x, y, z)
    if x == 0 { line(p, (rel: (1, 0, 0)),stroke:red+1pt) }
    if y == 0 { line(p, (rel: (0, 1, 0)),stroke:green+1pt) }
    if z == 0 { line(p, (rel: (0, 0, 1)),stroke:blue+1pt) }
    circle(p, radius: 2pt, fill: black, stroke: none)
  } } }

// circle((0,0,0),radius:2mm,fill:gray,stroke:none)
// circle((1,0,0),radius:2mm,fill:red,stroke:none)
// circle((0,1,0),radius:2mm,fill:green,stroke:none)
// circle((0,0,1),radius:2mm,fill:blue,stroke:none)

  // Level discs beside the low and high vertex; a line between named
  // elements stops at their borders.
  // 水平圆盘标注在低、高水平顶点旁；连接两个命名元素之间的线会在其边界处停下（不会穿过圆盘）。
  set-style(content: (frame: "circle", stroke: none, padding: 1.5pt))
  let factor(id, low, high, offset, anchor) = {
    content((rel: offset, to: low), $-$, fill: eastern.transparentize(55%), name: id + "-")
    content((rel: offset, to: high), $+$, fill: orange.transparentize(55%), name: id + "+")
    // The invisible start mark makes `offset` leave a gap at both ends.
    // 不可见的起始标记使 `offset` 在线段两端都留出间隙。
    line(id + "-", id + "+", mark: (start: (symbol: "|", stroke: none), end: ">", offset: 4pt))
    content((id + "-", 50%, id + "+"), id, anchor: anchor, frame: none, padding: 4pt)
  }
  factor("A", (0, 0, 0), (1, 0, 0), (0, -.22), "north")
  factor("B", (1, 0, 1), (1, 1, 1), (.2, 0), "west")
  factor("C", (0, 1, 0), (0, 1, 1), (-.2, .2), "south-east")
})