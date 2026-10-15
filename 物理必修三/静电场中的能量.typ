
#import "@preview/typewind:0.2.0": *

#import "@preview/itemplate:0.5.0": *
#show: itemplate.with(doc-title: "静电场中的能量")

#import "@preview/theoframe:0.4.2": *
#show: theoframe-setup.with(theme: (style: "box", color: emerald-800))
#show heading.where(level: 2): h2 => reset-fig-counter-per-heading(h2)

#import "@preview/cetz:0.5.2"

#import "@preview/zap:0.6.0"

#import "@preview/unify:0.8.1": *

#import "@preview/invaria:0.2.0"
#import invaria.codata2022.universal: *
#import invaria.codata2022.atomic-and-nuclear: *
#import invaria.codata2022.electromagnetic: *


#show math.equation: set block(breakable: true)
#show enum: set enum(numbering: "(1)")
#set par(leading: 1em, spacing: 1.5em)
#set text(lang: "zh")
// #set page(width:10cm, height:20cm, margin: (x:0.5cm,y:1cm))
// #set page(paper: "a4", margin: 2cm)
// #set heading(numbering: "1.")

// #show math.equation.where(block: true): pad.with(bottom:0.1em)
// #show math.equation.where(block: true): set align(left)

#show heading.where(level: 1): set text(weight: "bold")
#show heading.where(level: 1): set text(fill: emerald-800)
#show heading.where(level: 2): set text(fill: emerald-800)
// #outline()


// #html.elem(
//   "div",
//   attrs: (
//     style: "background: white; margin: 20px; width: 95%; aspect-ratio: 1.5; display: flex; justify-content: center; align-items: center; position: relative;",
//     id: "equipotential-surface-wrapper",
//     class: "three-animation",
//   ),
//   html.elem("canvas", attrs: (
//     id: "equipotential-surface-canvas",
//     style: "width: 100%; height: 100%; display: flex; justify-content: center; align-items: center",
//   )),
// )
// #html.elem("p", attrs: (id: "electric-field-text", style: "white-space: pre-wrap"))
// #html.script(
//   type: "module",
//   src: "../three/equipotential-surface.js",
// )



= 静电场中的能量

== 电势能和电势

#problem(
  name: [如图所示，在电场强度为60  N/C 的匀强电场中有A、B、C 三个点，AB 为5 cm，BC 为 12 cm，其中AB 沿电场方向，BC 和电场方向的夹角为60°。将电荷量为$4 × 10^(-8)$ C 的正电荷从A 点移到B 点，再从B 点移到C 点，静电力做了多少功？若将该电荷沿直线由A 点移到C 点，静电力做的功又是多少？],
)[
  #set align(center)
  #figure(
    caption: [匀强电场中的静电力做功],
    numbering: "1.",
    kind: "diagram",
    supplement: [图],
  )[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *
      let (P0, P1, P2, P3) = ((0, 4), (0, 3), (0, 2), (0, 1))
      set-style(line: (
        stroke: (paint: rgb("#55aaaa"), thickness: 1pt),
        mark: (end: (symbol: "stealth", fill: rgb("#55aaaa"), scale: 0.5)),
      ))
      for p in (P0, P1, P2, P3) {
        line(p, (rel: (4, 0), to: p))
      }

      let (A, B) = ((1, 1.5), (2, 1.5))
      let C = (rel: (60deg, 2.4), to: (2, 1.5))
      set-style(line: (stroke: (paint: rgb("#555555"), thickness: 1pt), mark: none))
      line(A, B, C)
      set-style(circle: (stroke: none, fill: black, radius: 2pt))
      circle(A)
      circle(B)
      circle(C)
      content(A, [A], padding: 2pt, anchor: "north-east")
      content(B, [B], padding: 2pt, anchor: "north-west")
      content(C, [C], padding: 2pt, anchor: "south-east")

      let O = (rel: (1.5, 0), to: B)
      line(B, O, stroke: (dash: "dashed", thickness: 0.5pt))
      cetz.angle.angle(B, O, C, label: "60°", radius: 0.3, label-radius: 0.6)

      let E = (3.5, 2.5)
      content(E, [#text(fill: rgb("#55aaaa"))[E]])
    })
  ]
  #set align(left)
  #let q = 4e-8
  #let E = 60
  #let F_C = q * E
  #let AB = 0.05
  #let BC = 0.12
  #let W_AB = F_C * AB
  #let W_BC = F_C * BC * calc.cos(60deg)
  #let W_total = W_AB + W_BC

  $W_"AB" &= q E dot "AB" \ &= qty("1.2e-7", "J")$ \

  $W_"BC" & = q E dot "BC" dot cos(60^o) \ & = qty("1.44e-7", "J")$ \

  $W_"总" & = W_"AB" + W_"BC" \ & = qty("2.64e-7", "J")$ \
  静电力做功与路径无关，仅与电荷的初始和终止位置有关。 \
  所以，沿直线移动的时静电力做功同样等于上述数值。
]


#problem(
  name: [电荷量q1 为$4 times 10^(-9)$ C 的试探电荷放在电场中的A 点，具有$6 times 10^(-8)$ J 的电势能。A 点的电势是多少？若把q2 为$-2 times 10^(-10)$ C 的试探电荷放在电场中的A 点，q2 所具有的电势能是多少？],
)[

  $
    phi_A & = E_(p,1)/q_1 \
          & = 15 "V"
  $

  $E_(p,2) &= q_2 dot phi_A \ &= -3 times 10^(-9) "J"$ \
]

#problem(
  name: [如图，A、B 是点电荷电场中同一条电场线上的两点，把电荷量  q1 为  $10^(-9)$  C  的试探电荷从无穷远移到A 点，静电力做的功为 $4×10^(-8)$ J ； 把  q2  为$－2×10^(-9)$ C 的试探电荷从无穷远移到 B 点，静电力做的功为 $－6×10^(-8)$ J。请判断：场源电荷是正电荷还是负电荷？场源电荷的位置是在A、B 的左边还是右边？],
)[
  #figure(caption: [判断场源电荷的正负和位置], kind: "diagram", numbering: "1.", supplement: [图])[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *
      let (A, B) = ((-1, 0), (1, 0))
      line((-2.5, 0), (2.5, 0))
      content(A, [A], anchor: "south", padding: 3pt)
      content(B, [B], anchor: "south", padding: 3pt)
      set-style(circle: (stroke: none, fill: black, radius: 2pt))
      circle(A)
      circle(B)
    })
  ]

  取无穷远处为该点电荷电场的零电势点，即$phi_infinity = 0$：

  $W_(q_1, infinity -> A) &= E_p (q_1, infinity) - E_p (q_1, A) \ &= - E_p (q_1, A)$ \
  // $ => E_(q_1, A) = - W_(q_1, infinity-> A) $ \
  $phi_A &= (E_p (q_1, A))/q_1 \ &= - W_(q_1, infinity -> A)/q_1 \ &= - 40 "V"$ \

  $phi_B &= (E_p (q_2, B))/q_2 \ &= - W_(q_2, infinity -> B)/q_2 \ &= - 30 "V"$ \

  由于$phi_infinity = 0 > phi_B > phi_A$，所以场源电荷是负电荷，且在A 点的左边。

]


#problem(
  name: [一个电场中有A、B 两点，电荷量 q1  为$2×10^(-9)$ C 的试探电荷放在电场中的 A 点，具有  $－4×10^(-8)$ J 的电势能；q2  为$－3×10^(-9)$ C 的试探电荷放在电场中的 B 点，具有$9×10^(-8)$ J 的电势能。现把 q3 为$－5×10^(-9)$  C 的试探电荷由A 点移到B 点，静电力做正功还是负功？数值是多少？],
)[
  $phi_A &= (E_p (q_1, A))/q_1 \ &= -20 "V"$

  $phi_B &= (E_p (q_2, B))/q_2 \ &= -30 "V"$

  $W_(q_3,A->B) &= E_p (q_3, A) - E_p (q_3, B) \ &= q_3 (phi_A - phi_B) \ &= - 5 times 10^(-8) "J"$
]


#problem(
  name: [如图， A、B 为一对等量同种电荷连线上的两点（其中B 为中点），C 为连线中垂线上的一点。今将一个电荷量为q 的负点电荷自A 沿直线移到B 再沿直线移到C，请分析在此过程中该电荷的电势能的变化情况。],
)[
  #figure(caption: [等量同种电荷所产生的电势分布], kind: "diagram", numbering: none, supplement: [图])[
    #set text(size: 8pt)
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *
      let (p1, p2) = ((-2, 0), (2, 0))
      let (pa, pb, pc) = ((-1, 0), (0, 0), (0, 1))
      let (pd, pe) = ((0, -1.5), (0, 1.5))

      set-style(line: (stroke: (dash: "densely-dotted", paint: rgb("#55aa55"), thickness: 0.5pt)))
      line(p1, p2)
      line(pd, pe)

      for p in (pa, pb, pc) {
        circle(p, radius: 1pt, fill: black, stroke: none)
      }

      content(pa, [A], anchor: "north", padding: 2pt)
      content(pb, [B], anchor: "north-west", padding: 2pt)
      content(pc, [C], anchor: "west", padding: 2pt)

      set-style(content: (frame: "circle", fill: gradient.radial(rgb("#eeeeee"), rgb("#eeaaaa")), stroke: none))
      content(p1, $ + $)
      content(p2, $ + $)
    })
  ]
  - 从A点沿直线移动到B点，电势逐渐降低，由于电荷量为负，所以电势能增加。
  - 从B点沿直线移动到C点，电势逐渐降低，由于电荷量为负，所以电势能增加。
]

== 电势差


#example(name: [
  在匀强电场中把电荷量为 $2.0×10^(-9)$ C 的点电荷从 A 点移动到 B 点，静电力做的功为 $1.6 × 10^(-7)$ J。再把这个电荷从 B 点移动到 C 点，静电力做的功为$－ 4.0×10^(-7)$ J。 \
  （1）A、B、C 三点中，哪点电势最高？哪点电势最低？ \
  （2）A、B 间 ，B、C 间 ，A、C 间的电势差各是多大？ \
  （3）把电荷量为$－1.5×10^(-9)$ C 的点电荷从 A 点移动到 C 点，静电力做的功是多少？ \
  （4）根据以上结果，定性地画出电场分布的示意图，标出 A、B、C 三点可能的位置。
])[
  #let q = 2.0e-9
  #let W_AB = 1.6e-7
  #let W_BC = -4.0e-7

  #let U_AB = W_AB / q
  #let U_BC = W_BC / q
  (1) C 点电势最高，B 点电势最低。

  (2) \
  $W_"AB" = q U_"AB"$ \
  $U_"AB" = W_"AB" / q = #U_AB "V"$  \
  $U_"BC" = W_"BC" / q = #calc.round(U_BC, digits: 2) "V"$  \
  $U_"CB" = #calc.round(-U_BC, digits: 2) "V"$  \
  $U_"AC" = U_"AB" + U_"BC" = -120 "V"$ \

  (3) \
  #let q1 = -1.5e-9
  #let U_AC = U_AB + U_BC
  #let W_AC = q1 * U_AC
  $W_"AC" = q' U_"AC" = 1.8 times 10^(-7) "J"$ \

  (4)
  #figure(kind: "diagram", numbering: none)[
    #cetz.canvas(length: 0.8cm, {
      import cetz.draw: *
      let P = ((-3, 1), (-3, 0), (-3, -1))
      let B = (0, 0)
      let A = (-0.8, 0)
      let C = (-2, 0)
      for p in P {
        line(p, (rel: (6, 0), to: p), mark: (end: (symbol: "stealth", fill: black)))
        for p in (A, B, C) {
          circle(p, radius: 2pt, fill: luma(50), stroke: none)
        }
        content(A, [A], anchor: "south", padding: 5pt)
        content(B, [B], anchor: "south", padding: 5pt)
        content(C, [C], anchor: "south", padding: 5pt)
      }
    })
  ]
]




#exercise(name: [
  在某电场中，已知A、B 两点之间的电势差$U_"AB"$ 为 20 V，q 为$－2×10^(-9)$ C 的电荷由A 点移动到B 点，静电力做的功是多少？电势能是增加还是减少，增加或者减少多少？
])[
  $W_"AB" &= q U_"AB" \ &= -4 times 10^(-8) "J"$ \
  静电力做负功，电势能增加。 \
  $W_"AB" = E_p (A) - E_p (B)$ \
  $=> E_p (B) = E_p (A) - W_"AB"$ \
  即电势能增加$4 times 10^(-8)$ J。
]

#exercise(name: [
  在研究微观粒子时常用电子伏（eV）作为能量的单位。1  eV 等于一个电子经过1 V 电压加速后所增加的动能，那么，1  eV 等于多少焦耳？
])[
  $1 "eV" &= 1.602 times 10^(-19) "C" * 1 "V" \ &= 1.602 times 10^(-19) "J"$
]


== 电势差与电场强度的关系


#example(name: [
  如图，真空中平行金属板M、N之间的距离d为0.04 m，有一个$2×10^(-15)$ kg 的带电粒子位于 M 板旁，粒子的电荷量为 $8×10^(-15)$ C，给两金属板加 200 V 直流电压。\
  + 求带电粒子所受的静电力的大小。 \
  + 求带电粒子从 M 板由静止开始运动到达 N 板时的速度。 \
  + 如果两金属板距离增大为原来的 2 倍，其他条件不变，则上述问题（1）（2）的答案又如何？ \
])[
  #figure(kind: "diagram", numbering: none)[
    #cetz.canvas(length: 0.8cm, {
      import cetz.draw: *
      let (A, B, C, D) = ((-3, 1), (3, 1), (-3, -2), (3, -2))
      let (M, N) = ((-1, 1), (1, 1))
      let (E, F) = ((-1, -2), (1, -2))
      let U = (0, -2)
      line(C, A, M)
      line(N, B, D)
      let arrow-mark = (end: (symbol: "stealth", fill: black, scale: 0.5))

      circle(C, radius: 2pt, name: "positive")
      circle(D, radius: 2pt, name: "negative")
      line(E, "positive.east", mark: arrow-mark)
      line(F, "negative.west", mark: arrow-mark)

      line((rel: (0, -0.5), to: M), (rel: (0, 0.5), to: M))
      line((rel: (0, -0.5), to: N), (rel: (0, 0.5), to: N))

      content(U, [U])

      content(C, [$+$], anchor: "north", padding: 5pt)
      content(D, [$-$], anchor: "north", padding: 5pt)
      content(M, [M], anchor: "south-east", padding: 5pt)
      content(N, [N], anchor: "south-west", padding: 5pt)

      circle(
        (rel: (0.2, 0), to: M),
        radius: 0.2,
        stroke: none,
        fill: gradient.radial(rgb("#ffffff"), rgb("#7fc260")),
        name: "particle",
      )
      content("particle.center", [$ + $])
      line("particle.east", (rel: (0.5, 0), to: ()), stroke: red + 1pt, mark: arrow-mark)
    })
  ]
  (1) \
  #let d = 0.04
  #let m = 2e-15
  #let q = 8e-15
  #let U = 200
  #let E = U / d
  #let F = q * E
  平行金属板之间的电场可视为匀强电场，电场强度为：$E = U/d = 5000 "V/m"$ \
  带电粒子所受静电力为：$F = q E = 4.0 times 10^(-11) "N"$ \

  (2) 忽略重力的影响，仅考虑静电力的作用：\
  #let a = F / m
  #let t = calc.sqrt(2 * d / a)
  #let v = 0 + a * t
  由于：$d = 1/2 a * t^2$，解得：$t = sqrt((2d)/a) = 0.002 "s"$ \
  又因为：$v = a * t$，解得：$v = a * t = sqrt(2 a d) = 40 "m/s"$ \

  (3) \
  #let d = 0.08
  #let E = U / d
  #let F = q * E
  平行金属板之间的电场可视为匀强电场，电场强度为：$E = U/d = 2500 "V/m"$ \
  带电粒子所受静电力为：$F = q E = 2.0 times 10^(-11) "N"$ \

  忽略重力的影响，仅考虑静电力的作用：\
  #let a = F / m
  #let t = calc.sqrt(2 * d / a)
  #let v = 0 + a * t
  由于：$d = 1/2 a * t^2$，解得：$t = sqrt((2d)/a) = 0.004 "s"$ \
  又因为速度：
  #set math.equation(numbering: "(1)", supplement: [公式])
  $ v = a * t = sqrt(2 a d) = sqrt(2 (q E)/m d) = sqrt(2 (q U)/(d m) d) = sqrt((2 q U)/m) $<velocity>
  解得：$v = 40 "m/s"$ \
  将距离增大至原来的 2 倍，其他条件不变。结果是静电力变为原来的$1/2$，到达N板时的速度不变。 \
  由速度 @velocity 可知，粒子到达末端平行金属板的速度仅与粒子的带电量、平行金属板两端的电势差和粒子质量有关，与平行金属板之间的距离无关。 \ \
  由能量守恒原理可知：$E_k ("初") + E_p ("初") = E_k ("终") + E_p ("终")$ \
  带入相应表达式得：$0 + q phi_M = 1/2 m v^2 + q phi_N$ \
  整理得：$1/2 m v^2 = q (phi_M - phi_N) = q U$ \
  解得同样的表达式：$v = sqrt((2 q U)/m)$ \
]

#exercise(name: [
  空气是不导电的。但是如果空气中的电场很强，使得气体分子中带正、负电荷的微粒所受的方向相反的静电力很大，以至于分子“破碎”，空气中出现可以自由移动的电荷，空气就变成了导体。这个现象叫作空气的“击穿”。\

  一次实验中，电压为 $4×10^4$ V 的直流电源的两极连在一对平行金属板上，如果把两金属板的距离减小到 1.3 cm，两板之间就会放电。这次实验中空气被击穿时的电场强度是多少？
])[
  #let U = 4e4
  #let d = 1.3e-2
  #let E = U / d
  $ E = U / d = 3.08 times 10^6 "V/m" $
]

#exercise(name: [
  带有等量异种电荷、相距 10 cm 的平行板 A 和 B 之间有匀强电场，电场强度 E 为 $2×10^4$ V/m，方向向下。电场中 C 点距
  B 板 3 cm，D 点距 A 板 2 cm。 \
  （1）C、D 两点哪点电势高？两点的电势差$U_"CD"$ 等于多少？ \
  （2）如果把 B 板接地，则 C 点和 D 点的电势 $φ_C$ 和 $φ_D$ 各是多少？如果把 A 板接地，则 $φ_C$ 和 $φ_D$ 各是多少？在这两种情况中，$U_"CD"$ 相同吗？ \
  （3）一个电子从 C 点移动到 D 点，静电力做多少功？如果使电子从 C 点先移到 P 点，再移到 D 点，静电力做的功是否会发生变化？ \
])[
  #figure(kind: "diagram", numbering: none)[
    #set text(size: 8pt)
    #cetz.canvas(length: 0.2cm, {
      import cetz.draw: *

      let (M, B) = ((-1, -0.5), (21, 0))
      let (N, A) = ((-1, 10), (21, 10.5))
      let (Q, R, S, T) = ((0, 10), (20 / 3, 10), (40 / 3, 10), (20, 10))
      let (C, D, P) = ((10, 3), (10, 8), (20 / 6, 2.5))
      let arrow-mark = (end: (symbol: "stealth", fill: rgb("#85b196"), scale: 0.5))
      rect(N, A, fill: rgb("#caa044ce"), stroke: none)
      rect(M, B, fill: rgb("#caa044ce"), stroke: none)
      for p in (Q, R, S, T) {
        set-style(line: (stroke: rgb("#85b196"), mark: arrow-mark))
        line(p, (rel: (0, -10), to: p))
      }

      content(A, [A], anchor: "west", padding: 5pt)
      content(B, [B], anchor: "west", padding: 5pt)
      for p in (C, D, P) {
        circle(p, radius: 2pt, stroke: none, fill: black)
      }
      content(C, [C], anchor: "west", padding: 5pt)
      content(D, [D], anchor: "west", padding: 5pt)
      content(P, [P], anchor: "west", padding: 5pt)
    })
  ]

  (1) D点比C点电势更高 \
  #let E = 2e4
  #let CD = 5e-2
  #let UCD = -E * CD

  电势差：$U_"CD" = - E * d_"CD" = -1000 "V"$ \

  (2) 如果把B板接地，即：取B板的电势作为零电势点 \
  #let CB = 3e-2
  #let DB = 8e-2
  #let UCB = E * CB
  #let UDB = E * DB
  $phi_C = phi_B + U_"CB" = 600 "V"$ \
  $phi_D = phi_B + U_"DB" = 1600 "V"$ \
  $U_"CD" = phi_C - phi_D = -1000 "V"$ \

  如果把A板接地，即：取A板的电势作为零电势点 \
  #let CA = 7e-2
  #let DA = 2e-2
  #let UCA = -E * CA
  #let UDA = -E * DA
  $phi_C = phi_A + U_"CA" = -1400 "V"$ \
  $phi_D = phi_A + U_"DA" = -400 "V"$ \
  $U_"CD" = phi_C - phi_D = -1000 "V"$ \
  在这两种情况下，$U_"CD"$ 相同。 \

  (3)
  #let q = -elementary-charge.val
  #let WCD = q * UCD
  把电子从C点移动到D点，静电力做的功为：$W_"CD" = q U_"CD" = 1.602 times 10^(-16) "J"$ \
  如果使电子从 C 点先移到 P 点，再移到 D 点，静电力做的功不会发生变化，因为静电力做功与路径无关，仅与始末位置有关。
]


== 电容器的电容

#exercise(name: [
  用图示电路给电容器充、放电。开关 S 接通 1，稳定后改接 2，稳定后又改接 1，如此往复。下表记录了充、放电过程中某两个时刻通过电流表的电流方向，试根据该信息，在表格内各空格处填上合理的答案。
])[
  #figure(kind: "diagram", numbering: none)[

    #set text(size: 7pt)
    #zap.circuit(length: 0.5cm, {
      import zap: *
      import cetz.draw: *
      let cin = (0, 0)
      let cout = (0, 4.5)
      let rl = (2, 0)
      let rr = (8, 0)
      let p1 = (3, 4.5)
      let p2 = (3, 3.5)
      let sl = (2.5, 4)
      let sr = (3.5, 4)
      let al = (3.5, 4)
      let ar = (8, 4)
      let vb = (10, 0)
      let vt = (10, 4)

      cell("b", cin, cout, label: $E$)
      wire(cout, p1, label: "1")
      wire(cin, rl)
      swire(rl, p2, axis: "y")
      wire(sl, sr)
      ammeter("am", al, ar, n: "o-*")
      resistor("r", rl, rr, label: (content: $R$, anchor: "north", distance: 3pt), n: "*-*")
      capacitor("c", rr, ar, label: (content: $C$, anchor: "east", distance: 8pt), n: "*-*")
      wire(ar, vt)
      wire(rr, vb)
      voltmeter("vm", vb, vt)
      content(p1, $1$, anchor: "south-east", padding: 3pt)
      content(p2, $2$, anchor: "north-east", padding: 3pt)
      content(sr, $S$, anchor: "south", padding: 4pt)
    })
  ]

  #table(
    columns: (0.5fr, 1fr, 1fr, 1fr, 1fr, 2fr, 1fr),
    rows: (3cm, 3cm, 3cm),
    // fill: (x, y) => {
    //   if y == 0 {
    //     emerald-100
    //   } else if (y == 1) {
    //     emerald-50
    //   } else if (y == 2) {
    //     emerald-100
    //   }
    // },
    [时刻],
    [在此时刻通过图中电流表的电流方向],
    [电流表中的电流正在增大还是减小],
    [开关 S 当前正在接通 1 还是接通 2],
    [电容器两端的电压正在增大还是减小],
    [整个电路中的能量正在怎样转化],
    [这个时候电容器是在充电还是在放电],

    [$t_1$], [向左], [减小], [接通2], [减小], [电容器中的电能在电流经过电阻时被全部转化为热能？], [放电],

    [$t_2$],
    [向右],
    [减小],
    [接通1],
    [增大],
    [电池的电能一部分转化为电容器中的电能，还有一部分在经过电阻时被转化为热能？],
    [充电],
  )
]


#exercise(name: [
  有人用图描述某电容器充电时，其电荷量 Q、电压 U、电容 C 之间的相互关系，请判断它们的正误，并说明理由。
])[
  #set text(size: 8pt)
  #set align(center)
  #grid(
    columns: (auto, auto),
    rows: (auto, auto),
    gutter: 2mm,
    inset:5mm,
    cetz.canvas(length: 1.2cm, {
      import cetz.draw: *
      let (o, x, y, p, b) = ((0, 0), (1.5, 0), (0, 1.5), (1, 1), (0.75, -0.5))
      line(o, p,stroke: cyan-300 + 1pt,)
      group({
        set-style(line: (mark: (end: (symbol: ">>", fill: black, scale: 0.5))))
        line(o, x)
        line(o, y)
      })
      content(o, [O], anchor: "north-east")
      content(x, [Q], anchor: "north", padding: 5pt)
      content(y, [C], anchor: "east", padding: 5pt)
      content(b, [图A])
    }),
    cetz.canvas(length: 1.2cm, {
      import cetz.draw: *
      let (o, x, y, p, b) = ((0, 0), (1.5, 0), (0, 1.5), (1, 1), (0.75, -0.5))
      line(p,(project:p,onto:(o,y)),stroke: cyan-300 + 1pt)
      group({
        set-style(line: (mark: (end: (symbol: ">>", fill: black, scale: 0.5))))
        line(o, x)
        line(o, y)
      })
      content(o, [O], anchor: "north-east")
      content(x, [U], anchor: "north", padding: 5pt)
      content(y, [C], anchor: "east", padding: 5pt)
      content(b, [图B])
    }),
    cetz.canvas(length: 1.2cm, {
      import cetz.draw: *
      let (o, x, y, p, b) = ((0, 0), (1.5, 0), (0, 1.5), (1, 1), (0.75, -0.5))
      line(o, p,stroke: cyan-300 + 1pt)
      group({
        set-style(line: (mark: (end: (symbol: ">>", fill: black, scale: 0.5))))
        line(o, x)
        line(o, y)
      })
      content(o, [O], anchor: "north-east")
      content(x, [U], anchor: "north", padding: 5pt)
      content(y, [Q], anchor: "east", padding: 5pt)
      content(b, [图C])
    }),
    cetz.canvas(length: 1.2cm, {
      import cetz.draw: *
      let (o, x, y, p, b) = ((0, 0), (1.5, 0), (0, 1.5), (1, 1), (0.75, -0.5))
      line(p,(project:p,onto:(o,y)),stroke: cyan-300 + 1pt)
      group({
        set-style(line: (mark: (end: (symbol: ">>", fill: black, scale: 0.5))))
        line(o, x)
        line(o, y)
      })
      content(o, [O], anchor: "north-east")
      content(x, [Q], anchor: "north", padding: 5pt)
      content(y, [C], anchor: "east", padding: 5pt)
      content(b, [图D])
    })
  )
#set align(left)
电容：$ C = Q/U $
假设：电容器的电容 C 是物理器件的固有属性，在充电过程中保持不变。 

电容器充电时：$Q = C * U$，这是一个一元一次函数，电荷量 Q 随电压 U 增加而等比例增加。

图A错误，图B和图D正确，因为电容器的电容 C 是物理器件的固有属性，在充电过程中保持不变。 

图C正确，电容器充电时，电荷量 Q 随电压 U 增加而等比例增加。
]


#exercise(name:[
  有一个已充电的电容器，两极板之间的电压为3 V，所带电荷量为 $4.5×10^(-4)$ C，此电容器的电容是多少？将电容器的电压降为 2 V，电容器的电容是多少？所带电荷量是多少？
])[

]