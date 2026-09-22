
// #import "@preview/itemplate:0.1.5": *
// #show: contents => itemplate(doc-title: "物理必修三练习题", doc-author: "HeXiongwu", contents)


#import "@preview/theoframe:0.4.1": *
#show: theoframe-setup.with(theme: (style: "box", color: rgb("#067300")))

#import "@preview/unify:0.8.1": *

#import "@preview/invaria:0.2.0"
#import invaria.codata2022.universal: *
#import invaria.codata2022.atomic-and-nuclear: *
#import invaria.codata2022.electromagnetic: *

#import "@preview/cetz:0.5.2"

#show math.equation: set block(breakable: true)

#set text(lang: "zh")
// #set page(paper: "a4", margin: 2cm)
// #set heading(numbering: "1.")

= 电场和电场强度


#problem(name: [用一条绝缘轻绳悬挂一个带正电小球，小球质量为$1.0×10^(-3)$  kg，所带电荷量为
  $2.0×10^(-8)$  C。现加水平方向的匀强电场，平衡时绝缘绳与竖直方向夹角为30°。求匀强电场的电场强度。])[

  #set align(center)

  #figure(
    caption: [匀强电场中的一个带电小球],
    numbering: "1.",
    // _ => context counter(figure.where(kind: "diagram")).display("1.")
    kind: "diagram",
    supplement: [图],
  )[
    #cetz.canvas(length: 0.7cm, {
      import cetz.draw: *
      let (P0, P1, P2, P3, P4, P5, P6, P7) = ((0, 0), (0, -1), (0, -2), (0, -3), (0, -4), (0, -5), (0, -6), (0, -7))
      let Pq = (rel: (-60deg, 6.5), to: P0)
      rect((-0.5, 0), (0.5, 0.2), fill: gradient.linear(dir: ttb, rgb("#eeeeee"), rgb("#999999")), stroke: none)
      let points = (P1, P2, P3, P4, P5, P6)
      for p in points {
        set-style(line: (
          stroke: (paint: rgb("#55aaaa"), thickness: 1pt),
          mark: (end: (symbol: "stealth", fill: rgb("#55aaaa"))),
        ))
        line((rel: (-4, 0), to: p), (rel: (4, 0), to: p))
      }
      set-style(line: (stroke: (paint: rgb("#6e6e6e"), dash: "dashed", thickness: 1pt), mark: none))
      line(P0, P7)
      set-style(line: (stroke: (paint: rgb("#6e6e6e"), dash: "solid", thickness: 1pt), mark: none))
      line(P0, Pq)

      set-style(content: (
        frame: "circle",
        fill: gradient.radial(rgb("#eeeeee8a"), rgb("#3a3a3ab6")),
        padding: 1pt,
        stroke: none,
      ))
      on-layer(2, {
        content(Pq, [#text(size: 11pt, fill: rgb("#55eeeee2"))[q]], anchor: "center")
      })
      set-style(content: (
        frame: none,
        stroke: none,
      ))
      cetz.angle.angle(
        P0,
        P7,
        Pq,
        radius: 1.2,
        direction: "ccw",
        mark: (end: ">", fill: black, scale: 0.6),
        label: $30^o$,
        label-radius: 1.8,
      )
      set-style(line: (
        stroke: (paint: rgb("#030303"), dash: "solid", thickness: 1pt),
        mark: (end: (symbol: "stealth", fill: rgb("#0a0a0a"), scale: 0.5)),
      ))
      let Pl = (rel: (120deg, 1.5 * 2), to: Pq)
      let Pe = (rel: (1.5, 0), to: Pq)
      let Pg = (rel: (0, -1.5 * calc.tan(60deg)), to: Pq)
      line(Pq, Pl, name: "LineP")
      line(Pq, Pe, name: "LineE")
      line(Pq, Pg, name: "LineG")
      content(Pl, $F_P$, anchor: "south-west", padding: 2pt)
      content(Pe, $F_E$, anchor: "west", padding: 2pt)
      content(Pg, $F_G$, anchor: "north", padding: 2pt)
    })
  ]

  #set align(left)
  因为：$F_P dot cos(30^o) = F_G$ \
  且：$F_P dot sin(30^o) = F_E$ \
  所以：$F_E = F_G dot tan(30^o)$ \
  又因为：$F_E = q E$ \
  所以：$ E & =(m g) /q \
    & = 4.9 dot 10^5 "N/C" $
]

#problem(name: [如下图，真空中有两个点电荷，Q1为4.0×10-8 C 、Q2 为-1.0×10-8 C，分别固定
  在x 轴的坐标为0 和6 cm 的位置上。
  + x 轴上哪个位置的电场强度为0 ？
  + x 轴上哪些位置的电场强度的方向是沿 x 轴的正方向的？
])[
  #set align(center)

  #figure(
    caption: [两个异号不等量电荷的电场分布情况],
    numbering: "1.",
    // _ => context counter(figure.where(kind: "diagram")).display("1.")
    kind: "diagram",
    supplement: [图],
  )[
    #cetz.canvas(length: 0.8cm, {
      import cetz.draw: *
      set-style(line: (mark: (end: (symbol: "stealth", fill: black))))
      let (_P1, P0, P1, P2, P3, P4, P5, P6, P7, P8) = (
        (-1, 0),
        (0, 0),
        (1, 0),
        (2, 0),
        (3, 0),
        (4, 0),
        (5, 0),
        (6, 0),
        (7, 0),
        (8, 0),
      )
      line(_P1, P8)
      let P_Collection = (P0, P1, P2, P3, P4, P5, P6)
      // P_Collection.forEach((p)=> line(p, (rel:(0,0.1), to:p)))
      set-style(line: (mark: none))
      for p in P_Collection {
        line(p, (rel: (0, 0.1), to: p))
        content(p, [#p.at(0)], anchor: "north", padding: 0.5em)
      }
      content(P8, [x/cm], anchor: "north", padding: 0.5em)
      content(P0, text(size: 8pt)[$Q_1$], anchor: "south", padding: 0.25cm)
      content(P6, text(size: 8pt)[$Q_2$], anchor: "south", padding: 0.25cm)
      set-style(content: (
        frame: "circle",
        padding: 0.1pt,
        fill: gradient.radial(rgb("#eeeeee"), rgb("#449999")),
        stroke: none,
      ))
      content(P0, text(size:6pt)[$ + $])
      content(P6, text(size:8pt)[$ - $])
    })
  ]
  #set align(left)
  #let k = 1 / (4 * calc.pi * vacuum-electric-permittivity.val)
  (1) 由图可知：
  - 当 x < 0时，正电荷的电场指向x轴负方向，负电荷的电场指向x轴正方向，由于距离正电荷更近，而且正电荷的电荷量更大，合电场方向由正电荷的电场决定，即指向x轴负方向。
  - 当 0 < x < 6 时，正负电荷的电场都指向x轴正方向
  - 当 x > 6 时，正电荷的电场指向x轴正方向，负电荷的电场指向x轴负方向

    $ E_x = k dot 10^4 (Q_1/(x-0)^2 + Q_2/(x-6)^2 ) quad "定义域：" x > 6 $
    因为：$k &= qty("8.99e9", "N m^2 C^-2")$ \
    则：$E_x &= 8.99 dot 10^9 times 1.0 dot 10^(-8) times 10^4 (4/x^2 - 1/(x-6)^2)$ \
    令：$E_x = 0$ \
    得等价表达式：$x^2 = 4(x-6)^2$ \
    即：$3 x^2 -48 x + 144 = 0$ \
    即：$x^2 - 16 x + 48 = 0$ \
    即：$(x-4)(x-12) = 0$ \
    解得：$x = 12 "或者" 4("舍去")$
  (2) 在$x>6$的范围内：

  $ E_x = k (Q_1/(x-0)^2 + Q_2/(x-6)^2 ) quad "定义域：" x > 6 $
  令：$E_x > 0$， 得：$x > 12 "或者" x < 4 ("舍去")$
]

// #html.elem(
//   "div",
//   attrs: (
//     style: "background: white; margin: 20px; width: 95%; aspect-ratio: 1.5; display: flex; justify-content: center; align-items: center; position: relative;",
//     id: "electric-field-wrapper",
//     class: "three-animation",
//   ),
//   html.elem("canvas", attrs: (
//     id: "electric-field-canvas",
//     style: "width: 100%; height: 100%; display: flex; justify-content: center; align-items: center",
//   )),
// )
// #html.elem("p", attrs: (id: "electric-field-text", style: "white-space: pre-wrap"))
// #html.script(
//   type: "module",
//   src: "../electric-field.js",
// )

#note(name: [点电荷周围球面的采样方案])[
  平分极角和方位角方案：通过平分球坐标中的极角$phi$和方位角$theta$采样得到的采样点之间的直线距离是不相等的，这会导致靠近极角的位置单位面积上的采样点数量更多。

  为什么需要均匀采样？ \
  因为在点电荷表面（即围绕点电荷的球面）上，电场线的密度与方向无关。
  具体原因如下：
  - 球对称性：点电荷的电场具有球对称性，以点电荷为中心作一个球面，球面上各点到点电荷的距离相同。根据点电荷场强公式$E = k Q \/ r^2$ ，球面上各点的电场强度大小相等。
  - 密度反映场强大小：电场线的疏密程度（即单位垂直面积内穿过的电场线条数）代表该处电场强度的大小。既然球面上各点场强大小相同，那么电场线的密度在球面上各处也相同。
  - 方向沿径向但各不相同：虽然球面上各点电场线的方向不同（正点电荷向外辐射，负点电荷向内汇聚），但方向的不同并不影响密度。方向由电场线的切线方向表示，而密度由电场线的疏密程度表示，两者是电场线的两个独立属性。
  - 总结：在以点电荷为中心的球面上，电场线密度处处相同，但方向各不相同——密度只与到场源的距离有关，与方向无关。
]

#theorem(name: [电场的高斯定理（积分形式）])[
  $ integral.surf_S arrow(E) dot d arrow(A) = Q_"enc" / epsilon_0 $

  其中各符号的含义为：
  - $integral.surf_S$  ：表示对闭合曲面 S 进行面积分（闭合曲面积分）
  - $arrow(E)$ ：电场强度矢量
  - $d arrow(S)$：曲面上的面积元矢量，方向取曲面的外法向
  - $Q_"enc"$：闭合曲面 S 内部所包围的净电荷（电荷的代数和）
  - $epsilon_0$ ：真空介电常数，约为 $#qty("8.85e-12", "F m^-1")$
  #linebreak()
  物理意义：
  - 高斯定理的积分形式表明：通过任意闭合曲面的电通量，等于该曲面内所包围的净电荷除以真空介电常数。
  这一定理揭示了几个重要性质：
  - 静电场是有源场：电场线始于正电荷、终于负电荷，电荷就是电场的"源"。
  - 曲面外电荷对总通量无贡献：闭合曲面外部的电荷虽然会影响曲面上各点的电场强度，但它们穿入又穿出曲面，对总电通量的净贡献为零。
  - 高斯面形状任意：闭合曲面可以是任意形状，只要完全包围所关心的电荷即可。
]<thm:Gauss-law>

#corollary(name: [电场线数目N必须正比于电荷量Q])[
  - 如果我们把每条电场线看作代表固定大小的电通量（比如 $Delta Phi_E$）
  - 那么从电荷 Q 发出的总电场线数 N 满足：$N dot Delta Phi_E = abs(Q_"enc") / epsilon_0$
  - 因此：$N prop abs(Q_"enc")$
]


= 库仑定律

#example(
  name: [在氢原子内，氢原子核与电子之间的最短距离为$5.3 times 10^(-11)$  m。试比较氢原子核与电子之间的静电力和万有引力。],
)[
  #let r = 5.3e-11

  万有引力：
  #let FG = newtonian-constant-of-gravitation.val * proton-mass.val * electron-mass.val / calc.pow(r, 2)
  //  &= (#qty("6.67e-11", newtonian-constant-of-gravitation.unit) times #qty("1.67e-27", proton-mass.unit) times #qty("9.11e-31", electron-mass.unit) )/(5.3 times 10^(-11) "m")^2 \
  $
    F_G & = (G m_p m_e)/r^2 \
        & = #qty("3.62e-47", "N") \
  $

  #let coulomb-constant = 1 / (4 * calc.pi * vacuum-electric-permittivity.val)
  #let FE = coulomb-constant * elementary-charge.val * elementary-charge.val / calc.pow(r, 2)
  #let FE-FG = FE / FG

  静电力：
  $
    F_E & = ( k_e Q_p Q_e )/ r^2 \
        & = #qty("8.21e-8", "N") \
  $

  静电力与万有引力之比：
  $ F_E / F_G = #qty("2.26e39", "1") $
]

#example(
  name: [真空中有三个带正电的点电荷，它们固定在边长为 50 cm 的等边三角形的三个顶点上，每个点电荷的电荷量都是 $2.0 times 10^(-6)$ C，求它们各自所受的静电力。],
)[
  #set align(center)

  #figure(
    caption: [位于等边三角形三个顶点处的电荷],
    numbering: "1.",
    // _ => context counter(figure.where(kind: "diagram")).display("1.")
    kind: "diagram",
    supplement: [图],
  )[
    #cetz.canvas(length: 1.5cm, {
      import cetz.draw: *
      // Your drawing code goes here
      let (Q1, Q2, Q3) = ((0, calc.sqrt(3)), (-1, 0), (1, 0))
      let P23 = (rel: (1, 0), to: Q3)
      let P13 = (rel: (-60deg, 1), to: Q3)
      let Pend = (rel: (1, 0), to: P13)
      line(Q1, Q2, Q3, close: true)
      content(Q1, [q1], anchor: "south", padding: 10pt)
      content(Q2, [q2], anchor: "east", padding: 10pt)
      content(Q3, [q3], anchor: "south", padding: 10pt)

      content(P13, [F13], anchor: "north", padding: 5pt)
      content(P23, [F23], anchor: "south", padding: 5pt)
      content(Pend, [$F_"total"$], anchor: "north-west", padding: 5pt)

      set-style(mark: (fill: red, scale: 1))
      set-style(line: (stroke: red))
      line(Q3, P23, mark: (end: "stealth"), name: "F23")
      line(Q3, P13, mark: (end: "stealth"), name: "F13")
      line(Q3, Pend, mark: (end: "stealth"), name: "Fpend")
      line(P13, Pend, P23, stroke: (dash: "dotted"))

      set-style(content: (frame: "circle", stroke: none, fill: luma(80%), padding: 1pt))
      content(Q1, [+], anchor: "center")
      content(Q2, [+], anchor: "center")
      content(Q3, [+], anchor: "center")
    })
  ]

  #set align(left)
  如上图所示: 由于 q1, q2 和 q3所处的空间位置呈现出特定的对称关系，而且每个点电荷的电荷量都相等，从图示可以看出，q1, q2和q3的静电力大小都相等，仅方向不同。

  取q3作为研究对象，记它受到来自q1的力为$arrow(F)_(13)$，记它受到来自q2的力为$arrow(F)_(23)$，力的方向如图所示。
  #let Q = 2e-6;
  #let r = 0.5;
  #let coulomb-constant = 1 / (4 * calc.pi * vacuum-electric-permittivity.val)
  #let F = coulomb-constant * Q * Q / calc.pow(r, 2)
  $
    norm(arrow(F)_(13)) = norm(arrow(F)_(23)) & = k_e Q^2 / r^2 \
    & = #qty("8.98e9", "mF^-1") dot (#qty("2e-6", "C"))^2 /( #qty("5e-1", "m") )^2 \
    & = #calc.round(F, digits: 3) "N"
  $

  记 q3受到的静电力合力为$arrow(F)_"total"$，由图中的几何关系可知：
  $
    arrow(F)_"total" & = arrow(F)_(13) + arrow(F)_(23) \
                     & = sqrt(3) norm(arrow(F)_(13)) \
                     & = #calc.round(calc.sqrt(3) * F, digits: 2) "N"
  $

  如图所示，$arrow(F)_"total"$的方向为向外的角平分线方向。 \
  由对称关系可知 q1 和 q2的静电力合力的大小等于$arrow(F)_"total"$的大小，方向为各自所在点处向外的角平分线方向。
]




#problem(name: [有三个完全相同的金属球，球A 带的电荷量为q，球B 和球C 均不带电。现要使球B 带
  的电荷量为 $(3 q) / 8$ ，应该怎么操作？])[
  $
    (3 q) / 8 & = ( (2 q) / 8 + ( 4 q)/8 ) /2 \
              & = ( q/ 4 + q/2)/2
  $
  先让球A与B接触，使球A和球B带电 $q / 2$，再让球B与C接触，使球B和球C带电 $q / 4$，再让球B与球A接触，使球A和球B带电 $(3 q) / 8$。
]


#problem(name: [ 半径为r  的两个金属球，其球心相距3r，现使两球带上等量的同种电荷Q，两球之间的
  静电力$F = k Q^2 / (9 r^2)$吗？说明理由。])[
  - 由于两球距离仅为半径的三倍，不可使用点电荷模型。
  - 由于静电感应，而且同种电荷相互排斥，电荷分布会集中在两球外侧（相背的一面）。使得电荷之间的等效距离大于3r，从而导致静电力小于$F = k Q^2 / (9 r^2)$。
]

#problem(name: [真空中两个相同的带等量异种电荷的金属小球A 和B（均可看作点电荷），分别固定在
  两处，两球之间的静电力为F。现用一个不带电的同样的金属小球C 先与A 接触，再与B 接触，然后移开C，此时A、B 之间的静电力变为多少？若再使A、B 之间距离增大为原来的2倍，则它们之间的静电力又为多少？])[
  设接触前 $Q_A = Q$，$Q_B = -Q$，$Q_C = 0$，$F_"AB" = - k Q^2 / d_"AB"^2$ \
  + 球C与A接触后：$Q_A^' = Q_C^' = Q/2$，$Q_B^' = -Q$ \
  + 球C与B接触后：$Q_A^'' = Q/2$，$Q_B^''= Q_C^'' = -Q/4$ \
    此时的静电力为$F_"AB"^'' = - k Q^2 / (8 d_"AB"^2 ) = 1/8 F_"AB"$
  + 如果再将A、B 之间距离增大为原来的2倍，即：$d_"AB"^''' = 2 d_"AB"$
    则：$F_"AB"^''' = 1 / 32 F_"AB"$
]


#problem(
  name: [在边长为a 的正方形的每个顶点都放置一个电荷量为q 的同种点电荷。如果保持它们的位置不变，每个电荷受到其他三个电荷的静电力的合力是多少？],
)[
  #set align(center)

  #figure(
    caption: [位于正方形四个顶点处的电荷],
    numbering: "1.",
    kind: "diagram",
    supplement: [图],
  )[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *
      let (p1, p2, O, p3, p4) = ((-1, -1), (1, -1), (0, 0), (1, 1), (-1, 1))
      let p12 = (rel: (0deg, 2), to: p2)
      let p32 = (rel: (-90deg, 2), to: p2)
      let p1232 = (rel: (-45deg, 2 * calc.sqrt(2)), to: p2)
      let p42 = (rel: (-45deg, calc.sqrt(2)), to: p2)
      let p-total = (rel: (-45deg, 3 * calc.sqrt(2)), to: p2)
      line(p1, p2, p3, p4, close: true)
      content(p1, [q1], anchor: "north", padding: 5pt)
      content(p2, [q2], anchor: "north-east", padding: 5pt)
      content(p3, [q3], anchor: "south", padding: 5pt)
      content(p4, [q4], anchor: "south", padding: 5pt)
      set-style(line: (stroke: (paint: red, dash: "dotted")), mark: (fill: red, scale: 1))
      line(p2, p12, mark: (end: "stealth"))
      line(p2, p32, mark: (end: "stealth"))
      line(p2, p42, mark: (end: "stealth"))
      line(p2, p-total, stroke: (paint: luma(50%), dash: "solid"), mark: (end: "stealth", fill: luma(50%)))
      content(p12, $arrow(F)_(12)$, anchor: "south", padding: 5pt)
      content(p32, $arrow(F)_(32)$, anchor: "east", padding: 5pt)
      content(p42, $arrow(F)_(42)$, anchor: "north-east", padding: 5pt)
      content(p-total, $arrow(F)_"total"$, anchor: "north-east", padding: 5pt)
      line(p12, p1232, p32, stroke: (paint: orange, dash: "dotted"))
      line(p2, p1232, stroke: (paint: orange, dash: "dotted"), mark: (end: "stealth"))
      content(p1232, $arrow(F)_(1232)$, anchor: "west", padding: 5pt)
    })
  ]


  #set align(left)
  因为：
  q1 = q2 = q3 = q4 = q \
  $ norm(arrow(F)_(12)) = norm(arrow(F)_(32)) = k q^2 / a^2 $ \
  $ norm(arrow(F)_(42)) = k q^2 / (2 a^2) $ \
  $
    arrow(F)_(1232) & = arrow(F)_(12) + arrow(F)_(32) \
                    & = sqrt(2) dot k q^2 / a^2
  $
  $
    arrow(F)_"total" & = arrow(F)_(1232) + arrow(F)_(42) \
                     & = (sqrt(2) + 1/2) dot k q^2 / a^2
  $
  q2受到的合力大小为$arrow(F)_"total"$的大小，方向如图所示，沿着q2位置的外角平分线方向。
  由对称关系可知其余三个电荷的受力情况。
]


#problem(
  name: [ 两个分别用长13 cm 的绝缘细线悬挂于同一点的相同小球（可看作质点），带有同种等量电荷。由于静电力F 的作用，它们之间的距离为 10cm。已测得每个小球的质量是0.6 g，求它们各自所带的电荷量。g 取$10 "m"\/ "s"^2$。],
)[
  #set align(center)

  #figure(
    caption: [悬挂在绝缘细线上的带电小球],
    numbering: "1.",
    kind: "diagram",
    supplement: [图],
  )[
    #cetz.canvas(length: 3cm, {
      import cetz.draw: *
      let O = (0, 0)
      let (p1, p3) = ((-0.5, 0), (0.5, 0.05))
      let (b1, b2) = ((-0.5, -1.2), (0.5, -1.2))
      let c = (0, -1.2)
      line(O, c, stroke: (paint: luma(50%), thickness: 1pt, dash: "dotted"))
      content(O, [O], anchor: "south", padding: 5pt)
      content(c, [c], anchor: "east", padding: 5pt)

      rect(p1, p3, fill: gradient.linear(dir: ttb, luma(90%), luma(60%)), stroke: none)
      set-style(line: (stroke: (paint: rgb("#048e6098"), dash: "solid")))
      line(O, b1)
      line(O, b2)
      set-style(circle: (
        fill: gradient.radial(luma(90%), luma(50%)),
        stroke: (paint: luma(30%), thickness: 1pt, dash: "solid"),
      ))
      on-layer(-2, {
        circle(b1, radius: 0.1, name: "ball1")
        circle(b2, radius: 0.1, name: "ball2")
      })
      set-style(line: (stroke: black + 1pt))
      line(
        (rel: (0, -0.1), to: "ball1.south"),
        (rel: (0, -0.1), to: "ball2.south"),
        mark: (symbol: "stealth", fill: black),
        name: "distance",
      )

      line((rel: (0, -0.05), to: "distance.start"), (rel: (0, 0.05), to: "distance.start"))
      line((rel: (0, -0.05), to: "distance.end"), (rel: (0, 0.05), to: "distance.end"))
      content("distance", [10cm], anchor: "north", padding: 5pt)
      set-style(line: (stroke: red, mark: (end: (symbol: "stealth", fill: red))))

      line(b1, (rel: (-0.25, 0), to: b1), name: "F1")
      line(b2, (rel: (0.25, 0), to: b2), name: "F2")
      content("F1.end", $arrow(F)$, anchor: "east", padding: 5pt)
      content("F2.end", $arrow(F)$, anchor: "west", padding: 5pt)

      set-style(
        line: (stroke: (paint: luma(50%), dash: "densely-dotted"), mark: (end: (symbol: "stealth", fill: luma(50%)))),
      )
      line((rel: (-0.5, 0), to: b2), (rel: (1, 0), to: b2), name: "x")
      line((rel: (0, -1), to: b2), (rel: (0, 1), to: b2), name: "y")
      content("x.end", [x], anchor: "west", padding: 5pt)
      content("y.end", [y], anchor: "south", padding: 5pt)

      let b2O-middle = ((b2.at(0) + O.at(0)) / 2, (b2.at(1) + O.at(1)) / 2)
      on-layer(2, {
        line(b2, b2O-middle, name: "Fp", stroke: (dash: "solid"))
      })
      content("Fp.end", $arrow(F)_p$, anchor: "east", padding: 5pt)
      let py = (b2.at(0), b2O-middle.at(1))
      let px = (b2O-middle.at(0), b2.at(1))

      line(b2, px, name: "Fx")
      line(b2, py, name: "Fy")

      content("Fx.end", $arrow(F)_x$, anchor: "north", padding: 5pt)
      content("Fy.end", $arrow(F)_y$, anchor: "west", padding: 5pt)
      set-style(line: (stroke: (paint: luma(50%), dash: "densely-dotted"), mark: none))
      line(px, b2O-middle, py)
      let pg = (rel: (0, -0.6), to: b2)
      set-style(
        line: (stroke: (paint: luma(50%), dash: "solid"), mark: (end: (symbol: "stealth", fill: luma(50%)))),
      )
      line(b2, pg, name: "Fg")
      content("Fg.end", $arrow(F)_g$, anchor: "west", padding: 5pt)
      on-layer(-1, {
        content(
          b2,
          [b],
          frame: "circle",
          stroke: none,
          fill: gradient.radial(rgb("#eeeeeef1"), rgb("#aaaaaaf1")),
          padding: 1pt,
        )
      })
    })
  ]


  #set align(left)
  因为：$F_g = m g$ \
  由相似三角形可知：\
  $ (norm(arrow(F)))/"cb" = (norm(arrow(F)_g))/"Oc" $
  $
    => norm(arrow(F)) & = norm(arrow(F)_g) * "cb" / "Oc" \
                      & = m g * "cb" / "Oc" \
                      & = #qty("0.6", "g") times #qty("10", "m s^-2") times 5 / 12 \
                      & = #qty("2.5e-3", "N") \
  $

  #let F = 2.5e-3;
  #let r = 0.1;
  #let k = 1 / (4 * calc.pi * vacuum-electric-permittivity.val)
  #let q = calc.sqrt((F * calc.pow(r, 2)) / k)

  由库伦定律得：
  $ F = k q^2 / r^2 $

  则，电荷量：
  $
    q & = sqrt((F r^2) / k) \
      & = #qty("5.27e-8", "C") \
  $
]


= 电荷
省略
