// ============================================================
// Introduction to the Untyped Lambda Calculus
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE
// ------------------------------------------------------------

#slide[
  #v(1fr)

  #text(size: 2.4em, weight: "bold")[
    Introduction to the Untyped $lambda$-Calculus
  ]

  #v(0.8em)
  #line(length: 100%, stroke: 1.2pt + gold)

  #v(0.8em)

  #grid(
    columns: (0.9fr, 2.1fr),
    align: horizon,

    stack(
      spacing: 1.2em,
      text(size: 1.1em)[2021],
      text(size: 1em)[Technische Universität Berlin],
    ),

    align(center)[
      #text(size: 1.4em, style: "italic", fill: white)[
        #text(fill: gold)[⤷] #underline[not] $lambda$-functions as in Python, ...!
      ]
    ],
  )

  #v(2fr)
]

// ------------------------------------------------------------
// SLIDE 2 — FROM MATHEMATICS TO LAMBDA CALCULUS
// ------------------------------------------------------------

#slide[
  #v(0.5em)

  #grid(
    columns: (1fr, 0.6fr, 1fr),
    align: horizon,

    text(size: 1.5em)[normal mathematics],

    align(center)[
      #text(size: 2.2em)[$arrow.squiggly$]
    ],

    text(size: 1.5em)[lambda calculus],
  )

  #v(1.8em)

  #grid(
    columns: (1fr, 0.6fr, 1fr),
    align: horizon,

    // Ordinary mathematical function
    stack(
      spacing: 1.3em,

      text(size: 2em)[
        $f(x) = x^2 + 1$
      ],

      text(size: 1.8em)[
        $x mapsto x^2 + 1$
      ],
    ),

    align(center)[
      #text(size: 2.2em)[$arrow.squiggly$]
    ],

    // Lambda abstraction
    stack(
      spacing: 0.6em,

      align(center)[
        #stack(
          spacing: 0.3em,
          rect(stroke: 1.5pt + rgb("#D94848"), radius: 1em, inset: (
            x: 0.7em,
            y: 0.35em,
          ))[
            #text(
              size: 1.1em,
              fill: rgb("#D94848"),
              weight: "bold",
            )[abstraction]
          ],
          text(size: 1.2em, fill: rgb("#D94848"))[$arrow.b$],
        )
      ],

      text(size: 2em)[
        $lambda x . x^2 + 1$
      ],
    ),
  )

  #v(2em)

  #grid(
    columns: (1fr, 0.6fr, 1fr),
    align: horizon,

    // Function evaluation
    stack(
      spacing: 0.6em,

      text(size: 1.9em)[
        $f(5) = 5^2 + 1$
      ],

      text(size: 1.9em)[
        $= 25 + 1$
      ],

      text(size: 1.9em)[
        $= 26$
      ],
    ),

    align(center)[
      #text(size: 2.2em)[$arrow.squiggly$]
    ],

    // Lambda application
    stack(
      spacing: 0.6em,

      align(center)[
        #stack(
          spacing: 0.3em,
          rect(stroke: 1.5pt + rgb("#D94848"), radius: 1em, inset: (
            x: 0.7em,
            y: 0.35em,
          ))[
            #text(
              size: 1.1em,
              fill: rgb("#D94848"),
              weight: "bold",
            )[application]
          ],
          text(size: 1.2em, fill: rgb("#D94848"))[$arrow.b$],
        )
      ],

      text(size: 1.9em)[
        $(lambda x . x^2 + 1) 5$
      ],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 3 — FORMAL DEFINITION OF LAMBDA TERMS
// ------------------------------------------------------------

#slide(title: [Formal Definition of $lambda$-Terms])[

  #panel(
    [Definition (The Set $Lambda$ of Untyped $lambda$-Terms)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 1.6em,
      row-gutter: 0.8em,
      align: (left + horizon, left + horizon),

      text(size: 1.1em, weight: "bold")[Variable],
      text(size: 1.1em)[If $x in V$, then $x in Lambda$.],

      text(size: 1.1em, weight: "bold")[Application],
      text(size: 1.1em)[If $M, N in Lambda$, then $(M N) in Lambda$.],

      text(size: 1.1em, weight: "bold")[Abstraction],
      text(
        size: 1.1em,
      )[If $x in V$ and $M in Lambda$, then $(lambda x . M) in Lambda$.],
    ),
  )

  #v(1.1em)

  #text(size: 1.15em)[Examples:]

  #v(0.6em)

  #set list(
    indent: 1.8em,
    spacing: 0.7em,
    marker: [1.],
  )

  #text(size: 1.25em)[
    + $(lambda x . thin x)$

    + $(lambda x . thin (lambda y . thin x))$

    + $(lambda m . thin (lambda f . thin (lambda x . thin (f ((m f) x)))))$
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 4 — NOTATION
// ------------------------------------------------------------

#slide(title: [Notation])[

  // Notation: Terms
  #panel(
    [Notation (Terms)],

    stack(
      spacing: 0.65em,

      text(size: 1.05em)[
        - Lowercase Latin letters $x, y, z, dots$
          denote term variables.

        - Uppercase Latin letters $L, M, N, dots$
          denote $lambda$-terms.

        - Syntactical identity will be denoted with
          $equiv$.
      ],
    ),
  )

  #v(1.1em)

  // Notation: Parentheses
  #panel(
    [Notation (Parentheses)],

    stack(
      spacing: 0.7em,

      text(size: 1.05em)[
        - Outer most parentheses may be omitted:
          $(lambda x . (M)) equiv lambda x . M$.

        - Application is left-associative:
          $(M N) L equiv M N L$.

        - Abstraction is right-associative:
          $lambda x . (lambda y . M) equiv lambda x . lambda y . M$.
          #h(1.2em)
          #text(fill: gold, style: "italic")[$arrow.l$ $f(x, y)$]

        - Application takes precedence over abstraction:
          $lambda x . (M N) equiv lambda x . M N$.
      ],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 5 — NOTATION: EXAMPLES
// ------------------------------------------------------------

#slide(title: [Some Examples])[

  #panel(
    [Notation (Parentheses)],

    stack(
      spacing: 0.65em,

      text(size: 1.05em)[
        - Outer most parentheses may be omitted:
          $(lambda x . (M)) equiv lambda x . M$.

        - Application is left-associative:
          $(M N) L equiv M N L$.

        - Abstraction is right-associative:
          $lambda x . (lambda y . M) equiv lambda x . lambda y . M$.

        - Application takes precedence over abstraction:
          $lambda x . (M N) equiv lambda x . M N$.
      ],
    ),
  )

  #v(1.1em)

  #text(size: 1.15em)[Examples:]

  #v(0.5em)

  #set list(
    indent: 1.8em,
    spacing: 0.8em,
    marker: [1.],
  )

  #text(size: 1.3em)[
    + $lambda x . thin x$

    + $lambda x . thin x thin x$

    + $lambda x . thin lambda y . thin lambda z . thin x (y thin z)$

    + $lambda m . thin lambda n . thin lambda f . thin lambda x . thin
      m thin f (n thin f thin x)$

    + $lambda n . thin n (lambda z . thin (lambda x . thin lambda y . thin y))
      (lambda x . thin lambda y . thin x)$
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 6 — FREE AND BOUND VARIABLES
// ------------------------------------------------------------

#slide(title: [Free and Bound Variables])[

  #panel(
    [Definition (The Set of Free Variables $upright(F V)$ of a $lambda$-Term)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 1.6em,
      row-gutter: 0.8em,
      align: (left + horizon, left + horizon),

      text(size: 1.1em, weight: "bold")[Variable],
      text(size: 1.1em)[$upright(F V)(x) = {x}$],

      text(size: 1.1em, weight: "bold")[Application],
      text(
        size: 1.1em,
      )[$upright(F V)(M N) = upright(F V)(M) union upright(F V)(N)$],

      text(size: 1.1em, weight: "bold")[Abstraction],
      text(
        size: 1.1em,
      )[$upright(F V)(lambda x . M) = upright(F V)(M) without {x}$],
    ),
  )

  #v(0.8em)

  #text(size: 1.15em)[Examples:]

  #v(0.4em)

  #grid(
    columns: (1fr, 0.4fr),
    column-gutter: 0.5em,
    align: horizon,

    align(left)[
      #text(size: 1.35em)[
        $
          upright(F V)(lambda x . x y) & = upright(F V)(x y) without {x} \
                                       & = {x, y} without {x} = {y}
        $
      ]
    ],

    align(center)[
      #stack(
        spacing: 0.6em,
        text(size: 1.1em, fill: gold)[*y* free],
        text(size: 1.1em, fill: gold)[*x* bound],
      )
    ],
  )

  #v(0.8em)

  #grid(
    columns: (1fr, 0.4fr),
    column-gutter: 0.5em,
    align: horizon,

    align(left)[
      #text(size: 1.35em)[
        $
          upright(F V)(x (lambda x . x y)) &= upright(F V)(x) union upright(F V)(lambda x . x y) \
          &= {x} union {y} = {x, y}
        $
      ]
    ],

    align(center)[
      #stack(
        spacing: 0.6em,
        text(size: 1.1em, fill: gold)[*x, y* free],
        text(size: 1.1em, fill: gold)[*x* bound #h(0.2em) $arrow.zigzag$],
      )
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 7 — ALPHA-CONVERSION AND BARENDREGT CONVENTION
// ------------------------------------------------------------

#slide(title: [$alpha$-Conversion and the Barendregt Convention])[

  #grid(
    columns: (1fr, 1fr),
    align: horizon,

    align(center)[
      #text(size: 1.8em)[
        $f(x) = x^2 + 1$
      ]
    ],

    align(center)[
      #text(size: 1.8em)[
        $g(y) = y^2 + 1$
      ]
    ],
  )

  #v(0.8em)

  #panel(
    [Definition ($alpha$-Conversion)],

    grid(
      columns: (1fr, auto),
      gutter: 1em,
      align: horizon,

      text(size: 1.05em)[
        Two $lambda$-terms $M, N in Lambda$ are
        $alpha$-convertible, denoted by $M equiv N$,
        if and only if they differ only by the names
        of their bound variables.
      ],

      text(size: 1.1em, fill: gold)[
        $arrow.squiggly$ identical
      ],
    ),
  )

  #v(0.8em)

  #align(center)[
    #grid(
      columns: (auto, auto),
      gutter: 2.5em,
      align: horizon,

      stack(
        spacing: 0.55em,
        align(left)[
          #text(size: 1.5em)[
            $x (lambda x . x y) equiv x (lambda z . z y)$
          ]
        ],
        align(left)[
          #text(size: 1.5em)[
            $equiv.not z (lambda x . x y)$
          ]
        ],
      ),

      stack(
        spacing: 0.6em,
        align(left)[#text(size: 1.1em, fill: gold)[*x, y* free]],
        align(left)[#text(size: 1.1em, fill: gold)[*z* bound]],
      ),
    )
  ]

  #v(0.8em)

  #panel(
    [Definition (Barendregt Convention)],

    text(size: 1.05em)[
      All bound variables in a $lambda$-term
      $M in Lambda$ should be pairwise different
      and chosen such that they differ from the
      free variables in the term.
    ],
  )

  #v(0.8em)

  #align(center)[
    #stack(
      spacing: 0.7em,

      text(size: 1.4em)[
        #strike(stroke: 1.5pt + gold)[
          $(lambda x . x x)(lambda x . x x)$
        ]
      ],

      text(size: 1.35em)[
        $(lambda x . x (lambda x . x x)) equiv.not (lambda y . y (lambda x . x y))$
      ],
    )
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 8 — SUBSTITUTION
// ------------------------------------------------------------

#slide(title: [Substitution])[

  #panel(
    [Definition (Substitution)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 1.6em,
      row-gutter: 0.8em,
      align: (left + top, left + top),

      text(size: 1.05em, weight: "bold")[Variable],
      stack(
        spacing: 0.5em,
        [$x[x := N] equiv N,$],
        [$y[x := N] equiv y,$ if $x != y$.],
      ),

      text(size: 1.05em, weight: "bold")[Application],
      [$(P Q)[x := N] equiv (P[x := N]) (Q[x := N]),$],

      text(size: 1.05em, weight: "bold")[Abstraction],
      stack(
        spacing: 0.5em,
        [$(lambda y . P)[x := N] equiv lambda y . (P[x := N]),$],
        [if $y in.not upright(F V)(N)$.],
      ),
    ),
  )

  #v(1.4em)

  #align(center)[
    #stack(
      spacing: 0.85em,

      text(size: 1.4em)[
        #strike(stroke: 1.5pt + gold)[
          $(lambda y . y x)[x := lambda z . z y] equiv lambda y . y (lambda z . z y)$
        ]
      ],

      text(size: 1.4em)[
        $(lambda y_1 . y_1 x)[x := lambda z . z y] equiv lambda y_1 . y_1 (lambda z . z y)$
      ],
    )
  ]

  #v(1fr)
]
