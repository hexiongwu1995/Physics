#document("index.html", title: [Home])[
  #title()
  - #link(<blog>)[Go to blog]
]

#document("blog.html", title: [Blog])[
  #title()
  + Welcome to my blog!
  + This blog also exists as a #link(<blog-pdf>)[single PDF].
   - some texts
   some texts
] <blog>

#document("blog.pdf", title: [Blog])[
  ...
] <blog-pdf>