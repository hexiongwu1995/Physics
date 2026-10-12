#import "@preview/cetz:0.5.2"
#import cetz.draw

// 颜色定义
#let ecolor = teal // 电场线
#let pcolor = fuchsia.lighten(30%) // 等势面

// 二次贝塞尔曲线采样,返回点列
#let qbez(p0, c, p1, n: 40) = {
  let pts = ()
  for i in range(n + 1) {
    let t = i / n
    let ax = (1 - t) * p0.at(0) + t * c.at(0)
    let bx = (1 - t) * c.at(0) + t * p1.at(0)
    let ay = (1 - t) * p0.at(1) + t * c.at(1)
    let by = (1 - t) * c.at(1) + t * p1.at(1)
    pts.push(((1 - t) * ax + t * bx, (1 - t) * ay + t * by))
  }
  pts
}

// 电场线:从右向左绘制,箭头在左端
#let field-line(p0, c, p1) = draw.line(
  ..qbez(p0, c, p1),
  stroke: (thickness: 1pt, paint: ecolor, cap: "round", join: "round"),
  mark: (end: (symbol: ">", fill: ecolor), length: 2.6mm),
)

// 等势面弧线:从上向下绘制
#let equipotential(p0, c, p1) = draw.line(
  ..qbez(p0, c, p1),
  stroke: (thickness: 1pt, paint: pcolor, cap: "round", join: "round"),
)

#align(center, block({
  cetz.canvas({
    // 等势面(粉色弧线,凸向右上)
    equipotential((2.7, 6.9), (4.6, 4.4), (4.6, 1.2))
    equipotential((4.1, 7.3), (6.1, 4.5), (5.7, 1.1))
    equipotential((5.6, 7.6), (7.5, 4.5), (6.9, 1.0))
    equipotential((7.1, 7.7), (8.8, 4.5), (8.2, 1.0))

    // 电场线(青色曲线,箭头指向左下方)
    field-line((5.6, 8.3), (3.4, 6.2), (1.6, 3.2))
    field-line((7.9, 4.7), (4.8, 3.9), (1.85, 2.8))
    field-line((8.9, 2.9), (5.2, 2.45), (2.0, 2.1))
    field-line((8.8, 1.6), (5.3, 1.6), (2.15, 1.35))

    // A 点在最上方电场线上,B 点在带 E 标签的电场线上
    draw.circle((3.1, 5.45), radius: 0.1, fill: black, stroke: none)
    draw.circle((6.7, 4.35), radius: 0.1, fill: black, stroke: none)
    draw.content((2.85, 6.05), [$A$])
    draw.content((6.75, 4.95), [$B$])

    // 电场线标签 E
    draw.content((8.35, 4.75), [$E$])
  })
  align(center)[图 10.2-4]
}))
