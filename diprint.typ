#import "@preview/diprint:0.1.1": diprint, diprint-appendices

#show: diprint.with(
  title: "The Paper Of All Time",
  authors: (
    (name: "Jane Doe", email: "jane@uni.edu",
     affiliation: "University", orcid: "0000-0000-0000-0000"),
    (name: "wylited", email: "john@uni.org",
     affiliation: "God"),
  ),
  abstract: [A short abstract.],
  keywords: ("internet", "typesetting"),
  date: "January 2025",
)

= Introduction
...

#show: diprint-appendices
= Supplementary Material
...
#lorem(20)
