#set page(paper: "a4", margin: 2cm)

#import "@local/itemplate:1.0.0": *
#show: itemplate.with(
  doc-title: "必修三习题汇总",
  doc-author:"hexiongwu",lang:"zh",
  // default-theme: (accent: rgb("#0482ff"), bg: rgb("#e5e5e5"),sidebar-bg:rgb("#c5c5c5"),header-bg:rgb("#e5e5e5"))
  )

#set text(lang:"zh")
// #set page(width:10cm, height:20cm, margin: (x:0.5cm,y:1cm))

#include "静电场及其应用.typ"

#include "静电场中的能量.typ"

...