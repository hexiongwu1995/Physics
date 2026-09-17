#document("index.html", title: [Home])[
  #title()

电荷量：
  $
    q = sqrt((F r^2)/ k) 
  $

  $ (norm(arrow(F)))/"cb" = (norm(arrow(F)_g))/"Oc" $

  - #link(<blog>)[Go to blog]
]

#document("blog.html", title: [Blog])[
  #title()
  Welcome to my blog!

  ...

  This blog also exists as a
  #link(<blog-pdf>)[single PDF].
] <blog>

#document("blog.pdf", title: [Blog])[
  ...
] <blog-pdf>