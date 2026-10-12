#import "@preview/cetz:0.5.2": canvas, draw

#set page(width: auto, height: auto, margin: 8mm)

// ===== 样式 =====
#let field-color = rgb("12888f") // 电场线:青色
#let equi-color = rgb("f0659f") // 等势线:粉色
#let lw = (thickness: 0.7pt, cap: "round", join: "round")

// ===== 工具函数 =====
// 二次贝塞尔曲线采样成点列
#let qbez(p0, c, p1, n: 48) = {
  let pts = ()
  for i in range(n + 1) {
    let t = i / n
    let u = 1 - t
    pts.push((
      u * u * p0.at(0) + 2 * u * t * c.at(0) + t * t * p1.at(0),
      u * u * p0.at(1) + 2 * u * t * c.at(1) + t * t * p1.at(1),
    ))
  }
  pts
}

// 二次贝塞尔曲线上参数 t 处的点
#let qpt(p0, c, p1, t) = (
  (1 - t) * (1 - t) * p0.at(0) + 2 * t * (1 - t) * c.at(0) + t * t * p1.at(0),
  (1 - t) * (1 - t) * p0.at(1) + 2 * t * (1 - t) * c.at(1) + t * t * p1.at(1),
)

// 电场线:自右上端画向左下端,箭头位于左下端、指向左下
#let field-line(p0, c, p1) = draw.line(
  ..qbez(p0, c, p1).rev(),
  stroke: (..lw, paint: field-color),
  mark: (end: (symbol: ">", fill: field-color, scale: 0.72)),
)

// 等势线:粉色弧线
#let equi(p0, c, p1) = draw.line(
  ..qbez(p0, c, p1),
  stroke: (..lw, paint: equi-color),
)

// 黑色标注点
#let dot(p) = draw.circle(p, radius: 0.05, fill: black, stroke: none)

// ===== 图 10.2-4 =====
#align(center, block({
  canvas(length: 1cm, {
    // 等势线(粉色弧线,自内向外)
    equi((1.89, 6.23), (-2.19, 4.90), (1.93, 0.26))
    equi((3.16, 6.58), (-0.26, 4.49), (3.16, 0.44))
    equi((3.95, 6.88), (2.95, 4.11), (4.56, 0.70))
    equi((4.42, 6.86), (6.34, 3.92), (5.35, 0.74))

    // 电场线(青色曲线,箭头指向左下方)
    field-line((0.40, 3.05), (2.45, 5.35), (4.55, 6.85))
    field-line((0.82, 2.28), (3.20, 3.95), (5.75, 4.95))
    field-line((1.17, 1.58), (3.90, 3.75), (6.05, 3.07))
    field-line((1.58, 1.35), (3.60, 1.85), (6.01, 1.81))

    // A、B 两点及其标注(A 在标 E 的电场线上,B 在其下方一条电场线上)
    let pa = qpt((0.82, 2.28), (3.20, 3.95), (5.75, 4.95), 0.13)
    let pb = qpt((1.17, 1.58), (3.90, 3.75), (6.05, 3.07), 0.60)
    dot(pa)
    dot(pb)
    draw.content((pa.at(0) - 0.05, pa.at(1) + 0.38), [$A$])
    draw.content((pb.at(0) + 0.32, pb.at(1) + 0.40), [$B$])

    // 电场线标签 E
    draw.content((6.25, 4.95), [$E$])
  })
  v(0.4em)
  [图 10.2-4]
}))
