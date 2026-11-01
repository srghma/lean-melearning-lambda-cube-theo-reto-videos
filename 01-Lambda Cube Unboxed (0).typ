// ============================================================
// Lambda Cube Unboxed
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE
// ------------------------------------------------------------

#slide[
  #v(1fr)

  #text(size: 2.4em, weight: "bold")[Lambda Cube Unboxed]

  #v(0.6em)
  #line(length: 70%, stroke: 1.5pt + gold)
  #v(1.2em)

  #text(size: 1.25em)[
    Screencasts by Michelle Döring, Felix Moebius,\
    Douglas Rouse, Falk Schimweg
  ]

  #v(0.8em)
  #text(size: 1.15em)[Under supervision of Uwe Nestmann]

  #v(1em)
  #text(size: 1.1em)[2021]

  #v(1em)
  #text(size: 1.05em)[Technische Universität Berlin]

  #v(1.5fr)
]

// ------------------------------------------------------------
// SLIDE 2 — AGENDA
// ------------------------------------------------------------

#slide(title: [Agenda])[
  #let agenda = (
    [Untyped $lambda$-Calculus],
    [$lambda ->$],
    [$lambda 2$],
    [$lambda omega$],
    [$lambda upright(P)$],
    [$lambda upright(C)$],
    [Logic: Curry-Howard Isomorphism],
  )

  #grid(
    columns: (1fr, 1.25fr),
    gutter: 2em,
    align: horizon,

    // Left column: Agenda items
    stack(
      spacing: 1.15em,
      ..agenda
        .enumerate()
        .map(((i, item)) => text(size: 1.15em)[
          #(i + 1).#h(0.8em)#item
        ]),
    ),

    // Right column: Lambda Cube using Fletcher
    align(center)[
      #diagram(
        spacing: (1.8cm, 1.15cm),
        node-stroke: none,
        node-fill: none,
        mark-scale: 75%,

        // Front face nodes
        node((0, 2), text(1.2em)[$lambda ->$], name: <base>),
        node((2, 2), text(1.2em)[$lambda upright(P)$], name: <lp>),
        node((0, 0), text(1.2em)[$lambda 2$], name: <l2>),
        node((2, 0), text(1.2em)[$lambda upright(P) 2$], name: <lp2>),

        // Back face nodes (shifted diagonally up-right)
        node((0.9, 1.3), text(1.2em)[$lambda omega$], name: <lw-low>),
        node((2.9, 1.3), text(1.2em)[$lambda upright(P) omega$], name: <lpw>),
        node((0.9, -0.7), text(1.2em)[$lambda omega$], name: <lw-top>),
        node((2.9, -0.7), text(1.2em)[$lambda upright(C)$], name: <lc>),

        // Highlighted green relationships originating from λ→
        edge(<base>, <l2>, "->", stroke: 1.8pt + green),
        edge(<base>, <lp>, "->", stroke: 1.8pt + green),
        edge(<base>, <lw-low>, "->", stroke: (
          paint: green,
          thickness: 1.8pt,
          dash: "dashed",
        )),

        // Front face remaining edges
        edge(<l2>, <lp2>, "->", stroke: 1pt + grey),
        edge(<lp>, <lp2>, "->", stroke: 1pt + grey),

        // Oblique depth edges
        edge(<l2>, <lw-top>, "->", stroke: 1pt + grey),
        edge(<lp2>, <lc>, "->", stroke: 1pt + grey),
        edge(<lp>, <lpw>, "->", stroke: 1pt + grey),

        // Back face remaining edges
        edge(<lw-low>, <lpw>, "->", stroke: (
          paint: grey,
          thickness: 1pt,
          dash: "dashed",
        )),
        edge(<lw-top>, <lc>, "->", stroke: 1pt + grey),
        edge(<lpw>, <lc>, "->", stroke: 1pt + grey),
      )
    ],
  )
]

// ------------------------------------------------------------
// SLIDE 3 — SOURCES
// ------------------------------------------------------------

#slide(title: [(Re-)Sources])[
  #align(horizon)[
    #set list(spacing: 1.3em, marker: [•])
    #text(size: 1.05em)[
      - Nederpelt, R., Geuvers, H. (2014). _Type Theory and Formal Proof: An Introduction._ Cambridge University Press.
      - Barendregt, H. P. (1992). _Lambda Calculi with Types._
      - Wadler, P. (2015). _Propositions as Types._ Communications of the ACM, 58(12), 75–84.
      - Polymorphic $lambda$-Calculus:
        #set list(spacing: 1em)
        #text(size: 0.92em)[
          - Girard, J. Y., Taylor, P., Lafont, Y. (1989). _Proofs and types_ (Vol. 7). Cambridge: Cambridge university press.
          - Pierce, B., Dietzen, S., Michaylov, S. (1989). _Programming in Higher-Order Typed Lambda-Calculi._
        ]
    ]
  ]
]

// ------------------------------------------------------------
// SLIDE 4 — HOW TO
// ------------------------------------------------------------

#slide(title: [How To ..])[
  #grid(
    columns: (1fr, 1fr),
    rows: (auto, 1fr, auto),
    align: horizon,

    // Top terms
    text(size: 1.7em)[math],
    align(right, text(size: 1.7em)[programming]),

    // Central term
    grid.cell(colspan: 2, align(center + horizon)[
      #text(size: 1.9em)[lambda calculus] \
      #v(0.4em)
      #text(size: 1.9em)[(lambda cube)]
    ]),

    // Bottom terms
    text(size: 1.8em)[type theory],
    align(right, text(size: 1.8em)[logic]),
  )
]
