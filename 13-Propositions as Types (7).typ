// ============================================================
// Propositions as Types (7)
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE (1/24)
// ------------------------------------------------------------

#title-slide(
  [Propositions as Types],
  year: 2021,
  institution: "Technische Universität Berlin",
)

// ------------------------------------------------------------
// SLIDE 2 — THE IDEA (2/24)
// ------------------------------------------------------------

#slide(title: [The Idea])[
  #v(0.6fr)

  // Top diagram of correspondences
  #align(center)[
    #text(size: 1.35em, fill: gold)[
      $lambda quad <--> quad upright("math") quad <--> quad upright("types") quad <--> quad upright("logic")$
    ]
  ]

  #v(1.8fr)

  // Center PAT callout
  #align(center)[
    #text(size: 4em, weight: "medium")[PAT]
  ]

  #v(2.2fr)

  // Bottom pair
  #grid(
    columns: (1fr, 1fr),
    align: (center, center),
    text(size: 1.3em)[propositions-as-types],
    text(size: 1.3em)[proofs-as-terms],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 3 — PROPOSITION AS A TYPE (3/24)
// ------------------------------------------------------------

#slide(title: [Proposition as a Type])[
  #v(1.2fr)

  #align(center)[
    #grid(
      columns: (10em, 4em, 12em),
      row-gutter: 1.2em,
      align: center + horizon,

      text(size: 1.8em)[$M$],
      text(size: 1.8em)[$:$],
      text(size: 1.8em)[$sigma$],

      text(size: 1.6em)[$arrow.t.b$], none, text(size: 1.6em)[$arrow.t.b$],

      text(size: 1.35em)[proof],
      text(size: 1.2em)[of],
      text(size: 1.35em)[proposition $P$],
    )
  ]

  #v(3em)

  #align(center)[
    #text(size: 1.4em)[
      $sigma$ is inhabited $quad <==> quad P$ is true
    ]
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 4 — FIRST-ORDER LOGIC - CLASSICAL (4/24)
// ------------------------------------------------------------

#slide(title: [First-Order Logic - Classical])[
  #v(1.2fr)

  #block(inset: (left: 2.5em))[
    #grid(
      columns: (13em, 12em, auto),
      row-gutter: 2.2em,
      align: (left + top, left + top, left + top),

      // Terms
      text(size: 1.3em, weight: "bold")[Terms $t_1, dots, t_n$ :],
      text(size: 1.25em)[Elements/Functions],
      text(size: 1.25em)[$x, f(x_1, dots, x_n)$],

      // Formulas
      text(
        size: 1.3em,
        weight: "bold",
      )[Formulas $phi.alt_1, dots, phi.alt_n$ :],
      stack(
        spacing: 0.9em,
        text(size: 1.25em)[Predicates],
        text(size: 1.25em)[Quantifiers],
        text(size: 1.25em)[Connectives],
      ),
      stack(
        spacing: 0.9em,
        text(size: 1.25em)[$P(t_1, dots, t_n)$],
        text(size: 1.25em)[$forall, exists$],
        text(size: 1.25em)[$not, or, and, ==>$],
      ),
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 5 — INTUITIONISTIC VS. CLASSICAL LOGIC (5/24)
// ------------------------------------------------------------

#slide(title: [Intuitionistic vs. Classical Logic])[
  #v(0.8fr)

  #align(center)[
    #text(size: 1.4em)[
      For any true statement there has to be a constructive proof!
    ]
  ]

  #v(2em)

  #align(center)[
    #stack(
      spacing: 0.7em,
      text(size: 1.35em)[No law of excluded middle.],
      text(size: 1.25em)[
        #strike(stroke: 1.2pt + white)[( $A or not A$ is always true )]
      ],
    )
  ]

  #v(2em)

  #align(center)[
    #stack(
      spacing: 0.7em,
      text(size: 1.35em)[No double negation elimination.],
      text(size: 1.25em)[
        #strike(stroke: 1.2pt + white)[( $A equiv not (not A)$ )]
      ],
    )
  ]

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 6 — FIRST-ORDER LOGIC - CONSTRUCTIVE (6/24)
// ------------------------------------------------------------

#slide(title: [First-Order Logic - Constructive])[
  #v(1.2fr)

  #block(inset: (left: 2.5em))[
    #grid(
      columns: (13em, 12em, auto),
      row-gutter: 2.2em,
      align: (left + top, left + top, left + top),

      // Terms
      text(size: 1.3em, weight: "bold")[Terms $t_1, dots, t_n$ :],
      text(size: 1.25em)[Elements/Functions],
      text(size: 1.25em)[$x, f(x_1, dots, x_n)$],

      // Formulas
      text(
        size: 1.3em,
        weight: "bold",
      )[Formulas $phi.alt_1, dots, phi.alt_n$ :],
      stack(
        spacing: 0.9em,
        text(size: 1.25em)[Predicates],
        text(size: 1.25em)[Quantifiers],
        text(size: 1.25em)[Connectives],
      ),
      stack(
        spacing: 0.9em,
        text(size: 1.25em)[$P(t_1, dots, t_n)$],
        text(size: 1.25em)[$forall, exists$],
        text(size: 1.25em)[$not, or, and, ==>$],
      ),
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 7 — SETS - UNARY PREDICATES (7/24)
// ------------------------------------------------------------

#slide(title: [Sets - Unary Predicates])[
  #v(0.6fr)

  #align(center)[
    #grid(
      columns: (14em, 4em, 16em),
      row-gutter: 0.9em,
      align: center + horizon,

      text(size: 1.6em)[$x$], text(size: 1.5em)[$:$], text(size: 1.6em)[$S$],

      text(size: 1.4em)[$arrow.t.b$], none, text(size: 1.4em)[$arrow.t.b$],

      text(size: 1.15em)[#quote[an element $x in S$]],
      text(size: 1.15em)[for],
      text(size: 1.15em)[#quote[set $S$ contains elements]],

      text(size: 1.4em)[$arrow.t$], none, text(size: 1.4em)[$arrow.t$],

      text(size: 1.25em)[member as term],
      text(size: 1.15em)[with],
      text(size: 1.25em)[set as type],

      text(size: 1.4em)[$arrow.b$], none, text(size: 1.4em)[$arrow.b$],

      text(size: 1.35em)[$c_n$],
      text(size: 1.35em)[$:$],
      text(size: 1.35em)[$(alpha -> alpha) -> alpha -> alpha$],
    )
  ]

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 8 — PREDICATES (8/24)
// ------------------------------------------------------------

#slide(title: [Predicates])[
  #v(0.8fr)

  #grid(
    columns: (1fr, 1.2fr),
    gutter: 2.5em,
    align: top + left,

    // Left Column: Logic
    block(inset: (left: 1.5em))[
      #stack(
        spacing: 1.5em,
        align(center, text(size: 1.5em, weight: "bold")[Logic]),
        v(0.5em),
        grid(
          columns: (7.5em, auto),
          row-gutter: 1.1em,
          align: (left + horizon, left + horizon),

          text(size: 1.2em)[Predicate], text(size: 1.35em)[$P$],

          text(size: 1.2em)[Element], text(size: 1.25em)[$x in S$],

          text(size: 1.2em)[Proposition], text(size: 1.25em)[$P(x)$],

          none,
          stack(
            spacing: 0.6em,
            text(size: 1.2em)[true],
            text(size: 1.2em)[false],
          ),
        ),
      )
    ],

    // Right Column: λ-Calculus
    block(inset: (left: 1em))[
      #stack(
        spacing: 1.5em,
        align(center, text(size: 1.5em, weight: "bold")[$lambda$-Calculus]),
        v(0.5em),
        grid(
          columns: (11.5em, auto),
          row-gutter: 1.1em,
          align: (left + horizon, left + horizon),

          text(size: 1.2em)[Proper Constructor],
          text(size: 1.25em)[$P : S -> *$],

          text(size: 1.2em)[Term], text(size: 1.25em)[$x : S$],

          text(size: 1.2em)[Type], text(size: 1.25em)[$P x : *$],

          none,
          stack(
            spacing: 0.6em,
            text(size: 1.2em)[inhabited],
            text(size: 1.2em)[not inhabited],
          ),
        ),
      )
    ],
  )

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 9 — IMPLICATION (9/24)
// ------------------------------------------------------------

#slide(title: [Implication])[
  #v(1.2fr)

  #grid(
    columns: (1fr, 1.4fr),
    gutter: 2.5em,
    align: top + center,

    // Left: Logic
    stack(
      spacing: 2.2em,
      text(size: 1.5em, weight: "bold")[Logic],

      text(size: 1.6em)[$A ==> B$],

      v(0.6em),

      stack(
        spacing: 0.45em,
        align(center, text(size: 1.35em)[$A ==> B quad quad A$]),
        line(length: 12em, stroke: 1.2pt + white),
        align(center, text(size: 1.35em)[$B$]),
      ),
    ),

    // Right: λ-Calculus
    stack(
      spacing: 2.2em,
      text(size: 1.5em, weight: "bold")[$lambda$-Calculus],

      text(size: 1.6em)[$A -> B$],

      v(0.6em),

      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.3em,
        )[$Gamma tack M : A -> B quad quad Gamma tack N : A$]),
        line(length: 22em, stroke: 1.2pt + white),
        align(center, text(size: 1.3em)[$Gamma tack M N : B$]),
      ),
    ),
  )

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 10 — NEGATION (10/24)
// ------------------------------------------------------------

#slide(title: [Negation])[
  #v(1.4fr)

  #grid(
    columns: (1fr, 1.2fr),
    gutter: 2.5em,
    align: top + center,

    // Logic
    stack(
      spacing: 2em,
      text(size: 1.5em, weight: "bold")[Logic],
      text(size: 1.6em)[$not A quad equiv quad A ==> bot$],
    ),

    // λ-Calculus
    stack(
      spacing: 2em,
      text(size: 1.5em, weight: "bold")[$lambda$-Calculus],
      none,
    ),
  )

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 11 — NEGATION - ABSURDITY (COMBINED ANIMATION) (11/24)
// ------------------------------------------------------------

#slide(title: [Negation - Absurdity])[
  #v(0.6fr)

  // Top explanation
  #align(center)[
    #stack(
      spacing: 0.9em,
      text(size: 1.3em)[If $bot$ is true, then every proposition is true.],
      text(
        size: 1.3em,
      )[If $bot$ is inhabited, then every proposition is inhabited.],
      v(0.3em),
      text(
        size: 1.25em,
      )[Construct a function mapping every proposition to its inhabitant.],
    )
  ]

  #v(1.5em)

  // Polymorphic inhabitant function
  #align(center)[
    #stack(
      spacing: 0.9em,
      text(size: 1.35em)[$f quad : quad Pi alpha : * . thin alpha$],
      text(
        size: 1.35em,
      )[$f A quad : quad alpha [alpha := A] quad equiv quad A$],
    )
  ]

  #v(1.8em)

  // Bottom correspondence: ex falso quodlibet vs ⊥ encoding
  #grid(
    columns: (1fr, 1.4fr),
    gutter: 2.5em,
    align: top + center,

    // Logic: ex falso quodlibet
    stack(
      spacing: 1.2em,
      text(size: 1.3em, weight: "bold")[Logic],
      stack(
        spacing: 0.4em,
        align(center, text(size: 1.35em)[$bot$]),
        line(length: 6em, stroke: 1.2pt + white),
        align(center, text(size: 1.35em)[$A$]),
      ),
    ),

    // λ-Calculus: ⊥ definition
    stack(
      spacing: 1.2em,
      text(size: 1.3em, weight: "bold")[$lambda$-Calculus],
      grid(
        columns: (auto, auto),
        column-gutter: 1.2em,
        align: horizon,
        text(size: 1.35em)[$bot quad equiv quad Pi alpha : * . thin alpha$],
        text(size: 1.05em, fill: gold)[$arrow.hook.l$ need $lambda 2$ !],
      ),
    ),
  )

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 12 — NEGATION (CONTINUED) (12/24)
// ------------------------------------------------------------

#slide(title: [Negation])[
  #v(1.4fr)

  #grid(
    columns: (1fr, 1.5fr),
    gutter: 2.5em,
    align: top + center,

    // Logic
    stack(
      spacing: 2.2em,
      text(size: 1.5em, weight: "bold")[Logic],
      text(size: 1.55em)[$not A quad equiv quad A ==> bot$],
    ),

    // λ-Calculus
    stack(
      spacing: 2.2em,
      text(size: 1.5em, weight: "bold")[$lambda$-Calculus],
      text(
        size: 1.55em,
      )[$A -> bot quad equiv quad lambda x : A . thin Pi alpha : * . thin alpha$],
    ),
  )

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 13 — CONJUNCTION (COMBINED ANIMATION) (13/24)
// ------------------------------------------------------------

#slide(title: [Conjunction])[
  #v(1fr)

  #grid(
    columns: (1fr, 1.4fr),
    gutter: 2.5em,
    align: top + center,

    // Logic: Classical De Morgan attempts crossed out
    stack(
      spacing: 1.5em,
      text(size: 1.5em, weight: "bold")[Logic],

      text(size: 1.6em)[$A and B$],

      v(0.3em),

      // Struck-through classical equivalences
      strike(stroke: 1.4pt + rgb("#D94848"))[
        #stack(
          spacing: 0.6em,
          text(size: 1.25em)[$equiv not (not A or not B)$],
          text(size: 1.25em)[$equiv not (A ==> not B)$],
        )
      ],
    ),

    // λ-Calculus: Intuitionistic Conjunction Type
    stack(
      spacing: 1.5em,
      text(size: 1.5em, weight: "bold")[$lambda$-Calculus],

      v(1.8em),

      text(size: 1.5em)[$Pi C : * . thin (A -> B -> C) -> C$],
    ),
  )

  #v(1.5fr)
]

// ------------------------------------------------------------
// SLIDE 14 — CONJUNCTION - PROOF (14/24)
// ------------------------------------------------------------

#slide(title: [Conjunction - Proof])[
  #v(0.6fr)

  #align(center)[
    #truth-table(
      headers: (
        [$A$],
        [$B$],
        [$C$],
        [$A and B$],
        [$(A ->$],
        [$(B -> C))$],
        [$-> C$],
      ),

      columns: (
        3em,
        3em,
        3em,
        6.5em,
        4.5em,
        6.5em,
        5em,
      ),

      highlight-cols: (3, 6),

      rows: (
        (1, 1, 1, 1, 1, 1, 1),
        (1, 1, 0, 1, 0, 0, 1),
        (1, 0, 1, 0, 1, 1, 1),
        (1, 0, 0, 0, 1, 1, 0),
        (0, 1, 1, 0, 1, 1, 1),
        (0, 1, 0, 0, 1, 0, 0),
        (0, 0, 1, 0, 1, 1, 1),
        (0, 0, 0, 0, 1, 1, 0),
      ),
    )
  ]

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 15 — CONJUNCTION - INHABITANT (15/24)
// ------------------------------------------------------------

#slide(title: [Conjunction - Inhabitant])[
  #v(1.4fr)

  #align(center)[
    #stack(
      spacing: 2em,

      text(size: 1.6em)[
        $lambda C : * . thin lambda z : (A -> B -> C) . thin z thin a thin b$
      ],

      text(size: 1.8em)[$:$],

      text(size: 1.6em)[
        $Pi C : * . thin (A -> B -> C) -> C$
      ],
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 16 — DISJUNCTION (16/24)
// ------------------------------------------------------------

#slide(title: [Disjunction])[
  #v(1.4fr)

  #grid(
    columns: (1fr, 1.5fr),
    gutter: 2.5em,
    align: top + center,

    // Logic
    stack(
      spacing: 2.2em,
      text(size: 1.5em, weight: "bold")[Logic],
      text(size: 1.6em)[$A or B$],
    ),

    // λ-Calculus
    stack(
      spacing: 2.2em,
      text(size: 1.5em, weight: "bold")[$lambda$-Calculus],
      text(size: 1.5em)[$Pi C : * . thin (A -> C) -> (B -> C) -> C$],
    ),
  )

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 17 — DISJUNCTION - PROOF (17/24)
// ------------------------------------------------------------

#slide(title: [Disjunction - Proof])[
  #v(0.6fr)

  #align(center)[
    #truth-table(
      headers: (
        [$A$],
        [$B$],
        [$C$],
        [$A or B$],
        [$(A -> C)$],
        [$->$],
        [$((B -> C)$],
        [$-> C)$],
      ),

      columns: (
        3em,
        3em,
        3em,
        6.5em,
        5.5em,
        3em,
        6.5em,
        4em,
      ),

      highlight-cols: (3, 7),

      rows: (
        (1, 1, 1, 1, 1, 1, 1, 1),
        (1, 1, 0, 1, 0, 1, 0, 1),
        (1, 0, 1, 1, 1, 1, 1, 1),
        (1, 0, 0, 1, 0, 1, 1, 0),
        (0, 1, 1, 1, 1, 1, 1, 1),
        (0, 1, 0, 1, 1, 1, 0, 1),
        (0, 0, 1, 0, 1, 1, 1, 1),
        (0, 0, 0, 0, 1, 0, 1, 0),
      ),
    )
  ]

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 18 — DISJUNCTION - INHABITANT (18/24)
// ------------------------------------------------------------

#slide(title: [Disjunction - Inhabitant])[
  #v(1.4fr)

  #align(center)[
    #stack(
      spacing: 2em,

      text(size: 1.55em)[
        $lambda C : * . thin lambda x : (A -> C) . thin lambda y : (B -> C) . thin x thin a$
      ],

      text(size: 1.8em)[$:$],

      text(size: 1.55em)[
        $Pi C : * . thin (A -> C) -> (B -> C) -> C$
      ],
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 19 — BIIMPLICATION (19/24)
// ------------------------------------------------------------

#slide(title: [Biimplication])[
  #v(1.5fr)

  #grid(
    columns: (1fr, 1.4fr),
    gutter: 2.5em,
    align: top + center,

    // Logic
    stack(
      spacing: 2.2em,
      text(size: 1.5em, weight: "bold")[Logic],
      text(size: 1.7em)[$A <==> B$],
    ),

    // λ-Calculus
    stack(
      spacing: 2.2em,
      text(size: 1.5em, weight: "bold")[$lambda$-Calculus],
      text(size: 1.6em)[$(A ==> B) and (B ==> A)$],
    ),
  )

  #v(2fr)
]

// ------------------------------------------------------------
// SLIDE 20 — FORALL-QUANTIFICATION (20/24)
// ------------------------------------------------------------

#slide(title: [$forall$-Quantification])[
  #v(1.5fr)

  #grid(
    columns: (1fr, 1.4fr),
    gutter: 2.5em,
    align: top + center,

    // Logic
    stack(
      spacing: 2.2em,
      text(size: 1.5em, weight: "bold")[Logic],
      text(size: 1.7em)[$forall_(x in S) (P(x))$],
    ),

    // λ-Calculus
    stack(
      spacing: 2.2em,
      text(size: 1.5em, weight: "bold")[$lambda$-Calculus],
      text(size: 1.7em)[$Pi x : S . thin P x$],
    ),
  )

  #v(2fr)
]

// ------------------------------------------------------------
// SLIDE 21 — EXISTS-QUANTIFICATION (COMBINED ANIMATION) (21/24)
// ------------------------------------------------------------

#slide(title: [$exists$-Quantification])[
  #v(1.2fr)

  #grid(
    columns: (1fr, 1.6fr),
    gutter: 2.5em,
    align: top + center,

    // Logic: Classical De Morgan attempts crossed out
    stack(
      spacing: 1.5em,
      text(size: 1.5em, weight: "bold")[Logic],

      text(size: 1.6em)[$exists_(x in S) (P(x))$],

      v(0.3em),

      strike(stroke: 1.4pt + rgb("#D94848"))[
        #stack(
          spacing: 0.6em,
          text(size: 1.3em)[$equiv exists_(x in S) (not not P(x))$],
          text(size: 1.3em)[$equiv not forall_(x in S) (not P(x))$],
        )
      ],
    ),

    // λ-Calculus: Second-order existential encoding & logic mapping
    stack(
      spacing: 1.5em,
      text(size: 1.5em, weight: "bold")[$lambda$-Calculus],

      v(0.8em),

      text(size: 1.4em)[
        $Pi alpha : * . thin ((Pi x : S . thin (P x -> alpha)) -> alpha)$
      ],

      v(0.6em),

      text(size: 1.2em, fill: gold)[
        $forall A : (forall_(x in S) (P(x) ==> A) ==> A)$
      ],
    ),
  )

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 22 — WHY YOU SHOULD CARE (22/24)
// ------------------------------------------------------------

#slide(title: [Why You Should Care])[
  #v(1.2fr)

  #grid(
    columns: (1fr, 1fr),
    align: center + horizon,

    // Theorem -> Type
    stack(
      spacing: 1.8em,
      text(size: 2.2em)[theorem],
      text(size: 2.2em)[#rotate(90deg)[$arrow.squiggly$]],
      text(size: 2.2em)[type],
    ),

    // Proof -> Term
    stack(
      spacing: 1.8em,
      text(size: 2.2em)[proof],
      text(size: 2.2em)[#rotate(90deg)[$arrow.squiggly$]],
      text(size: 2.2em)[term],
    ),
  )

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 23 — PROOF ASSISTANTS (23/24)
// ------------------------------------------------------------

#slide(title: [Proof Assistants])[
  #v(0.6fr)

  #block(inset: (left: 2em))[
    #stack(
      spacing: 2em,

      // Coq
      grid(
        columns: (6.5em, 1fr),
        column-gutter: 1.5em,
        align: (left + top, left + top),
        text(size: 1.4em, weight: "bold")[Coq],
        stack(
          spacing: 0.7em,
          text(size: 1.15em)[By T. Coquand, G. Huet and others],
          text(
            size: 1.15em,
          )[Build on calculus of inductive constructions (extension of $lambda C$)],
          text(
            size: 1.15em,
          )[Proof for the Four color theorem (coloring regions of a map)],
          text(
            size: 1.15em,
          )[Used to build CompCert, a formally verified C compiler],
        ),
      ),

      // Isabelle
      grid(
        columns: (6.5em, 1fr),
        column-gutter: 1.5em,
        align: (left + top, left + top),
        text(size: 1.4em, weight: "bold")[Isabelle],
        stack(
          spacing: 0.7em,
          text(size: 1.15em)[By Lawrence Paulson named after G. Huets daughter],
          text(size: 1.15em)[Written in SML and Scala],
          text(size: 1.15em)[Contains lots of features and modules],
          text(
            size: 1.15em,
          )[Formally proved functional correctness of a general purpose system kernel: seL4],
        ),
      ),
    )
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 24 — WHERE TO GO FROM HERE (24/24)
// ------------------------------------------------------------

#slide(title: [Where to Go From Here])[
  #v(1fr)

  #block(inset: (left: 2.5em))[
    #set list(spacing: 1.3em)

    #text(size: 1.25em)[
      - Church-Typing of the $lambda$-calculus

      - Curry-Howard Correspondence

      - Functional programming

      - Dependently-typed programming languages (Idris)

      - Theorem proving (Coq, Agda, Isabelle, ... )

      - Type Theory
    ]
  ]

  #v(1.5fr)
]
