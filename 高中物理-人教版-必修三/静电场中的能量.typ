
#import "@preview/itemplate:0.1.5": *
#show: contents => itemplate(doc-title: "静电场中的能量", doc-author: "HeXiongwu", contents)

#import "lib.typ": *
#show: theoframe-setup.with(theme: (style: "box", color: rgb("#067300")))
#show heading.where(level: 2): h2 => reset-fig-counter-per-heading(h2)

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

// #show math.equation.where(block: true): pad.with(bottom:0.1em)
#show math.equation.where(block: true): set align(left)

#show heading.where(level: 1): set text(weight: "bold")
#show heading.where(level: 2): set text(fill: rgb("#076b07"))
// #outline()



#html.style(
  ```
  math{
    font-size: clamp(0.6rem, 3.0vw, 1rem);
    font-weight: 550;
  }
  math[display="block"] {
  max-width: 100%;
    font-size: clamp(0.6rem, 3.0vw, 1rem);
    font-weight: 550;
  }
  ```.text,
)


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
//   src: "../../three/equipotential-surface.js",
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
  #figure(caption: [等量同种电荷所产生的电势分布], kind: "diagram", numbering: "1.", supplement: [图])[
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
]

== 电势差

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


// #pagebreak()
