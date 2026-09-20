#import "@preview/cetz:0.5.2"

#set page(width:auto, height:auto)

  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(line:(mark:(end:(symbol:"stealth",fill:black))))
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
        set-style(line:(mark:none))
    for p in P_Collection {
      line(p, (rel:(0,0.1), to:p))
      content(p, [#p.at(0)],anchor:"north", padding:0.5em)
    }
    content(P8, [x/cm], anchor:"north", padding: 0.5em)
    set-style(content:(frame:"circle", padding:0.1pt,fill:gradient.radial(rgb("#eeeeee"),rgb("#449999")), stroke:none))
    content(P0, [+])
    content(P6, [-])
  })