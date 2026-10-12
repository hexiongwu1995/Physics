

#import "@preview/itemplate:0.1.5": *
#show: contents => itemplate(doc-title: "radial-sine-wave", doc-author: "HeXiongwu", contents)


#import "@preview/cetz:0.5.2"

#show math.equation: set block(breakable: true)

#set text(lang: "zh")
// #set page(paper: "a4", margin: 2cm)
// #set heading(numbering: "1.")


#show heading.where(level: 1): set text(weight: "bold")
#show heading.where(level: 2): set text(fill: rgb("#076b07"))
// #outline()


#html.style(
  ```
p {
  line-height: 1.5;
  margin-bottom: 0.8em;
}

article div {
  line-height: 1.5;
  margin-bottom: 0.8em;
}

article li {
  line-height: 1.5;
}

math {
  font-size: clamp(0.6rem, 3.5vw, 1rem);
  line-height: 1.5;
  margin-bottom: 0.8em;
}

math[display="block"] {
  max-width: 100%;
  overflow-x: auto;
  overflow-y: hidden;
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE 10+ */
}

math[display="block"]::-webkit-scrollbar {
  display: none; /* Chrome, Safari, Edge */
}
  ```.text,
)


= parametricGeometry

== radial-sine-wave

$ y = sin(sqrt(x^2 + z^2)) $


#html.elem(
  "div",
  attrs: (
    style: "background: white; margin: 20px; width: 95%; aspect-ratio: 1.5; display: flex; justify-content: center; align-items: center; position: relative;",
    id: "radial-sine-wave-wrapper",
    class: "three-animation",
  ),
  html.elem("canvas", attrs: (
    id: "radial-sine-wave-canvas",
    style: "width: 100%; height: 100%; display: flex; justify-content: center; align-items: center",
  )),
)
#html.script(
  type: "module",
  src: "../../three/radial-sine-wave.js",
)