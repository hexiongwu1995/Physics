#import "@preview/itemplate:0.1.5":*
#show: contents => itemplate(doc-title: "斐波那契数列", doc-author: "HeXiongwu", contents)
#import "@preview/cetz:0.5.2"


// #set page(width: 10cm, height: auto)
// #set heading(numbering: "1.")


= 在球面上生成间距均匀的N个点

斐波那契螺旋法（Fibonacci Lattice） \ 
原理：基于黄金分割率，在球面上按螺旋线排列点。计算极快、分布极为均匀，是实用性最高的标准解法。

#html.elem(
  "div",
  attrs: (
    style: "background: white; margin: 20px; width: 95%; aspect-ratio: 1.5; display: flex; justify-content: center; align-items: center; position: relative;",
    id: "fibonacci-sampling-wrapper",
    class: "three-animation",
  ),
  html.elem("canvas", attrs: (
    id: "fibonacci-sampling-canvas",
    style: "width: 100%; height: 100%; display: flex; justify-content: center; align-items: center",
  )),
)
#html.elem("p", attrs: (id: "fibonacci-sampling-text", style: "white-space: pre-wrap"))
#html.script(
  type: "module",
  src: "../fibonacci-sampling.js",
)





= Fibonacci sequence
The Fibonacci sequence is defined through the recurrence relation $F_n = F_(n-1) + F_(n-2)$.
It can also be expressed in _closed form :_

$
  F_n = round(1/ sqrt(5) phi.alt^n), quad
  phi.alt = (1 + sqrt(5)) / 2 = #calc.round((1 + calc.sqrt(5)) / 2, digits: 3)
$

#let count = 18
#let nums = range(1, count + 1)
#let fib(n) = (
  if n <= 2 { 1 } else { fib(n - 1) + fib(n - 2) }
)

The first #count numbers of the sequence are:

#set align(center)

== iteration form

#table(
  columns: count,
  ..nums.map(n => $F_#n$),
  ..nums.map(n => str(fib(n))),
)

== closed form
#let fib-closed-form(n) = calc.round(1 / calc.sqrt(5) * calc.pow((1 + calc.sqrt(5)) / 2, n), digits: 0)

#table(
  columns: count,
  ..nums.map(n => $F_#n$),
  ..nums.map(n => $#fib-closed-form(n)$)
)





// #figure(
//   numbering: "1",
//   caption: [Fibonacci sequence plot],
//   supplement: [Diagram],
// //   cetz.canvas(length: 0.2cm, {
// //     import cetz.draw: *
// //     let axisLength = 20
// //     set-style(line: (mark: (end: (symbol: "stealth", fill: black))))
// //     line((-axisLength, 0), (axisLength, 0))
// //     line((0, -axisLength), (0, axisLength))
// //     // rect1
// //     let radius1 = 1
// //     let rect1Position = ((0-radius1, 0-radius1), (0, 0))
// //     rect(..rect1Position, name: "rect1")
// //     arc(("rect1.south-east"), start: 270deg, delta: -90deg, radius: radius1)
// //     // 假设生长方向为顺时针
// //     // rect2
// //     let radius2 = radius1
// //     let rect2Position = ((rect1Position.at(0).at(0), rect1Position.at(0).at(1) + radius2), (rect1Position.at(1).at(0), rect1Position.at(1).at(1) + radius2))
// //     rect(..rect2Position, name: "rect2")
// //     arc(("rect2.south-west"), start: 180deg, stop: 90deg, radius: radius2)
// //     let radius3 = radius2 + radius1
// //     // let rect3 = group()
// // }),

// )


// #figure(
//   numbering: "1",
//   caption: [Fibonacci sequence plot],
//   supplement: [Diagram],
//   cetz.canvas(length: 0.2cm, {
//     import cetz.draw: *
//     let axisLength = 20
//     set-style(line: (mark: (end: (symbol: "stealth", fill: black))))
//     line((-axisLength, 0), (axisLength, 0))
//     line((0, -axisLength), (0, axisLength))
//     // rect1
//     let startRadius = 1
//     let startRectPosition = ((0-startRadius, 0-startRadius), (0, 0))
//     rect(..startRectPosition, name: "rect1")
//     // 假设生长方向为顺时针
//     // rect2
//     // let currentRadius = startRadius
//     // let currentRectPosition =  ((startRectPosition.at(0).at(0), startRectPosition.at(0).at(1) + currentRadius), (startRectPosition.at(1).at(0), startRectPosition.at(1).at(1) + currentRadius))
//     let drawRect(count) = {
//       for i in range(1, count){
//       startRadius = currentRadius
//         currentRadius = startRadius + currentRadius

//   }}),
// )


    //    let currentRectPosition = if (calc.rem(i, 4) == 1){
    //     ((startRectPosition.at(0).at(0), startRectPosition.at(0).at(1) + currentRadius), (startRectPosition.at(1).at(0), startRectPosition.at(1).at(1) + currentRadius))
    //   } else if (calc.rem(i, 4) == 2){
    //     ((startRectPosition.at(0).at(0) + currentRadius, startRectPosition.at(0).at(1)), (startRectPosition.at(1).at(0) + currentRadius, startRectPosition.at(1).at(1)))
    //   } else if (calc.rem(i, 4) == 3){
    //     ((startRectPosition.at(0).at(0), startRectPosition.at(0).at(1) - currentRadius), (startRectPosition.at(1).at(0), startRectPosition.at(1).at(1) - currentRadius))
    //   } else if (calc.rem(i, 4) == 0){
    //     ((startRectPosition.at(0).at(0) - currentRadius, startRectPosition.at(0).at(1)), (startRectPosition.at(1).at(0) - currentRadius, startRectPosition.at(1).at(1)))
    // }