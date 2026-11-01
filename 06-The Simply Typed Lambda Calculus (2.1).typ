// ============================================================
// The Simply Typed Lambda Calculus (2.1)
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE (1/11)
// ------------------------------------------------------------

#slide[
  #v(1fr)

  #text(size: 2.3em, weight: "bold")[
    The Simply Typed Lambda Calculus $lambda_arrow$
  ]

  #v(0.8em)
  #line(length: 100%, stroke: 1.2pt + gold)

  #v(0.8em)

  #grid(
    columns: (1fr, 1fr),
    align: horizon,

    stack(
      spacing: 1.2em,
      text(size: 1.1em)[2021],
      text(size: 1em)[Technische Universität Berlin],
    ),

    none,
  )

  #v(2fr)
]

// ------------------------------------------------------------
// SLIDE 2 — WHY DO WE NEED TYPES? (2/11)
// ------------------------------------------------------------

#slide(title: [Why Do We Need Types?])[
  #v(1fr)

  #align(center)[
    #text(size: 1.8em)[
      Untyped functions are too general.
    ]
  ]

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 3 (a) — WHAT ARE TYPES? (MOTIVATION) (3/11)
// ------------------------------------------------------------

#slide(title: [What Are Types?])[
  #v(1fr)

  #align(center)[
    #stack(
      spacing: 1.8em,

      text(size: 2.2em)[
        $f(x) = x^2 + 1$
      ],

      text(size: 2.4em)[
        #rotate(90deg)[$arrow.squiggly$]
      ],

      text(size: 1.9em)[
        $upright(a d d) thin (upright(m u l t) thin x thin x) thin 1 : bb(N) -> bb(N)$
      ],
    )
  ]

  #v(1.4fr)
]

// ------------------------------------------------------------
// SLIDE 3 (b) — WHAT ARE TYPES? (DEFINITION) (3/11)
// ------------------------------------------------------------

#slide(title: [What Are Types?])[

  #panel(
    [Definition (The Set $bb(T)$ of Simple Types)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 1.8em,
      row-gutter: 0.8em,
      align: (left + horizon, left + horizon),

      text(size: 1.1em, weight: "bold")[Variable Type],
      text(size: 1.1em)[If $alpha in V$, then $alpha in bb(T)$.],

      text(size: 1.1em, weight: "bold")[Arrow Type],
      text(
        size: 1.1em,
      )[If $sigma, tau in bb(T)$, then $(sigma -> tau) in bb(T)$.],
    ),
  )

  #v(1.1em)

  #panel(
    [Notation],

    stack(
      spacing: 0.65em,

      text(size: 1.05em)[
        - $alpha, beta, gamma, dots$ denote type variables.

        - $sigma, tau, rho, dots$ denote arbitrary types.

        - Syntactical identity will be denoted with $equiv$.

        - Outermost parentheses may be omitted.

        - Arrow types are right-associative: $sigma -> (tau -> rho) equiv sigma -> tau -> rho$.
      ],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 4 — DEFINITION OF PRE-TYPED LAMBDA TERMS (4/11)
// ------------------------------------------------------------

#slide(title: [Definition of Pre-Typed $lambda_arrow$-Terms])[

  #panel(
    [Definition (The Set $Lambda_bb(T)^arrow$ of Pre-Typed $lambda_arrow$-Terms)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 1.8em,
      row-gutter: 0.8em,
      align: (left + horizon, left + horizon),

      text(size: 1.1em, weight: "bold")[Variable],
      text(size: 1.1em)[If $x in V$, then $x in Lambda_bb(T)^arrow$.],

      text(size: 1.1em, weight: "bold")[Application],
      text(
        size: 1.1em,
      )[If $M, N in Lambda_bb(T)^arrow$, then $(M thin N) in Lambda_bb(T)^arrow$.],

      text(size: 1.1em, weight: "bold")[Abstraction],
      text(
        size: 1.1em,
      )[If $x in V$, $sigma in bb(T)$ and $M in Lambda_bb(T)^arrow$, then $(lambda x : sigma . thin M) in Lambda_bb(T)^arrow$.],
    ),
  )

  #v(0.9em)

  #text(size: 1.15em)[Examples:]

  #v(0.5em)

  #set list(indent: 1.6em, spacing: 0.65em)

  #text(size: 1.2em)[
    + $(lambda x : alpha . thin x) : alpha -> alpha$

    + $(lambda x : alpha . thin x) thin y : alpha$

    + $lambda x : alpha . thin y thin x : alpha -> sigma$ \
      #v(0.2em)
      #h(1.8em) $y thin x : sigma$ \
      #v(0.1em)
      #h(2.8em) $arrow.hook quad y : alpha -> sigma$
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 5 — DERIVATION - NOTATION (5/11)
// ------------------------------------------------------------

#slide(title: [Derivation - Notation])[
  #v(1fr)

  #grid(
    columns: (1fr, 1.45fr),
    gutter: 2em,
    align: horizon,

    // Left column: axioms -> proposition ?
    align(center)[
      #stack(
        spacing: 1.2em,

        text(size: 1.6em)[axioms],

        text(size: 1.8em)[$arrow.b.dashed$],

        text(size: 1.6em)[
          proposition #text(fill: rgb("#D94848"), weight: "bold")[?]
        ],
      )
    ],

    // Right column: inference rule schema and Modus Ponens
    stack(
      spacing: 2.4em,

      grid(
        columns: (auto, auto, auto),
        column-gutter: 1.2em,
        align: horizon,

        text(size: 1.35em)[rule:],

        stack(
          spacing: 0.45em,
          align(center, text(size: 1.3em)[$p_1 quad dots.c quad p_n$]),
          line(length: 11em, stroke: 1.2pt + white),
          align(center, text(size: 1.3em)[$upright(c o n c l u s i o n)$]),
        ),

        text(size: 2em, fill: gold)[$arrow.b$],
      ),

      grid(
        columns: (auto, auto),
        column-gutter: 1.2em,
        align: horizon,

        text(size: 1.35em)[Modus Ponens:],

        stack(
          spacing: 0.45em,
          align(center, text(size: 1.3em)[$A -> B quad A$]),
          line(length: 9em, stroke: 1.2pt + white),
          align(center, text(size: 1.3em)[$B$]),
        ),
      ),
    ),
  )

  #v(1.3fr)
]

// ------------------------------------------------------------
// SLIDE 6 — DERIVATION - SOME UNDERLINING DEFINITIONS (6/11)
// ------------------------------------------------------------

#slide(title: [Derivation - Some Underlining Definitions])[

  #panel(
    [Definition],

    stack(
      spacing: 0.7em,

      text(size: 1.05em)[
        (1) A _statement_ is of the form $M : sigma$. $M$ is called the _subject_ and $sigma$ the _type_.
      ],

      text(size: 1.05em)[
        (2) A _declaration_ is a statement $x : sigma$.
      ],

      text(size: 1.05em)[
        (3) A _context_ $Gamma$ is a set of declarations with different subjects.
      ],

      text(size: 1.05em)[
        (4) A _judgement_ is of the form $Gamma tack M : sigma$.
      ],

      text(size: 1.05em)[
        (5) A term $M$ is called _legal_ if there exists $Gamma$ and $sigma$ such that $Gamma tack M : sigma$.
      ],
    ),
  )

  #v(1em)

  #text(size: 1.15em)[Examples:]

  #v(0.5em)

  #set list(indent: 1.6em, spacing: 0.65em)

  #text(size: 1.25em)[
    + $emptyset tack (lambda x : alpha . thin x) : alpha -> alpha$

    + $y : alpha tack (lambda x : alpha . thin x) thin y : alpha$

    + $y : alpha -> sigma tack (lambda x : alpha . thin y thin x) : alpha -> sigma$
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 7 — DERIVATION - RULES (7/11)
// ------------------------------------------------------------

#slide(title: [Derivation - Rules])[
  #v(1fr)

  #grid(
    columns: (1fr, 3.2fr),
    gutter: 2em,
    align: horizon,

    align(center)[
      #text(size: 3.2em)[$lambda_arrow$]
    ],

    rect(
      stroke: 1pt + white,
      inset: (x: 1.5em, y: 1.4em),
      width: 100%,

      stack(
        spacing: 1.8em,

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.15em)[(var)],
          text(
            size: 1.2em,
          )[$Gamma tack x : sigma quad upright("if") thin x : sigma in Gamma$],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.15em)[(appl)],
          text(size: 1.2em)[
            $frac(Gamma tack M : sigma -> tau quad Gamma tack N : sigma, Gamma tack M N : tau)$
          ],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.15em)[(abst)],
          text(size: 1.2em)[
            $(Gamma, x : sigma tack M : tau) / (Gamma tack lambda x : sigma . thin M : sigma -> tau)$
          ],
        ),
      ),
    ),
  )

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 8 — DERIVATION - EXAMPLES I (8/11)
// ------------------------------------------------------------

#slide(title: [Derivation - Examples I])[
  #v(0.3em)

  #rect(stroke: 1pt + white, inset: (x: 1.2em, y: 0.7em))[
    #text(
      size: 1.15em,
    )[(var) #h(1.5em) $Gamma tack x : sigma quad upright("if") thin x : sigma in Gamma$]
  ]

  #v(1.5fr)

  #align(center)[
    #stack(
      spacing: 0.4em,

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 12em, stroke: 1.2pt + white), text(size: 1.1em)[(var)],
      ),

      text(size: 1.35em)[$x : alpha tack x : alpha$],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 22em, stroke: 1.2pt + white), text(size: 1.1em)[(abst)],
      ),

      text(
        size: 1.35em,
      )[$emptyset tack (lambda x : alpha . thin x) : alpha -> alpha$],
    )
  ]

  #v(2fr)
]

// ------------------------------------------------------------
// SLIDE 9 (a) — DERIVATION - EXAMPLES II (INITIAL) (9/11)
// ------------------------------------------------------------

#slide(title: [Derivation - Examples II])[
  #v(0.3em)

  #rect(stroke: 1pt + white, inset: (x: 1.2em, y: 0.7em))[
    #grid(
      columns: (auto, auto),
      column-gutter: 1.5em,
      align: horizon,
      text(size: 1.15em)[(appl)],
      text(size: 1.15em)[
        $frac(Gamma tack M : sigma -> tau quad Gamma tack N : sigma, Gamma tack M N : tau)$
      ],
    )
  ]

  #v(1.2fr)

  #align(center)[
    #stack(
      spacing: 0.45em,

      text(size: 1.3em)[
        $x : alpha tack y : alpha -> sigma quad quad x : alpha tack x : alpha$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 26em, stroke: 1.2pt + white), text(size: 1.1em)[(appl)],
      ),

      text(size: 1.3em)[
        $x : alpha tack y x : sigma$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 22em, stroke: 1.2pt + white), text(size: 1.1em)[(abst)],
      ),

      text(size: 1.3em)[
        $emptyset tack (lambda x : alpha . thin y x) : alpha -> sigma$
      ],
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 9 (b) — DERIVATION - EXAMPLES II (COMPLETED) (9/11)
// ------------------------------------------------------------

#slide(title: [Derivation - Examples II])[
  #v(0.3em)

  #rect(stroke: 1pt + white, inset: (x: 1.2em, y: 0.7em))[
    #text(
      size: 1.15em,
    )[(var) #h(1.5em) $Gamma tack x : sigma quad upright("if") thin x : sigma in Gamma$]
  ]

  #v(1.2fr)


  #align(center)[
    #stack(
      spacing: 0.45em,

      text(size: 1.25em)[
        $y : alpha -> sigma$$, x : alpha tack y : alpha -> sigma quad quad$
        $y : alpha -> sigma$$, x : alpha tack x : alpha$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 33em, stroke: 1.2pt + white), text(size: 1.1em)[(appl)],
      ),

      text(size: 1.25em)[
        $y : alpha -> sigma$$, x : alpha tack y x : sigma$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 26em, stroke: 1.2pt + white), text(size: 1.1em)[(abst)],
      ),

      text(size: 1.25em)[
        $y : alpha -> sigma$ $tack (lambda x : alpha . thin y x) : alpha -> sigma$
      ],
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 10 — DERIVATION - EXAMPLES III (10/11)
// ------------------------------------------------------------

#slide(title: [Derivation - Examples III])[
  #v(1fr)

  #align(center)[
    #stack(
      spacing: 0.45em,

      text(size: 1.2em)[
        $x : beta -> rho, y : beta tack x : beta -> rho quad quad x : beta -> rho, y : beta tack y : beta$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 33em, stroke: 1.2pt + white), text(size: 1.1em)[(appl)],
      ),

      text(size: 1.2em)[
        $x : beta -> rho, y : beta tack x y : rho$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 27em, stroke: 1.2pt + white), text(size: 1.1em)[(abst)],
      ),

      text(size: 1.2em)[
        $x : beta -> rho tack lambda y : beta . thin x y : beta -> rho$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 33em, stroke: 1.2pt + white), text(size: 1.1em)[(abst)],
      ),

      text(size: 1.2em)[
        $emptyset tack lambda x : beta -> rho . thin lambda y : beta . thin x y : (beta -> rho) -> beta -> rho$
      ],
    )
  ]

  #v(1.4fr)
]

// ------------------------------------------------------------
// SLIDE 11 — DERIVATION - EXAMPLES IV (NOT A LEGAL TERM) (11/11)
// ------------------------------------------------------------

#slide(title: [Derivation - Examples IV (Not a Legal Term)])[
  #v(1fr)

  #align(center)[
    #stack(
      spacing: 0.45em,

      text(size: 1.25em)[
        $x : alpha, y : beta tack x : beta -> rho quad quad x : alpha, y : beta tack y : beta$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 31em, stroke: 1.2pt + white), text(size: 1.1em)[(appl)],
      ),

      text(size: 1.25em)[
        $x : alpha, y : beta tack x y : rho$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 25em, stroke: 1.2pt + white), text(size: 1.1em)[(abst)],
      ),

      text(size: 1.25em)[
        $x : alpha tack lambda y : beta . thin x y : beta -> rho$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 29em, stroke: 1.2pt + white), text(size: 1.1em)[(abst)],
      ),

      text(size: 1.25em)[
        $emptyset tack lambda x : alpha . thin lambda y : beta . thin x y : alpha -> beta -> rho$
      ],
    )
  ]

  #v(1.4fr)
]
