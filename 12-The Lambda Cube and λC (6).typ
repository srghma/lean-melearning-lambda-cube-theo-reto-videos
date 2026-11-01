// ============================================================
// The Lambda Cube and λC (6)
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE (1/10)
// ------------------------------------------------------------

#title-slide(
  [The Lambda Cube and $lambda C$],
  year: 2021,
  institution: "Technische Universität Berlin",
)

// ------------------------------------------------------------
// SLIDE 2 — THE LAMBDA CUBE (2/10)
// ------------------------------------------------------------

#slide(title: [The $lambda$-Cube])[
  #v(0.5fr)

  #align(center + horizon)[
    #diagram(
      spacing: (2.8cm, 1.7cm),
      node-stroke: none,
      node-fill: none,
      mark-scale: 75%,

      // Front face nodes
      node((0, 2), text(1.3em)[$lambda_arrow$], name: <base>),
      node((2, 2), text(1.3em)[$lambda upright(P)$], name: <lp>),
      node((0, 0), text(1.3em)[$lambda 2$], name: <l2>),
      node((2, 0), text(1.3em)[$lambda upright(P) 2$], name: <lp2>),

      // Back face nodes (shifted diagonally up-right)
      node((0.9, 1.2), text(1.3em)[$lambda underline(omega)$], name: <lw-low>),
      node(
        (2.9, 1.2),
        text(1.3em)[$lambda upright(P) underline(omega)$],
        name: <lpw>,
      ),
      node((0.9, -0.8), text(1.3em)[$lambda omega$], name: <lw-top>),
      node((2.9, -0.8), text(1.3em)[$lambda upright(C)$], name: <lc>),

      // Highlighted green relationships originating from λ→
      edge(<base>, <l2>, "->", stroke: 1.8pt + green),
      edge(<base>, <lp>, "->", stroke: 1.8pt + green),
      edge(<base>, <lw-low>, "->", stroke: (
        paint: green,
        thickness: 1.8pt,
        dash: "dotted",
      )),

      // Front face remaining edges
      edge(<l2>, <lp2>, "->", stroke: 1pt + grey),
      edge(<lp>, <lp2>, "->", stroke: 1pt + grey),

      // Oblique depth edges
      edge(<l2>, <lw-top>, "->", stroke: 1pt + grey),
      edge(<lp2>, <lc>, "->", stroke: 1pt + grey),
      edge(<lp>, <lpw>, "->", stroke: 1pt + grey),

      // Back face remaining edges
      edge(<lw-low>, <lw-top>, "->", stroke: (
        paint: grey,
        thickness: 1pt,
        dash: "dotted",
      )),
      edge(<lw-low>, <lpw>, "->", stroke: (
        paint: grey,
        thickness: 1pt,
        dash: "dotted",
      )),
      edge(<lw-top>, <lc>, "->", stroke: 1pt + grey),
      edge(<lpw>, <lc>, "->", stroke: 1pt + grey),
    )
  ]

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 3 — THE DEPENDENCIES OF THE LAMBDA-SYSTEMS (3/10)
// ------------------------------------------------------------

#slide(title: [The Dependencies of the $lambda$-Systems])[
  #v(1fr)

  #align(center)[
    #rect(stroke: 1pt + white, inset: 0pt)[
      #table(
        columns: (8em, 20em),
        stroke: none,
        align: (center + horizon, left + horizon),
        inset: (x: 1.2em, y: 0.65em),

        // Header Row
        table.cell(stroke: (bottom: 1.2pt + white))[
          #text(size: 1.15em, weight: "bold")[System]
        ],
        table.cell(align: center, stroke: (bottom: 1.2pt + white))[
          #text(size: 1.15em, weight: "bold")[Pairs of Sorts]
        ],

        // Basic Systems
        [$lambda_arrow$], [$(*, *)$],
        [$lambda 2$], [$(*, *) quad (square, *)$],
        [$lambda underline(omega)$], [$(*, *) quad #h(4.2em) (square, square)$],
        table.cell(stroke: (bottom: 1.2pt + white))[
          [$lambda upright(P)$]
        ],
        table.cell(stroke: (bottom: 1.2pt + white))[
          [$(*, *) quad #h(8.5em) (*, square)$]
        ],

        // Combined Systems
        [$lambda omega$], [$(*, *) quad (square, *) quad (square, square)$],
        [$lambda upright(P) 2$],
        [$(*, *) quad (square, *) quad #h(4.2em) (*, square)$],
        [$lambda upright(P) underline(omega)$],
        [$(*, *) quad #h(4.2em) (square, square) quad (*, square)$],
        [$lambda upright(P) 2 underline(omega) = lambda C$],
        [$(*, *) quad (square, *) quad (square, square) quad (*, square)$],
      )
    ]
  ]

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 4 — THE FORMATION RULE - DEFINITION OF LAMBDA C (4/10)
// ------------------------------------------------------------

#slide(title: [The Formation Rule - Definition of $lambda C$])[
  #v(0.6fr)

  // Top general formation rule
  #align(center)[
    #grid(
      columns: (auto, auto),
      column-gutter: 1.5em,
      align: horizon,

      text(size: 1.3em)[$(upright(f o r m))$],

      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.3em,
        )[$Gamma tack A : s_1 quad quad Gamma, x : A tack B : s_2$]),
        line(length: 22em, stroke: 1.2pt + white),
        align(center, text(size: 1.3em)[$Gamma tack Pi x : A . thin B : s_2$]),
      ),
    )
  ]

  #v(1.8em)

  // Classification Table
  #align(center)[
    #rect(stroke: 1pt + white, inset: 0pt)[
      #table(
        columns: (6.5em, 6.5em, 5.5em, 16em, 5em),
        stroke: (x, y) => (
          bottom: if y == 0 { 1.2pt + white } else { none },
          right: if x in (1, 2, 3) { 1pt + white } else { none },
        ),
        align: (
          center + horizon,
          center + horizon,
          center + horizon,
          left + horizon,
          center + horizon,
        ),
        inset: (x: 0.9em, y: 0.6em),

        // Header
        [$x : A : s_1$],
        [$b : B : s_2$],
        [$(s_1, s_2)$],
        align(center)[$lambda x : A . thin b$],
        [from],

        // Rows
        [$*$], [$*$], [$(*, *)$], [term-depending-on-term], [$lambda_arrow$],
        [$square$],
        [$*$],
        [$(square, *)$],
        [term-depending-on-type],
        [$lambda 2$],

        [$square$],
        [$square$],
        [$(square, square)$],
        [type-depending-on-type],
        [$lambda underline(omega)$],

        [$*$],
        [$square$],
        [$(*, square)$],
        [type-depending-on-term],
        [$lambda upright(P)$],
      )
    ]
  ]

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 5 (a) — FORMATION RULES: CONCRETE (5/10)
// ------------------------------------------------------------

#slide(
  title: [The Formation Rule - Definition of $lambda C$ (For the Systems)],
)[
  #v(0.6fr)

  #align(center)[
    #stack(
      spacing: 1.8em,

      // λ→
      grid(
        columns: (6.5em, auto),
        column-gutter: 1.2em,
        align: horizon,
        text(size: 1.25em)[$lambda_arrow : (*, *)$],
        stack(
          spacing: 0.4em,
          align(center, text(
            size: 1.25em,
          )[$Gamma tack A : * quad quad Gamma, x : A tack B : *$]),
          line(length: 21em, stroke: 1.2pt + white),
          align(center, text(size: 1.25em)[$Gamma tack A -> B : *$]),
        ),
      ),

      // λ2
      grid(
        columns: (6.5em, auto),
        column-gutter: 1.2em,
        align: horizon,
        text(size: 1.25em)[$lambda 2 : (square, *)$],
        stack(
          spacing: 0.4em,
          align(center, text(
            size: 1.25em,
          )[$Gamma tack * : square quad quad Gamma, alpha : * tack sigma : *$]),
          line(length: 21em, stroke: 1.2pt + white),
          align(center, text(
            size: 1.25em,
          )[$Gamma tack Pi alpha : * . thin sigma : *$]),
        ),
      ),

      // λω_
      grid(
        columns: (6.5em, auto),
        column-gutter: 1.2em,
        align: horizon,
        text(size: 1.25em)[$lambda underline(omega) : (square, square)$],
        stack(
          spacing: 0.4em,
          align(center, text(
            size: 1.25em,
          )[$Gamma tack * : square quad quad Gamma, x : * tack * -> * : square$]),
          line(length: 24em, stroke: 1.2pt + white),
          align(center, text(
            size: 1.25em,
          )[$Gamma tack * -> (* -> *) : square$]),
        ),
      ),

      // λP
      grid(
        columns: (6.5em, auto),
        column-gutter: 1.2em,
        align: horizon,
        text(size: 1.25em)[$lambda upright(P) : (*, square)$],
        stack(
          spacing: 0.4em,
          align(center, text(
            size: 1.25em,
          )[$Gamma tack A : * quad quad Gamma, x : A tack B : square$]),
          line(length: 21em, stroke: 1.2pt + white),
          align(center, text(
            size: 1.25em,
          )[$Gamma tack Pi x : A . thin B : square$]),
        ),
      ),
    )
  ]

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 5 (b) — FORMATION RULES: UNIFIED PI (5/10)
// ------------------------------------------------------------

#slide(
  title: [The Formation Rule - Definition of $lambda C$ (For the Systems)],
)[
  #v(0.6fr)

  #align(center)[
    #stack(
      spacing: 1.8em,

      // λ→
      grid(
        columns: (6.5em, auto),
        column-gutter: 1.2em,
        align: horizon,
        text(size: 1.25em)[$lambda_arrow : (*, *)$],
        stack(
          spacing: 0.4em,
          align(center, text(
            size: 1.25em,
          )[$Gamma tack A : * quad quad Gamma, x : A tack B : *$]),
          line(length: 21em, stroke: 1.2pt + white),
          align(center, text(size: 1.25em)[$Gamma tack Pi x : A . thin B : *$]),
        ),
      ),

      // λ2
      grid(
        columns: (6.5em, auto),
        column-gutter: 1.2em,
        align: horizon,
        text(size: 1.25em)[$lambda 2 : (square, *)$],
        stack(
          spacing: 0.4em,
          align(center, text(
            size: 1.25em,
          )[$Gamma tack A : square quad quad Gamma, x : A tack B : *$]),
          line(length: 21em, stroke: 1.2pt + white),
          align(center, text(size: 1.25em)[$Gamma tack Pi x : A . thin B : *$]),
        ),
      ),

      // λω_
      grid(
        columns: (6.5em, auto),
        column-gutter: 1.2em,
        align: horizon,
        text(size: 1.25em)[$lambda underline(omega) : (square, square)$],
        stack(
          spacing: 0.4em,
          align(center, text(
            size: 1.25em,
          )[$Gamma tack A : square quad quad Gamma, x : A tack B : square$]),
          line(length: 21em, stroke: 1.2pt + white),
          align(center, text(
            size: 1.25em,
          )[$Gamma tack Pi x : A . thin B : square$]),
        ),
      ),

      // λP
      grid(
        columns: (6.5em, auto),
        column-gutter: 1.2em,
        align: horizon,
        text(size: 1.25em)[$lambda upright(P) : (*, square)$],
        stack(
          spacing: 0.4em,
          align(center, text(
            size: 1.25em,
          )[$Gamma tack A : * quad quad Gamma, x : A tack B : square$]),
          line(length: 21em, stroke: 1.2pt + white),
          align(center, text(
            size: 1.25em,
          )[$Gamma tack Pi x : A . thin B : square$]),
        ),
      ),
    )
  ]

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 6 — DERIVATION RULES (6/10)
// ------------------------------------------------------------

#slide(title: [Derivation Rules])[
  #v(0.2fr)

  #grid(
    columns: (1fr, 3.8fr),
    gutter: 2em,
    align: horizon,

    align(center)[
      #text(size: 3.4em)[$lambda C$]
    ],

    rect(
      stroke: 1pt + white,
      inset: (x: 1.4em, y: 1.1em),
      width: 100%,

      stack(
        spacing: 1.1em,

        // (sort)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(sort)],
          text(size: 1.15em)[$emptyset tack * : square$],
        ),

        // (var)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(var)],
          text(size: 1.15em)[
            $(Gamma tack A : s) / (Gamma, x : A tack x : A) quad upright("if") thin x in.not Gamma$
          ],
        ),

        // (weak)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(weak)],
          text(size: 1.15em)[
            $(Gamma tack A : B quad Gamma tack C : s) / (Gamma, x : C tack A : B) quad upright("if") thin x in.not Gamma$
          ],
        ),

        // (form)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(form)],
          text(size: 1.15em)[
            $(Gamma tack A : s_1 quad Gamma, x : A tack B : s_2) / (Gamma tack Pi x : A . thin B : s_2)$
          ],
        ),

        // (appl)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(appl)],
          text(size: 1.15em)[
            $frac(Gamma tack M : Pi x : A . thin B quad Gamma tack N : A, Gamma tack M N : B [x := N])$
          ],
        ),

        // (abst)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(abst)],
          text(size: 1.15em)[
            $(Gamma, x : A tack M : B quad Gamma tack Pi x : A . thin B : s) / (Gamma tack lambda x : A . thin M : Pi x : A . thin B)$
          ],
        ),

        // (conv)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(conv)],
          text(size: 1.15em)[
            $frac(Gamma tack A : B quad Gamma tack B' : s, Gamma tack A : B') quad upright("if") thin B =_beta B'$
          ],
        ),
      ),
    ),
  )

  #v(0.6fr)
]

// ------------------------------------------------------------
// SLIDE 7 — PROPERTIES FOR LAMBDA C (1) (7/10)
// ------------------------------------------------------------

#slide(title: [Properties for $lambda C$ (1)])[
  #v(0.2fr)

  #panel(
    [Free Variables Lemma],

    text(size: 1.05em)[
      If $Gamma tack A : B$, then $upright(F V)(A), upright(F V)(B) subset.eq upright(d o m)(Gamma)$.
    ],
  )

  #v(0.6em)

  #panel(
    [Thinning Lemma],

    text(size: 1.05em)[
      Let $Gamma$ and $Gamma'$ be contexts such that $Gamma subset.eq Gamma'$. \
      If $Gamma tack A : B$ and there are $A', B'$ such that $Gamma tack A' : B'$, then also $Gamma' tack A : B$.
    ],
  )

  #v(0.6em)

  #panel(
    [Subterm Lemma],

    text(size: 1.05em)[
      If for an expression $M$ there exist $Gamma$ and $N$ such that $Gamma tack M : N$ or $Gamma tack N : M$ \
      (so $M$ is either typable or inhabited), then the same holds for every subexpression of $M$.
    ],
  )

  #v(0.6em)

  #panel(
    [Uniqueness of Types Lemma],

    text(size: 1.05em)[
      If $Gamma tack A : B_1$ and $Gamma tack A : B_2$, then $B_1 =_beta B_2$.
    ],
  )

  #v(0.6fr)
]

// ------------------------------------------------------------
// SLIDE 8 — PROPERTIES FOR LAMBDA C (2) (8/10)
// ------------------------------------------------------------

#slide(title: [Properties for $lambda C$ (2)])[
  #v(0.4fr)

  #panel(
    [Subject Reduction Lemma],

    text(size: 1.05em)[
      If $Gamma tack A : B$ and $A -->_beta^* A'$, then $Gamma tack A' : B$.
    ],
  )

  #v(1em)

  #panel(
    [Church-Rosser Theorem],

    text(size: 1.05em)[
      If $M -->_beta^* N_1$ and $M -->_beta^* N_2$, then there is $N_3$ such that $N_1 -->_beta^* N_3$ and $N_2 -->_beta^* N_3$.
    ],
  )

  #v(1em)

  #panel(
    [Strong Normalization Theorem],

    text(size: 1.05em)[
      Every $M$ that is typable or inhabited is strongly normalising.
    ],
  )

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 9 — PROPERTIES FOR LAMBDA C (3) (9/10)
// ------------------------------------------------------------

#slide(title: [Properties for $lambda C$ (3)])[
  #v(1fr)

  #panel(
    [Theorem (Decidability of Well-typedness and Type Checking)],

    text(size: 1.1em)[
      In $lambda C$ and its subsystems, the questions of Well-typedness and Type Checking are decidable.
    ],
  )

  #v(2.5em)

  #align(center)[
    #text(size: 1.35em, fill: rgb("#D94848"), weight: "bold")[
      inhabitation only decidable in $lambda_arrow, thin lambda underline(omega)$ !
    ]
  ]

  #v(1.5fr)
]

// ------------------------------------------------------------
// SLIDE 10 — THE LAMBDA-CUBE AND SYSTEMS SUMMARY (10/10)
// ------------------------------------------------------------

#slide(title: [The $lambda$-Cube])[
  #v(0.2fr)

  #grid(
    columns: (1.2fr, 1.1fr),
    gutter: 1.5em,
    align: horizon,

    // Left: Lambda Cube using Fletcher
    align(center)[
      #diagram(
        spacing: (1.6cm, 1.15cm),
        node-stroke: none,
        node-fill: none,
        mark-scale: 75%,

        // Front face nodes
        node((0, 2), text(1.1em)[$lambda_arrow$], name: <base>),
        node((2, 2), text(1.1em)[$lambda upright(P)$], name: <lp>),
        node((0, 0), text(1.1em)[$lambda 2$], name: <l2>),
        node((2, 0), text(1.1em)[$lambda upright(P) 2$], name: <lp2>),

        // Back face nodes
        node(
          (0.8, 1.2),
          text(1.1em)[$lambda underline(omega)$],
          name: <lw-low>,
        ),
        node(
          (2.8, 1.2),
          text(1.1em)[$lambda upright(P) underline(omega)$],
          name: <lpw>,
        ),
        node((0.8, -0.8), text(1.1em)[$lambda omega$], name: <lw-top>),
        node((2.8, -0.8), text(1.1em)[$lambda upright(C)$], name: <lc>),

        // Highlighted green relationships originating from λ→
        edge(<base>, <l2>, "->", stroke: 1.8pt + green),
        edge(<base>, <lp>, "->", stroke: 1.8pt + green),
        edge(<base>, <lw-low>, "->", stroke: (
          paint: green,
          thickness: 1.8pt,
          dash: "dotted",
        )),

        // Front face remaining edges
        edge(<l2>, <lp2>, "->", stroke: 1pt + grey),
        edge(<lp>, <lp2>, "->", stroke: 1pt + grey),

        // Oblique depth edges
        edge(<l2>, <lw-top>, "->", stroke: 1pt + grey),
        edge(<lp2>, <lc>, "->", stroke: 1pt + grey),
        edge(<lp>, <lpw>, "->", stroke: 1pt + grey),

        // Back face remaining edges
        edge(<lw-low>, <lw-top>, "->", stroke: (
          paint: grey,
          thickness: 1pt,
          dash: "dotted",
        )),
        edge(<lw-low>, <lpw>, "->", stroke: (
          paint: grey,
          thickness: 1pt,
          dash: "dotted",
        )),
        edge(<lw-top>, <lc>, "->", stroke: 1pt + grey),
        edge(<lpw>, <lc>, "->", stroke: 1pt + grey),
      )
    ],

    // Right: Table of Systems and Pairs of Sorts
    align(center)[
      #rect(stroke: 1pt + white, inset: 0pt)[
        #table(
          columns: (6.5em, 16.5em),
          stroke: none,
          align: (center + horizon, left + horizon),
          inset: (x: 0.8em, y: 0.45em),

          // Header
          table.cell(stroke: (bottom: 1.2pt + white))[
            #text(size: 1em, weight: "bold")[System]
          ],
          table.cell(align: center, stroke: (bottom: 1.2pt + white))[
            #text(size: 1em, weight: "bold")[Pairs of Sorts]
          ],

          // Rows
          [$lambda_arrow$], [$(*, *)$],
          [$lambda 2$], [$(*, *) quad (square, *)$],
          [$lambda underline(omega)$],
          [$(*, *) quad #h(3.2em) (square, square)$],
          table.cell(stroke: (bottom: 1.2pt + white))[
            [$lambda upright(P)$]
          ],
          table.cell(stroke: (bottom: 1.2pt + white))[
            [$(*, *) quad #h(6.8em) (*, square)$]
          ],

          [$lambda omega$], [$(*, *) quad (square, *) quad (square, square)$],
          [$lambda upright(P) 2$],
          [$(*, *) quad (square, *) quad #h(3.2em) (*, square)$],
          [$lambda upright(P) underline(omega)$],
          [$(*, *) quad #h(3.2em) (square, square) quad (*, square)$],
          [$lambda upright(P) 2 underline(omega) = lambda C$],
          [$(*, *) quad (square, *) quad (square, square) quad (*, square)$],
        )
      ]
    ],
  )

  #v(0.6fr)
]
