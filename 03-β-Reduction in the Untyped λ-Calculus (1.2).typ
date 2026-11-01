// ============================================================
// β-Reduction in the Untyped Lambda Calculus (1.2)
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
    $beta$-Reduction in the Untyped $lambda$-Calculus
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
// SLIDE 2 — RECAP
// ------------------------------------------------------------

#slide(title: [Recap])[
  #v(1fr)

  #align(center + horizon)[
    #stack(
      dir: ltr,
      spacing: 2.2em,

      rect(
        stroke: 2pt + rgb("#D94848"),
        radius: 2.5em,
        inset: (x: 1.5em, y: 1em),
        text(size: 2.2em)[$(lambda x . M) N$],
      ),

      align(horizon)[
        #text(size: 2.8em, fill: rgb("#D94848"))[$arrow.r$]
      ],

      rect(
        stroke: 2pt + rgb("#D94848"),
        radius: 2.5em,
        inset: (x: 1.5em, y: 1em),
        text(size: 2.2em)[$M [x := N]$],
      ),
    )
  ]

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 3 — ONE-STEP BETA-REDUCTION
// ------------------------------------------------------------

#slide(title: [Computation With One-Step $beta$-Reduction])[

  #panel(
    [Definition (One-Step $beta$-Reduction $arrow.r_beta$)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 1.5em,
      row-gutter: 0.8em,
      align: (left + horizon, left + horizon),

      text(size: 1.05em, weight: "bold")[Basis],
      text(size: 1.05em)[$(lambda x . M) N arrow.r_beta M [x := N].$],

      text(size: 1.05em, weight: "bold")[Compatibility],
      text(size: 1.05em)[
        If $M arrow.r_beta N$, then $M L arrow.r_beta N L$,
        $L M arrow.r_beta L N$ and $lambda x . M arrow.r_beta lambda x . N$.
      ],
    ),
  )

  #v(0.6em)

  // Blackboard diagram: redex -> contractum
  #align(center)[
    #stack(
      dir: ltr,
      spacing: 1.5em,

      rect(stroke: 1pt + white, inset: (x: 1.2em, y: 0.4em))[
        $...$ #text(fill: gold)[$(lambda x . M) N$] $...$ \
        #v(-0.35em)
        #text(size: 0.85em, fill: gold)[$underbrace(#h(7em), upright("redex"))$]
      ],

      align(horizon)[
        #text(size: 1.5em)[$arrow.r_beta$]
      ],

      rect(stroke: 1pt + white, inset: (x: 1.2em, y: 0.4em))[
        $...$ #text(fill: gold)[$M [x := N]$] $...$ \
        #v(-0.35em)
        #text(size: 0.85em, fill: gold)[$underbrace(#h(7em), upright("contractum"))$]
      ],
    )
  ]

  #v(0.6em)

  #text(size: 1.15em)[Examples:]

  #v(0.4em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.55em,
    align: (left + top, left + top),

    text(size: 1.1em)[1.],
    text(size: 1.1em)[
      $(lambda x . x (x y)) N arrow.r_beta (x (x y))[x := N] equiv N (N y)$
    ],

    text(size: 1.1em)[2.],
    stack(
      spacing: 0.45em,
      text(size: 1.1em)[
        $(lambda x . (lambda y . x y) z) v arrow.r_beta (lambda x . (x y)[y := z]) v equiv (lambda x . x z) v arrow.r_beta v z$
      ],
      text(size: 1.1em)[
        $(lambda x . (lambda y . x y) z) v arrow.r_beta (lambda y . (x y) z)[x := v] equiv (lambda y . v y) z arrow.r_beta v z$
      ],
    ),

    text(size: 1.1em)[3.],
    text(size: 1.1em)[
      $Omega equiv (lambda x . x x) (lambda x . x x) arrow.r_beta (lambda x . x x) (lambda x . x x) arrow.r_beta dots$
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 4 — MANY-STEP BETA-REDUCTION
// ------------------------------------------------------------

#slide(title: [Many-Step $beta$-Reduction])[

  #panel(
    [Definition (Many-Step $beta$-Reduction $arrow.r_beta^*$)],

    stack(
      spacing: 0.6em,

      text(size: 1.05em)[
        $M arrow.r_beta^* N$ if there is an $n >= 0$ and terms $M_0, dots, M_n in Lambda$
        such that $M_0 equiv M$, $M_n equiv N$ and for all $1 <= i <= n$
      ],

      align(center)[
        #text(size: 1.2em)[$M_i arrow.r_beta M_(i+1).$]
      ],
    ),
  )

  #v(1em)

  #text(size: 1.15em)[Examples:]

  #v(0.6em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.8em,
    align: (left + horizon, left + horizon),

    text(size: 1.15em)[1.],
    text(size: 1.15em)[
      $(lambda x . x (x y)) N arrow.r_beta^* N (N y)$
    ],

    text(size: 1.15em)[2.],
    text(size: 1.15em)[
      $(lambda x . (lambda y . x y) z) v arrow.r_beta^* v z$
    ],

    text(size: 1.15em)[3.],
    text(size: 1.15em)[
      $Omega equiv (lambda x . x x) (lambda x . x x) arrow.r_beta^* Omega arrow.r_beta^* dots$
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 5 — ONE-WAY TO TWO-WAY COMPUTATION
// ------------------------------------------------------------

#slide(title: [From One-Way to Two-Way Computation])[
  #v(1.2fr)

  #align(center)[
    #text(size: 2.1em)[
      $f(5) = 5^2 + 1 quad arrow.r quad 25 + 1 quad arrow.r quad 26$
    ]
  ]

  #v(2.5em)

  #align(center)[
    #text(size: 2.1em)[
      $(a^2 + 2 a b + b^2) / (a + b) quad arrow.l quad ((a + b)^2) / (a + b) quad arrow.r quad a + b$
    ]
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 6 — TWO-WAY COMPUTATION: BETA-CONVERSION
// ------------------------------------------------------------

#slide(title: [Two-Way Computation: $beta$-Conversion])[

  #panel(
    [$beta$-Conversion $=_beta$],

    stack(
      spacing: 0.6em,

      text(size: 1.05em)[
        $M =_beta N$ if there is an $n >= 0$ and terms $M_0, dots, M_n in Lambda$
        such that $M_0 equiv M$, $M_n equiv N$ and for all $1 <= i <= n$ either
      ],

      align(center)[
        #text(size: 1.2em)[
          $M_i arrow.r_beta M_(i+1) quad upright("or") quad M_(i+1) arrow.r_beta M_i.$
        ]
      ],
    ),
  )

  #v(1em)

  #text(size: 1.15em)[Examples:]

  #v(0.6em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.8em,
    align: (left + top, left + top),

    text(size: 1.15em)[1.],
    stack(
      spacing: 0.5em,
      text(size: 1.15em)[
        $(lambda y . y v) z =_beta (lambda x . z x) v$
      ],
      text(size: 1.15em)[
        $(lambda y . y v) z arrow.r_beta z v quad _beta arrow.l (lambda x . z x) v$
      ],
    ),

    text(size: 1.15em)[2.],
    text(size: 1.15em)[
      $(lambda x . x (x y)) N =_beta N (N y) =_beta (lambda z . N (N z)) y$
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 7 — COMPARISON BLACKBOARD
// ------------------------------------------------------------

#slide(title: [Two-Way Computation: $beta$-Conversion])[
  #v(0.5em)

  #grid(
    columns: (1.2fr, 1fr, 1fr),
    align: top + center,

    // Left: syntactic equivalence
    stack(
      spacing: 0.8em,
      text(size: 1.2em, fill: gold, style: "italic")[
        syntactical equivalence
      ],
      text(size: 2.2em)[$equiv$],
      v(0.2em),
      grid(
        columns: (auto, 1fr),
        column-gutter: 0.4em,
        row-gutter: 0.6em,
        align: left + horizon,
        text(fill: gold)[⤷],
        text(size: 1.15em, style: "italic")[substitution],
        text(fill: gold)[⤷],
        text(size: 1.15em, style: "italic")[$alpha$-equivalence],
      ),
    ),

    // Middle: beta-reduction
    stack(
      spacing: 0.8em,
      text(size: 1.2em, fill: gold, style: "italic")[
        beta-reduction
      ],
      text(size: 2.2em)[$arrow.r_beta$],
    ),

    // Right: beta-conversion
    stack(
      spacing: 0.8em,
      v(1.9em),
      text(size: 2.2em)[$=_beta$],
      text(size: 1.2em, fill: gold, style: "italic")[
        ( \
        beta-conversion
      ],
    ),
  )

  #v(2em)

  #align(center)[
    #block(width: 70%)[
      #line(length: 100%, stroke: 1.2pt + white)
      #v(0.4em)
      #grid(
        columns: (1.2fr, 1fr, 1fr),
        align: center + horizon,
        row-gutter: 0.8em,

        text(size: 1.4em, style: "italic")[even?],
        text(size: 1.4em, style: "italic")[odd],
        text(size: 1.4em, style: "italic")[even],

        none,
        text(size: 1.5em)[1],
        text(size: 1.5em)[2],
      )
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 8 — BETA-NORMAL FORM
// ------------------------------------------------------------

#slide(title: [$beta$-Normal Form])[

  #panel(
    [Definition ($beta$-Normal Form)],

    stack(
      spacing: 0.7em,

      text(size: 1.05em)[
        (1) $M$ is in $beta$-normal form if $M$ does not contain any redex.
      ],

      text(size: 1.05em)[
        (2) $M$ has a $beta$-normal form if there is an $N in Lambda$ in
        $beta$-normal form such that $M =_beta N$.
      ],
    ),
  )

  #v(1em)

  #text(size: 1.15em)[Examples:]

  #v(0.6em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.8em,
    align: (left + top, left + top),

    text(size: 1.15em)[1.],
    text(size: 1.15em)[
      $(lambda x . (lambda y . x y) z) v$ has a $beta$-normal form $v z$.
    ],

    text(size: 1.15em)[2.],
    text(size: 1.15em)[
      $Omega equiv (lambda x . x x) (lambda x . x x)$ does not have a $beta$-normal form.
    ],

    text(size: 1.15em)[3.],
    stack(
      spacing: 0.5em,
      text(size: 1.15em)[
        $(lambda v . u) Omega equiv (lambda v . u) ((lambda x . x x) (lambda x . x x))$ has a $beta$-normal form $u$.
      ],
      text(size: 1.15em)[
        $(lambda v . u) Omega arrow.r_beta (lambda v . u) Omega arrow.r_beta dots$
      ],
      text(size: 1.15em)[
        $(lambda v . u) Omega arrow.r_beta u$
      ],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 9 — WEAKLY AND STRONGLY NORMALIZING
// ------------------------------------------------------------

#slide(title: [Weakly and Strongly Normalizing])[

  #panel(
    [Definition (Weak Normalization, Strong Normalization)],

    stack(
      spacing: 0.7em,

      text(size: 1.05em)[
        (1) $M$ is weakly normalising if there is an $N in Lambda$ in
        $beta$-normal form such that $M arrow.r_beta^* N$.
      ],

      text(size: 1.05em)[
        (2) $M$ is strongly normalizing if every chain of reductions
        starting from $M$ reaches the $beta$-normal form.
      ],
    ),
  )

  #v(0.8em)

  #text(size: 1.15em)[Examples:]

  #v(0.5em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.6em,
    align: (left + horizon, left + horizon),

    text(size: 1.1em)[1.],
    text(size: 1.1em)[
      $(lambda x . (lambda y . x y) z) v$ is strongly normalizing.
    ],

    text(size: 1.1em)[2.],
    text(size: 1.1em)[
      $Omega equiv (lambda x . x x) (lambda x . x x)$ is not normalizing.
    ],

    text(size: 1.1em)[3.],
    text(size: 1.1em)[
      $(lambda v . u) Omega equiv (lambda v . u) ((lambda x . x x) (lambda x . x x))$ is weakly normalizing.
    ],
  )

  #v(0.8em)

  #panel(
    [Definition (Normalization of Systems)],

    grid(
      columns: (1fr, auto),
      gutter: 1.2em,
      align: horizon,

      text(size: 1.05em)[
        A rewrite system is strongly/weakly normalizing if every term
        in the system is strongly/weakly normalizing. Otherwise it is
        not normalizing.
      ],

      text(size: 1.15em, fill: gold, style: "italic")[
        ⤷ every program terminates
      ],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 10 — CHURCH-ROSSER THEOREM
// ------------------------------------------------------------

#slide(title: [Church-Rosser Theorem])[

  #panel(
    [Theorem #text(fill: gold, style: "italic")[(order does not matter)]],

    stack(
      spacing: 0.65em,

      text(size: 1.05em)[
        Let $M, N_1, N_2 in Lambda$ be $lambda$-terms with
        $M arrow.r_beta^* N_1$ and $M arrow.r_beta^* N_2$.
      ],

      text(size: 1.05em)[
        Then there is a $lambda$-term $N_3 in Lambda$ such that
        $N_1 arrow.r_beta^* N_3$ and $N_2 arrow.r_beta^* N_3$.
      ],
    ),
  )

  #v(1.2em)

  // Two Confluence Diamonds
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 2em,
    align: center + horizon,

    // Left Diamond (General)
    stack(
      spacing: 0.5em,

      text(size: 1.7em)[$M$],

      #grid(
        columns: (1fr, 1.2fr, 1fr),
        align: center + horizon,
        text(size: 1.4em)[$arrow.sw_beta^*$],
        none,
        text(size: 1.4em)[$arrow.se_beta^*$],
      ),

      #grid(
        columns: (1fr, 1.2fr, 1fr),
        align: center + horizon,
        text(size: 1.7em)[$N_1$],
        none,
        text(size: 1.7em)[$N_2$],
      ),

      #grid(
        columns: (1fr, 1.2fr, 1fr),
        align: center + horizon,
        text(size: 1.4em)[$arrow.se_beta^*$],
        none,
        text(size: 1.4em)[$arrow.sw_beta^*$],
      ),

      text(size: 1.7em)[$N_3$],
    ),

    // Right Diamond (Concrete Example)
    stack(
      spacing: 0.5em,

      text(size: 1.4em)[$(lambda x . (lambda y . x y) z) v$],

      #grid(
        columns: (1fr, 1fr, 1fr),
        align: center + horizon,
        text(size: 1.4em)[$arrow.sw_beta$],
        none,
        text(size: 1.4em)[$arrow.se_beta$],
      ),

      #grid(
        columns: (1.1fr, 0.6fr, 1.1fr),
        align: center + horizon,
        text(size: 1.35em)[$(lambda y . v y) z$],
        none,
        text(size: 1.35em)[$(lambda x . x z) v$],
      ),

      #grid(
        columns: (1fr, 1fr, 1fr),
        align: center + horizon,
        text(size: 1.4em)[$arrow.se_beta$],
        none,
        text(size: 1.4em)[$arrow.sw_beta$],
      ),

      text(size: 1.45em)[$v z$],
    ),
  )

  #v(1fr)
]
```

---

### Nushell Script to Apply and Compile

Run this in your terminal:

```nu
let file_path = "/home/srghma/projects/lean-melearning-lambda-cube-theo-reto-videos/03-β-Reduction in the Untyped λ-Calculus (1.2).typ"

let content = r#'// ============================================================
// β-Reduction in the Untyped Lambda Calculus (1.2)
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
    $beta$-Reduction in the Untyped $lambda$-Calculus
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
// SLIDE 2 — RECAP
// ------------------------------------------------------------

#slide(title: [Recap])[
  #v(1fr)

  #align(center + horizon)[
    #stack(
      dir: ltr,
      spacing: 2.2em,

      rect(
        stroke: 2pt + rgb("#D94848"),
        radius: 2.5em,
        inset: (x: 1.5em, y: 1em),
        text(size: 2.2em)[$(lambda x . M) N$],
      ),

      align(horizon)[
        #text(size: 2.8em, fill: rgb("#D94848"))[$arrow.r$]
      ],

      rect(
        stroke: 2pt + rgb("#D94848"),
        radius: 2.5em,
        inset: (x: 1.5em, y: 1em),
        text(size: 2.2em)[$M [x := N]$],
      ),
    )
  ]

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 3 — ONE-STEP BETA-REDUCTION
// ------------------------------------------------------------

#slide(title: [Computation With One-Step $beta$-Reduction])[

  #panel(
    [Definition (One-Step $beta$-Reduction $arrow.r_beta$)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 1.5em,
      row-gutter: 0.8em,
      align: (left + horizon, left + horizon),

      text(size: 1.05em, weight: "bold")[Basis],
      text(size: 1.05em)[$(lambda x . M) N arrow.r_beta M [x := N].$],

      text(size: 1.05em, weight: "bold")[Compatibility],
      text(size: 1.05em)[
        If $M arrow.r_beta N$, then $M L arrow.r_beta N L$,
        $L M arrow.r_beta L N$ and $lambda x . M arrow.r_beta lambda x . N$.
      ],
    ),
  )

  #v(0.6em)

  // Blackboard diagram: redex -> contractum
  #align(center)[
    #stack(
      dir: ltr,
      spacing: 1.5em,

      rect(stroke: 1pt + white, inset: (x: 1.2em, y: 0.4em))[
        $...$ #text(fill: gold)[$(lambda x . M) N$] $...$ \
        #v(-0.35em)
        #text(size: 0.85em, fill: gold)[$underbrace(#h(7em), upright("redex"))$]
      ],

      align(horizon)[
        #text(size: 1.5em)[$arrow.r_beta$]
      ],

      rect(stroke: 1pt + white, inset: (x: 1.2em, y: 0.4em))[
        $...$ #text(fill: gold)[$M [x := N]$] $...$ \
        #v(-0.35em)
        #text(size: 0.85em, fill: gold)[$underbrace(#h(7em), upright("contractum"))$]
      ],
    )
  ]

  #v(0.6em)

  #text(size: 1.15em)[Examples:]

  #v(0.4em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.55em,
    align: (left + top, left + top),

    text(size: 1.1em)[1.],
    text(size: 1.1em)[
      $(lambda x . x (x y)) N arrow.r_beta (x (x y))[x := N] equiv N (N y)$
    ],

    text(size: 1.1em)[2.],
    stack(
      spacing: 0.45em,
      text(size: 1.1em)[
        $(lambda x . (lambda y . x y) z) v arrow.r_beta (lambda x . (x y)[y := z]) v equiv (lambda x . x z) v arrow.r_beta v z$
      ],
      text(size: 1.1em)[
        $(lambda x . (lambda y . x y) z) v arrow.r_beta (lambda y . (x y) z)[x := v] equiv (lambda y . v y) z arrow.r_beta v z$
      ],
    ),

    text(size: 1.1em)[3.],
    text(size: 1.1em)[
      $Omega equiv (lambda x . x x) (lambda x . x x) arrow.r_beta (lambda x . x x) (lambda x . x x) arrow.r_beta dots$
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 4 — MANY-STEP BETA-REDUCTION
// ------------------------------------------------------------

#slide(title: [Many-Step $beta$-Reduction])[

  #panel(
    [Definition (Many-Step $beta$-Reduction $arrow.r_beta^*$)],

    stack(
      spacing: 0.6em,

      text(size: 1.05em)[
        $M arrow.r_beta^* N$ if there is an $n >= 0$ and terms $M_0, dots, M_n in Lambda$
        such that $M_0 equiv M$, $M_n equiv N$ and for all $1 <= i <= n$
      ],

      align(center)[
        #text(size: 1.2em)[$M_i arrow.r_beta M_(i+1).$]
      ],
    ),
  )

  #v(1em)

  #text(size: 1.15em)[Examples:]

  #v(0.6em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.8em,
    align: (left + horizon, left + horizon),

    text(size: 1.15em)[1.],
    text(size: 1.15em)[
      $(lambda x . x (x y)) N arrow.r_beta^* N (N y)$
    ],

    text(size: 1.15em)[2.],
    text(size: 1.15em)[
      $(lambda x . (lambda y . x y) z) v arrow.r_beta^* v z$
    ],

    text(size: 1.15em)[3.],
    text(size: 1.15em)[
      $Omega equiv (lambda x . x x) (lambda x . x x) arrow.r_beta^* Omega arrow.r_beta^* dots$
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 5 — ONE-WAY TO TWO-WAY COMPUTATION
// ------------------------------------------------------------

#slide(title: [From One-Way to Two-Way Computation])[
  #v(1.2fr)

  #align(center)[
    #text(size: 2.1em)[
      $f(5) = 5^2 + 1 quad arrow.r quad 25 + 1 quad arrow.r quad 26$
    ]
  ]

  #v(2.5em)

  #align(center)[
    #text(size: 2.1em)[
      $(a^2 + 2 a b + b^2) / (a + b) quad arrow.l quad ((a + b)^2) / (a + b) quad arrow.r quad a + b$
    ]
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 6 — TWO-WAY COMPUTATION: BETA-CONVERSION
// ------------------------------------------------------------

#slide(title: [Two-Way Computation: $beta$-Conversion])[

  #panel(
    [$beta$-Conversion $=_beta$],

    stack(
      spacing: 0.6em,

      text(size: 1.05em)[
        $M =_beta N$ if there is an $n >= 0$ and terms $M_0, dots, M_n in Lambda$
        such that $M_0 equiv M$, $M_n equiv N$ and for all $1 <= i <= n$ either
      ],

      align(center)[
        #text(size: 1.2em)[
          $M_i arrow.r_beta M_(i+1) quad upright("or") quad M_(i+1) arrow.r_beta M_i.$
        ]
      ],
    ),
  )

  #v(1em)

  #text(size: 1.15em)[Examples:]

  #v(0.6em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.8em,
    align: (left + top, left + top),

    text(size: 1.15em)[1.],
    stack(
      spacing: 0.5em,
      text(size: 1.15em)[
        $(lambda y . y v) z =_beta (lambda x . z x) v$
      ],
      text(size: 1.15em)[
        $(lambda y . y v) z arrow.r_beta z v quad _beta arrow.l (lambda x . z x) v$
      ],
    ),

    text(size: 1.15em)[2.],
    text(size: 1.15em)[
      $(lambda x . x (x y)) N =_beta N (N y) =_beta (lambda z . N (N z)) y$
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 7 — COMPARISON BLACKBOARD
// ------------------------------------------------------------

#slide(title: [Two-Way Computation: $beta$-Conversion])[
  #v(0.5em)

  #grid(
    columns: (1.2fr, 1fr, 1fr),
    align: top + center,

    // Left: syntactic equivalence
    stack(
      spacing: 0.8em,
      text(size: 1.2em, fill: gold, style: "italic")[
        syntactical equivalence
      ],
      text(size: 2.2em)[$equiv$],
      v(0.2em),
      grid(
        columns: (auto, 1fr),
        column-gutter: 0.4em,
        row-gutter: 0.6em,
        align: left + horizon,
        text(fill: gold)[⤷],
        text(size: 1.15em, style: "italic")[substitution],
        text(fill: gold)[⤷],
        text(size: 1.15em, style: "italic")[$alpha$-equivalence],
      ),
    ),

    // Middle: beta-reduction
    stack(
      spacing: 0.8em,
      text(size: 1.2em, fill: gold, style: "italic")[
        beta-reduction
      ],
      text(size: 2.2em)[$arrow.r_beta$],
    ),

    // Right: beta-conversion
    stack(
      spacing: 0.8em,
      v(1.9em),
      text(size: 2.2em)[$=_beta$],
      text(size: 1.2em, fill: gold, style: "italic")[
        ( \
        beta-conversion
      ],
    ),
  )

  #v(2em)

  #align(center)[
    #block(width: 70%)[
      #line(length: 100%, stroke: 1.2pt + white)
      #v(0.4em)
      #grid(
        columns: (1.2fr, 1fr, 1fr),
        align: center + horizon,
        row-gutter: 0.8em,

        text(size: 1.4em, style: "italic")[even?],
        text(size: 1.4em, style: "italic")[odd],
        text(size: 1.4em, style: "italic")[even],

        none,
        text(size: 1.5em)[1],
        text(size: 1.5em)[2],
      )
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 8 — BETA-NORMAL FORM
// ------------------------------------------------------------

#slide(title: [$beta$-Normal Form])[

  #panel(
    [Definition ($beta$-Normal Form)],

    stack(
      spacing: 0.7em,

      text(size: 1.05em)[
        (1) $M$ is in $beta$-normal form if $M$ does not contain any redex.
      ],

      text(size: 1.05em)[
        (2) $M$ has a $beta$-normal form if there is an $N in Lambda$ in
        $beta$-normal form such that $M =_beta N$.
      ],
    ),
  )

  #v(1em)

  #text(size: 1.15em)[Examples:]

  #v(0.6em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.8em,
    align: (left + top, left + top),

    text(size: 1.15em)[1.],
    text(size: 1.15em)[
      $(lambda x . (lambda y . x y) z) v$ has a $beta$-normal form $v z$.
    ],

    text(size: 1.15em)[2.],
    text(size: 1.15em)[
      $Omega equiv (lambda x . x x) (lambda x . x x)$ does not have a $beta$-normal form.
    ],

    text(size: 1.15em)[3.],
    stack(
      spacing: 0.5em,
      text(size: 1.15em)[
        $(lambda v . u) Omega equiv (lambda v . u) ((lambda x . x x) (lambda x . x x))$ has a $beta$-normal form $u$.
      ],
      text(size: 1.15em)[
        $(lambda v . u) Omega arrow.r_beta (lambda v . u) Omega arrow.r_beta dots$
      ],
      text(size: 1.15em)[
        $(lambda v . u) Omega arrow.r_beta u$
      ],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 9 — WEAKLY AND STRONGLY NORMALIZING
// ------------------------------------------------------------

#slide(title: [Weakly and Strongly Normalizing])[

  #panel(
    [Definition (Weak Normalization, Strong Normalization)],

    stack(
      spacing: 0.7em,

      text(size: 1.05em)[
        (1) $M$ is weakly normalising if there is an $N in Lambda$ in
        $beta$-normal form such that $M arrow.r_beta^* N$.
      ],

      text(size: 1.05em)[
        (2) $M$ is strongly normalizing if every chain of reductions
        starting from $M$ reaches the $beta$-normal form.
      ],
    ),
  )

  #v(0.8em)

  #text(size: 1.15em)[Examples:]

  #v(0.5em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.6em,
    align: (left + horizon, left + horizon),

    text(size: 1.1em)[1.],
    text(size: 1.1em)[
      $(lambda x . (lambda y . x y) z) v$ is strongly normalizing.
    ],

    text(size: 1.1em)[2.],
    text(size: 1.1em)[
      $Omega equiv (lambda x . x x) (lambda x . x x)$ is not normalizing.
    ],

    text(size: 1.1em)[3.],
    text(size: 1.1em)[
      $(lambda v . u) Omega equiv (lambda v . u) ((lambda x . x x) (lambda x . x x))$ is weakly normalizing.
    ],
  )

  #v(0.8em)

  #panel(
    [Definition (Normalization of Systems)],

    grid(
      columns: (1fr, auto),
      gutter: 1.2em,
      align: horizon,

      text(size: 1.05em)[
        A rewrite system is strongly/weakly normalizing if every term
        in the system is strongly/weakly normalizing. Otherwise it is
        not normalizing.
      ],

      text(size: 1.15em, fill: gold, style: "italic")[
        ⤷ every program terminates
      ],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 10 — CHURCH-ROSSER THEOREM
// ------------------------------------------------------------

#slide(title: [Church-Rosser Theorem])[

  #panel(
    [Theorem #text(fill: gold, style: "italic")[(order does not matter)]],

    stack(
      spacing: 0.65em,

      text(size: 1.05em)[
        Let $M, N_1, N_2 in Lambda$ be $lambda$-terms with
        $M arrow.r_beta^* N_1$ and $M arrow.r_beta^* N_2$.
      ],

      text(size: 1.05em)[
        Then there is a $lambda$-term $N_3 in Lambda$ such that
        $N_1 arrow.r_beta^* N_3$ and $N_2 arrow.r_beta^* N_3$.
      ],
    ),
  )

  #v(1.2em)

  // Two Confluence Diamonds
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 2em,
    align: center + horizon,

    // Left Diamond (General)
    stack(
      spacing: 0.5em,

      text(size: 1.7em)[$M$],

      #grid(
        columns: (1fr, 1.2fr, 1fr),
        align: center + horizon,
        text(size: 1.4em)[$arrow.sw_beta^*$],
        none,
        text(size: 1.4em)[$arrow.se_beta^*$],
      ),

      #grid(
        columns: (1fr, 1.2fr, 1fr),
        align: center + horizon,
        text(size: 1.7em)[$N_1$],
        none,
        text(size: 1.7em)[$N_2$],
      ),

      #grid(
        columns: (1fr, 1.2fr, 1fr),
        align: center + horizon,
        text(size: 1.4em)[$arrow.se_beta^*$],
        none,
        text(size: 1.4em)[$arrow.sw_beta^*$],
      ),

      text(size: 1.7em)[$N_3$],
    ),

    // Right Diamond (Concrete Example)
    stack(
      spacing: 0.5em,

      text(size: 1.4em)[$(lambda x . (lambda y . x y) z) v$],

      #grid(
        columns: (1fr, 1fr, 1fr),
        align: center + horizon,
        text(size: 1.4em)[$arrow.sw_beta$],
        none,
        text(size: 1.4em)[$arrow.se_beta$],
      ),

      #grid(
        columns: (1.1fr, 0.6fr, 1.1fr),
        align: center + horizon,
        text(size: 1.35em)[$(lambda y . v y) z$],
        none,
        text(size: 1.35em)[$(lambda x . x z) v$],
      ),

      #grid(
        columns: (1fr, 1fr, 1fr),
        align: center + horizon,
        text(size: 1.4em)[$arrow.se_beta$],
        none,
        text(size: 1.4em)[$arrow.sw_beta$],
      ),

      text(size: 1.45em)[$v z$],
    ),
  )

  #v(1fr)
]
