// ============================================================
// The Extension λω (Lambda Weak Omega)
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE (1/21)
// ------------------------------------------------------------

#slide[
  #v(1fr)

  #text(size: 2.3em, weight: "bold")[
    The Extension $lambda underline(omega)$ (Lambda Weak Omega)
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
// SLIDE 2 — THE EXTENSION LAMBDA WEAK OMEGA (2/21)
// ------------------------------------------------------------

#slide(title: [The Extension $lambda underline(omega)$])[
  #v(1.2fr)

  #align(center)[
    #grid(
      columns: (4em, 1.5em, 3em, auto),
      column-gutter: 1.2em,
      row-gutter: 1.8em,
      align: (
        left + horizon,
        center + horizon,
        center + horizon,
        left + horizon,
      ),

      text(size: 1.35em)[$lambda_arrow$],
      text(size: 1.35em)[$:$],
      none,
      text(size: 1.35em)[terms-depending-on-terms],

      text(size: 1.35em)[$lambda 2$],
      text(size: 1.35em)[$:$],
      text(size: 1.35em)[$lambda_arrow$],
      text(size: 1.35em)[$+$ terms-depending-on-types],

      text(size: 1.35em)[$lambda underline(omega)$],
      text(size: 1.35em)[$:$],
      text(size: 1.35em)[$lambda_arrow$],
      text(size: 1.35em)[$+$ types-depending-on-types],
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 3 — DEPENDENCIES IN THE LAMBDA CALCULUS (3/21)
// ------------------------------------------------------------

#slide(title: [Dependencies in the Lambda Calculus])[
  #v(0.4fr)

  #stack(
    spacing: 1.5em,

    // 1. term depending on a term
    stack(
      spacing: 0.5em,
      text(size: 1.15em)[
        $bullet$ #strong[term depending on a term]
        #h(2em)
        $lambda x : alpha . thin x quad : quad alpha -> alpha$
      ],
      grid(
        columns: (auto, auto, auto),
        column-gutter: 2.2em,
        align: horizon,
        text(size: 1.05em)[
          #h(1.8em)
          #text(fill: gold)[$arrow.hook$] $alpha in bb(T)$ \
          #h(3.2em) $alpha -> alpha in bb(T)$
        ],
        text(size: 1.15em)[$(lambda x : alpha . thin x) thin y -->_beta y$],
        text(size: 1.1em)[$, thin y : alpha$],
      ),
    ),

    // 2. term depending on a type
    stack(
      spacing: 0.5em,
      text(size: 1.15em)[
        $bullet$ #strong[term depending on a type]
        #h(2.2em)
        $(lambda alpha : * . thin lambda x : alpha . thin x) thin sigma -->_beta lambda x : sigma . thin x$
      ],
    ),

    // 3. type depending on a type
    stack(
      spacing: 0.5em,
      text(size: 1.15em)[
        $bullet$ #strong[type depending on a type]
        #h(2.2em)
        $(lambda alpha : * . thin alpha -> alpha) thin sigma -->_beta (sigma -> sigma)$
      ],
      grid(
        columns: (auto, auto),
        column-gutter: 3em,
        align: horizon,
        text(size: 1.05em)[
          #h(1.8em)
          #text(fill: gold)[$arrow.hook$] $alpha : *$ \
          #h(3.2em) $alpha -> alpha : *$
        ],
        text(size: 1.15em)[
          $lambda alpha : * . thin alpha -> alpha quad : quad underbrace(* -> *, upright("kind"))$
        ],
      ),
    ),
  )

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 4 — KINDS AND CONSTRUCTORS (COMBINED ANIMATION) (4/21)
// ------------------------------------------------------------

#slide(
  title: [Kinds - the Types of Types - and Constructors - the Terms of Types],
)[
  #v(0.2fr)

  // Top kinds hierarchy examples
  #align(center)[
    #text(size: 1.25em)[
      $underbrace(*, #text(size: 0.8em, fill: gold)[constant])
      quad quad * -> *
      quad quad * -> * -> *
      quad quad (* -> *) -> *
      quad quad (* -> *) -> * -> *$
    ]
  ]

  #v(0.8em)

  // Definition panel combining inductive clauses & BNF grammar
  #panel(
    [Definition (The Set $bb(K)$ of All Kinds)],

    grid(
      columns: (1.3fr, 1fr),
      gutter: 1.5em,
      align: horizon,

      grid(
        columns: (auto, 1fr),
        column-gutter: 1.4em,
        row-gutter: 0.6em,
        align: (left + horizon, left + horizon),

        text(size: 1.05em, weight: "bold")[(Type Kind)],
        text(size: 1.05em)[$* in bb(K)$.],

        text(size: 1.05em, weight: "bold")[(Abstraction Kind)],
        text(size: 1.05em)[$(* -> *) in bb(K)$.],
      ),

      align(center)[
        #text(size: 1.35em)[
          $bb(K) = * | (bb(K) -> bb(K))$
        ]
      ],
    ),
  )

  #v(0.8em)

  // Constructors typing examples
  #align(center)[
    #stack(
      spacing: 0.9em,

      text(size: 1.3em)[
        $alpha quad : quad *$
      ],

      text(size: 1.3em)[
        $underbrace((lambda beta : * . thin beta), #text(size: 0.8em, fill: gold)[proper]) quad : quad * -> *$
      ],
    )
  ]

  #v(0.6fr)
]

// ------------------------------------------------------------
// SLIDE 5 — THE FOUR LEVELS OF A LAMBDA TERM (6/21)
// ------------------------------------------------------------

#slide(title: [The Four Level of a Lambda Term])[
  #v(0.6fr)

  #align(center)[
    #grid(
      columns: (1.3fr, 1.5fr, 1fr, 0.6fr),
      column-gutter: 1.5em,
      row-gutter: 1.8em,
      align: center + horizon,

      // Column Headers
      text(size: 1.4em, weight: "bold")[L1],
      text(size: 1.4em, weight: "bold")[L2],
      text(size: 1.4em, weight: "bold")[L3],
      text(size: 1.4em, weight: "bold")[L4],

      // Row 1: Term -> Type -> Kind -> Sort
      text(
        size: 1.25em,
      )[$underbrace((lambda x : alpha . thin x), upright("term"))$],
      text(size: 1.25em)[$:$ #h(
          0.4em,
        ) $underbrace(alpha -> alpha, upright("type/constructor"))$],
      text(size: 1.25em)[$:$ #h(0.4em) $underbrace(*, upright("kind"))$],
      text(size: 1.25em)[$:$ #h(0.4em) $square$],

      // Row 2: Proper constructor -> Kind -> Sort
      none,
      text(
        size: 1.25em,
      )[$underbrace((lambda beta : * . thin beta -> beta), upright("proper constructor"))$],
      text(size: 1.25em)[$:$ #h(0.4em) $underbrace(* -> *, upright("kind"))$],
      text(size: 1.25em)[$:$ #h(0.4em) $square$],
    )
  ]

  #v(1.5em)

  #panel(
    [Definition (Sorts)],

    align(center)[
      #text(size: 1.35em)[
        $s in {*, square}$
      ]
    ],
  )

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 6 — BETA-REDUCTION ON CONSTRUCTORS (7/21)
// ------------------------------------------------------------

#slide(
  title: [$beta$-Reduction and $beta$-Conversion on Constructors - Example],
)[
  #v(1fr)

  #align(center)[
    #stack(
      spacing: 1.8em,

      // Constructor type assignment
      text(size: 1.25em)[
        $(lambda alpha : * -> * . thin lambda gamma : * . thin alpha thin gamma)
        quad : quad
        (* -> *) -> * -> *$
      ],

      v(0.4em),

      // Reduction sequence
      grid(
        columns: (auto, auto, auto),
        column-gutter: 1.2em,
        row-gutter: 1.3em,
        align: (right + horizon, center + horizon, left + horizon),

        text(
          size: 1.25em,
        )[$(lambda alpha : * -> * . thin lambda gamma : * . thin alpha thin gamma) (lambda tau : * . thin tau) thin sigma$],
        text(size: 1.25em)[$-->_beta$],
        text(
          size: 1.25em,
        )[$(lambda gamma : * . thin (lambda tau : * . thin tau) thin gamma) thin sigma$],

        none,
        text(size: 1.25em)[$-->_beta$],
        text(size: 1.25em)[$(lambda tau : * . thin tau) thin sigma$],

        none, text(size: 1.25em)[$-->_beta$], text(size: 1.25em)[$sigma$],
      ),
    )
  ]

  #v(1.4fr)
]


// ------------------------------------------------------------
// SLIDE 7 — DERIVATION RULES (8/21)
// ------------------------------------------------------------

#slide(title: [Derivation Rules])[
  #v(0.2fr)

  #grid(
    columns: (1fr, 3.8fr),
    gutter: 2em,
    align: horizon,

    align(center)[
      #text(size: 3.4em)[$lambda underline(omega)$]
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
            $frac(Gamma tack A : s quad Gamma tack B : s, Gamma tack A -> B : s)$
          ],
        ),

        // (appl)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(appl)],
          text(size: 1.15em)[
            $frac(Gamma tack M : A -> B quad Gamma tack N : A, Gamma tack M N : B)$
          ],
        ),

        // (abst)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(abst)],
          text(size: 1.15em)[
            $(Gamma, x : A tack M : B quad Gamma tack A -> B : s) / (Gamma tack lambda x : A . thin M : A -> B)$
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
// SLIDE 8 — SORT (9/21)
// ------------------------------------------------------------

#slide(title: [Sort])[
  #v(1.6fr)

  #align(center)[
    #stack(
      spacing: 0.8em,

      grid(
        columns: (auto, auto),
        column-gutter: 1.5em,
        align: horizon,

        text(size: 1.5em)[$(upright(s o r t)) quad emptyset tack * : square$],

        stack(
          spacing: 0.3em,
          text(size: 1.2em, fill: gold)[$arrow.hook.l$ the only axiom!],
        ),
      ),
    )
  ]

  #v(2fr)
]

// ------------------------------------------------------------
// SLIDE 9 — VAR (COMBINED) (10/21)
// ------------------------------------------------------------

#slide(title: [Var])[
  #let dim(body) = text(fill: rgb("#455c5d"))[#body]

  #v(0.3fr)

  // Top background: λ→ and λ2 variable rules dimmed
  #grid(
    columns: (1fr, 1fr),
    align: center,

    stack(
      spacing: 0.5em,
      dim(text(size: 1.2em)[$lambda_arrow$]),
      dim(text(
        size: 1.05em,
      )[$(upright(v a r)) quad Gamma tack x : sigma quad upright("if") thin x : sigma in Gamma$]),
    ),

    stack(
      spacing: 0.5em,
      dim(text(size: 1.2em)[$lambda 2$]),
      dim(text(
        size: 1.05em,
      )[$(upright(v a r)) quad Gamma tack x : sigma quad upright("if") thin Gamma thin upright("is") thin lambda 2 thin upright("context and") thin x : sigma in Gamma$]),
    ),
  )

  #v(1.2em)

  // Center: generalized λω (var) rule
  #align(center)[
    #stack(
      spacing: 0.5em,
      text(size: 1.3em)[$lambda underline(omega)$],
      v(0.2em),
      grid(
        columns: (auto, auto),
        column-gutter: 1.5em,
        align: horizon,
        text(size: 1.2em)[$(upright(v a r))$],
        stack(
          spacing: 0.45em,
          align(center, text(size: 1.25em)[$Gamma tack A : s$]),
          line(length: 15em, stroke: 1.2pt + white),
          align(center, text(size: 1.25em)[$Gamma, x : A tack x : A$]),
        ),

        text(size: 1.15em)[$upright("if") thin x in.not Gamma$],
      ),
    )
  ]

  #v(1.4em)

  // Bottom row: instances for s = * (terms) and s = □ (constructors/kinds)
  #grid(
    columns: (1.1fr, 1.3fr),
    gutter: 1.5em,
    align: horizon,

    // (var)*
    grid(
      columns: (auto, auto, auto),
      column-gutter: 0.8em,
      align: horizon,
      text(size: 1.1em)[$(upright(v a r))^*$],
      stack(
        spacing: 0.4em,
        align(center, text(size: 1.15em)[$Gamma tack sigma : *$]),
        line(length: 12em, stroke: 1.2pt + white),
        align(center, text(size: 1.15em)[$Gamma, x : sigma tack x : sigma$]),
      ),
      text(size: 1.05em)[$upright("if") thin x in.not Gamma$],
    ),

    // (var)□ with handwritten "kind" note
    grid(
      columns: (auto, auto, auto),
      column-gutter: 0.8em,
      align: horizon,
      text(size: 1.1em)[$(upright(v a r))^square$],
      stack(
        spacing: 0.4em,
        align(center)[
          #text(size: 1.15em)[$Gamma tack A : square$]
          #h(0.4em)
          #text(
            size: 0.9em,
            fill: rgb("#D94848"),
            weight: "bold",
          )[#text(size: 1.1em)[$arrow.bl$] kind]
        ],
        line(length: 13em, stroke: 1.2pt + white),
        align(center, text(size: 1.15em)[$Gamma, x : A tack x : A$]),
      ),
      text(size: 1.05em)[$upright("if") thin x in.not Gamma$],
    ),
  )

  #v(0.6fr)
]

// ------------------------------------------------------------
// SLIDE 10 — EXAMPLE - VARIABLE RULE (11/21)
// ------------------------------------------------------------

#slide(title: [Example - Variable Rule])[
  #v(1.2fr)

  #grid(
    columns: (1fr, 1.25fr),
    gutter: 2.5em,
    align: top + center,

    // Left Derivation
    stack(
      spacing: 0.45em,

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 10em, stroke: 1.2pt + white), text(size: 1.05em)[(sort)],
      ),

      text(size: 1.25em)[$emptyset tack * : square$],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 13em, stroke: 1.2pt + white), text(size: 1.05em)[(var)],
      ),

      text(size: 1.25em)[$sigma : * tack sigma : *$],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 16em, stroke: 1.2pt + white), text(size: 1.05em)[(var)],
      ),

      text(size: 1.25em)[$sigma : *, x : sigma tack x : sigma$],
    ),

    // Right Derivation (with premise σ:*, y:σ ⊢ * : □)
    stack(
      spacing: 0.45em,

      text(size: 1.25em)[$sigma : *, y : sigma tack * : square$],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 16em, stroke: 1.2pt + white), text(size: 1.05em)[(var)],
      ),

      text(size: 1.25em)[$sigma : *, y : sigma tack sigma : *$],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 19em, stroke: 1.2pt + white), text(size: 1.05em)[(var)],
      ),

      text(size: 1.25em)[$sigma : *, x : sigma, y : sigma tack x : sigma$],
    ),
  )

  #v(1.6fr)
]

// ------------------------------------------------------------
// SLIDE 11 — WEAK (12/21)
// ------------------------------------------------------------

#slide(title: [Weak])[
  #v(1.6fr)

  #align(center)[
    #grid(
      columns: (auto, auto, auto),
      column-gutter: 1.5em,
      align: horizon,

      text(size: 1.35em)[$(upright(w e a k))$],

      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.35em,
        )[$Gamma tack A : B quad quad Gamma tack C : s$]),
        line(length: 22em, stroke: 1.2pt + white),
        align(center)[
          #text(size: 1.35em)[$Gamma, x : C tack A : B$] \
          #v(0.2em)
          #text(size: 0.9em, fill: gold)[#h(1.2em) $arrow.hook$ type or term]
        ],
      ),

      text(size: 1.25em)[$upright("if") thin x in.not Gamma$],
    )
  ]

  #v(2fr)
]

// ------------------------------------------------------------
// SLIDE 12 — EXAMPLE - VARIABLE RULE CONTINUED (13/21)
// ------------------------------------------------------------

#slide(title: [Example - Variable Rule Continued])[
  #v(0.8fr)

  #grid(
    columns: (1fr, 1.4fr),
    gutter: 2.5em,
    align: top + center,

    // Left Derivation
    stack(
      spacing: 0.45em,

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 10em, stroke: 1.2pt + white), text(size: 1.05em)[(sort)],
      ),

      text(size: 1.2em)[$emptyset tack * : square$],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 13em, stroke: 1.2pt + white), text(size: 1.05em)[(var)],
      ),

      text(size: 1.2em)[$sigma : * tack sigma : *$],

      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 16em, stroke: 1.2pt + white), text(size: 1.05em)[(var)],
      ),

      text(size: 1.2em)[$sigma : *, x : sigma tack x : sigma$],
    ),

    // Right Derivation (completed with (weak))
    stack(
      spacing: 0.45em,

      // Top row: sort on left, derivation of σ:* ⊢ σ:* on right
      grid(
        columns: (1fr, 1.2fr),
        align: bottom + center,

        stack(
          spacing: 0.4em,
          grid(
            columns: (auto, auto),
            column-gutter: 0.5em,
            align: horizon,
            line(length: 8em, stroke: 1.2pt + white),
            text(size: 0.95em)[(sort)],
          ),
          text(size: 1.15em)[$emptyset tack * : square$],
        ),

        stack(
          spacing: 0.4em,
          grid(
            columns: (auto, auto),
            column-gutter: 0.5em,
            align: horizon,
            line(length: 8em, stroke: 1.2pt + white),
            text(size: 0.95em)[(sort)],
          ),
          text(size: 1.15em)[$emptyset tack * : square$],
          grid(
            columns: (auto, auto),
            column-gutter: 0.5em,
            align: horizon,
            line(length: 10em, stroke: 1.2pt + white),
            text(size: 0.95em)[(var)],
          ),
          text(size: 1.15em)[$sigma : * tack sigma : *$],
        ),
      ),

      // (weak) step
      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 25em, stroke: 1.2pt + white), text(size: 1.05em)[(weak)],
      ),

      text(size: 1.2em)[$sigma : *, y : sigma tack * : square$],

      // (var) step 1
      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 18em, stroke: 1.2pt + white), text(size: 1.05em)[(var)],
      ),

      text(size: 1.2em)[$sigma : *, y : sigma tack sigma : *$],

      // (var) step 2
      grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,
        line(length: 21em, stroke: 1.2pt + white), text(size: 1.05em)[(var)],
      ),

      text(size: 1.2em)[$sigma : *, x : sigma, y : sigma tack x : sigma$],
    ),
  )

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 13 — FORM (14/21)
// ------------------------------------------------------------

#slide(title: [Form])[
  #v(1fr)

  // General (form) rule
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
        )[$Gamma tack A : s quad quad Gamma tack B : s$]),
        line(length: 20em, stroke: 1.2pt + white),
        align(center, text(size: 1.3em)[$Gamma tack A -> B : s$]),
      ),
    )
  ]

  #v(2.5em)

  // Two instances: (form)* and (form)□
  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    align: horizon,

    // (form)*
    align(center)[
      #grid(
        columns: (auto, auto),
        column-gutter: 1em,
        align: horizon,

        text(size: 1.15em)[$(upright(f o r m))^*$],

        stack(
          spacing: 0.45em,
          align(center, text(
            size: 1.2em,
          )[$Gamma tack A : * quad quad Gamma tack B : *$]),
          line(length: 18em, stroke: 1.2pt + white),
          align(center, text(size: 1.2em)[$Gamma tack A -> B : *$]),
        ),
      )
    ],

    // (form)□
    align(center)[
      #grid(
        columns: (auto, auto),
        column-gutter: 1em,
        align: horizon,

        text(size: 1.15em)[$(upright(f o r m))^square$],

        stack(
          spacing: 0.45em,
          align(center, text(
            size: 1.2em,
          )[$Gamma tack A : square quad quad Gamma tack B : square$]),
          line(length: 18em, stroke: 1.2pt + white),
          align(center, text(size: 1.2em)[$Gamma tack A -> B : square$]),
        ),
      )
    ],
  )

  #v(1.5fr)
]



// ------------------------------------------------------------
// SLIDE 13 — FORM (COMBINED ANIMATION) (14/21)
// ------------------------------------------------------------

#slide(title: [Form])[
  #v(0.6fr)

  // General (form) rule
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
        )[$Gamma tack A : s quad quad Gamma tack B : s$]),
        line(length: 20em, stroke: 1.2pt + white),
        align(center, text(size: 1.3em)[$Gamma tack A -> B : s$]),
      ),
    )
  ]

  #v(2.2em)

  // Concrete instances: (form)* and (form)□
  #grid(
    columns: (1.1fr, 1.2fr),
    gutter: 2em,
    align: horizon,

    // (form)* with concrete type example
    align(center)[
      #grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,

        text(size: 1.15em)[$(upright(f o r m))^*$],

        stack(
          spacing: 0.45em,
          align(center, text(
            size: 1.15em,
          )[$Gamma tack tau : * quad quad Gamma tack (sigma -> alpha) : *$]),
          line(length: 19em, stroke: 1.2pt + white),
          align(center, text(
            size: 1.15em,
          )[$Gamma tack tau -> (sigma -> alpha) : *$]),
        ),
      )
    ],

    // (form)□ with concrete kind example
    align(center)[
      #grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,

        text(size: 1.15em)[$(upright(f o r m))^square$],

        stack(
          spacing: 0.45em,
          align(center, text(
            size: 1.15em,
          )[$Gamma tack * : square quad quad Gamma tack (* -> *) : square$]),
          line(length: 20em, stroke: 1.2pt + white),
          align(center, text(
            size: 1.15em,
          )[$Gamma tack * -> (* -> *) : square$]),
        ),
      )
    ],
  )

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 14 — APPLICATION & ABSTRACTION (15/21)
// ------------------------------------------------------------

#slide(title: [Application & Abstraction])[
  #v(0.3fr)

  // (appl) rule
  #align(center)[
    #grid(
      columns: (auto, auto),
      column-gutter: 1.5em,
      align: horizon,

      text(size: 1.3em)[$(upright(a p p l))$],

      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.3em,
        )[$Gamma tack M : A -> B quad quad Gamma tack N : A$]),
        line(length: 23em, stroke: 1.2pt + white),
        align(center, text(size: 1.3em)[$Gamma tack M N : B$]),
      ),
    )
  ]

  #v(1.5em)

  // (abst) general rule
  #align(center)[
    #grid(
      columns: (auto, auto),
      column-gutter: 1.5em,
      align: horizon,

      text(size: 1.3em)[$(upright(a b s t))$],

      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.3em,
        )[$Gamma, x : A tack M : B quad quad Gamma tack A -> B : s$]),
        line(length: 26em, stroke: 1.2pt + white),
        align(center, text(
          size: 1.3em,
        )[$Gamma tack lambda x : A . thin M : A -> B$]),
      ),
    )
  ]

  #v(1.8em)

  // (abst)* and (abst)□ instances
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.5em,
    align: horizon,

    // (abst)*
    align(center)[
      #grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,

        text(size: 1.05em)[$(upright(a b s t))^*$],

        stack(
          spacing: 0.45em,
          align(center, text(
            size: 1.1em,
          )[$Gamma, x : A tack M : B quad quad Gamma tack A -> B : *$]),
          line(length: 19em, stroke: 1.2pt + white),
          align(center, text(
            size: 1.1em,
          )[$Gamma tack lambda x : A . thin M : A -> B$]),
        ),
      )
    ],

    // (abst)□
    align(center)[
      #grid(
        columns: (auto, auto),
        column-gutter: 0.8em,
        align: horizon,

        text(size: 1.05em)[$(upright(a b s t))^square$],

        stack(
          spacing: 0.45em,
          align(center, text(
            size: 1.1em,
          )[$Gamma, x : A tack M : B quad quad Gamma tack A -> B : square$]),
          line(length: 19em, stroke: 1.2pt + white),
          align(center, text(
            size: 1.1em,
          )[$Gamma tack lambda x : A . thin M : A -> B$]),
        ),
      )
    ],
  )

  #v(0.6fr)
]

// ------------------------------------------------------------
// SLIDE 15 — TYPE CONVERSION (16/21)
// ------------------------------------------------------------

#slide(title: [Type Conversion])[
  #v(1.2fr)

  #align(center)[
    #stack(
      spacing: 3em,

      text(size: 1.4em)[
        $(lambda alpha : * . thin alpha) thin beta quad -->_beta quad beta$
      ],

      grid(
        columns: (auto, auto),
        column-gutter: 1em,
        align: horizon,

        stack(
          spacing: 0.45em,
          align(center, text(
            size: 1.4em,
          )[$Gamma tack A : (lambda alpha : * . thin alpha) thin beta$]),
          line(length: 18em, stroke: 1.2pt + white),
          align(center, text(size: 1.4em)[$Gamma tack A : beta$]),
        ),

        text(size: 1.3em, fill: gold)[(?)],
      ),
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 16 — CONVERSION RULE (17/21)
// ------------------------------------------------------------

#slide(title: [Conversion Rule])[
  #v(1.8fr)

  #align(center)[
    #grid(
      columns: (auto, auto, auto),
      column-gutter: 1.5em,
      align: horizon,

      text(size: 1.35em)[$(upright(c o n v))$],

      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.35em,
        )[$Gamma tack A : B quad quad Gamma tack B' : s$]),
        line(length: 22em, stroke: 1.2pt + white),
        align(center, text(size: 1.35em)[$Gamma tack A : B'$]),
      ),

      text(size: 1.25em)[$upright("if") thin B =_beta B'$],
    )
  ]

  #v(2.2fr)
]

// ------------------------------------------------------------
// SLIDE 17 — DERIVATION RULES (SUMMARY) (18/21)
// ------------------------------------------------------------

#slide(title: [Derivation Rules])[
  #v(0.2fr)

  #grid(
    columns: (1fr, 3.8fr),
    gutter: 2em,
    align: horizon,

    align(center)[
      #text(size: 3.4em)[$lambda underline(omega)$]
    ],

    rect(
      stroke: 1pt + white,
      inset: (x: 1.4em, y: 1.1em),
      width: 100%,

      stack(
        spacing: 1.1em,

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(sort)],
          text(size: 1.15em)[$emptyset tack * : square$],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(var)],
          text(size: 1.15em)[
            $(Gamma tack A : s) / (Gamma, x : A tack x : A) quad upright("if") thin x in.not Gamma$
          ],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(weak)],
          text(size: 1.15em)[
            $(Gamma tack A : B quad Gamma tack C : s) / (Gamma, x : C tack A : B) quad upright("if") thin x in.not Gamma$
          ],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(form)],
          text(size: 1.15em)[
            $frac(Gamma tack A : s quad Gamma tack B : s, Gamma tack A -> B : s)$
          ],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(appl)],
          text(size: 1.15em)[
            $frac(Gamma tack M : A -> B quad Gamma tack N : A, Gamma tack M N : B)$
          ],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(abst)],
          text(size: 1.15em)[
            $(Gamma, x : A tack M : B quad Gamma tack A -> B : s) / (Gamma tack lambda x : A . thin M : A -> B)$
          ],
        ),

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
// SLIDE 18 — A PRACTICAL EXAMPLE (19/21)
// ------------------------------------------------------------

#slide(title: [A Practical Example])[
  #v(0.8fr)

  #align(center)[
    #block(width: 90%)[
      // Column Header Labels with handwritten mapping
      #grid(
        columns: (1fr, 1fr),
        align: (left + horizon, left + horizon),

        stack(
          spacing: 0.3em,
          grid(
            columns: (auto, auto),
            column-gutter: 1.5em,
            align: horizon,
            text(size: 1.35em, weight: "bold")[Lambda calculus],
            text(
              size: 1.35em,
              fill: gold,
            )[$lambda 2 + lambda underline(omega) = lambda omega$],
          ),
        ),

        text(size: 1.35em, weight: "bold")[Haskell],
      )

      #v(0.6em)
      #line(length: 100%, stroke: 1.2pt + white)
      #v(0.8em)

      // Parallel Rows
      #grid(
        columns: (1fr, 1fr),
        row-gutter: 1.5em,
        align: (left + horizon, left + horizon),

        // 1. Base Type
        text(size: 1.25em)[$upright(i n t) : *$],
        text(size: 1.2em, font: (
          "Liberation Mono",
          "DejaVu Sans Mono",
        ))[Int :: \*],

        // 2. Type Constructor
        stack(
          spacing: 0.3em,
          text(size: 1.25em)[$upright(L i s t) : * -> *$],
          text(
            size: 0.9em,
            fill: gold,
          )[#h(2em) $arrow.hook$ from $lambda underline(omega)$ (type constructor)],
        ),
        text(size: 1.2em, font: (
          "Liberation Mono",
          "DejaVu Sans Mono",
        ))[List :: \* -> \*],

        // 3. Applied Type
        text(size: 1.25em)[$upright(L i s t) thin upright(i n t) : *$],
        text(size: 1.2em, font: (
          "Liberation Mono",
          "DejaVu Sans Mono",
        ))[List Int :: \*],

        // 4. Polymorphic Function
        stack(
          spacing: 0.3em,
          text(
            size: 1.25em,
          )[$upright(l e n g t h) : Pi alpha : * . thin upright(L i s t) thin alpha -> upright(i n t)$],
          text(
            size: 0.9em,
            fill: gold,
          )[#h(2em) $arrow.hook$ from $lambda 2$ (polymorphism)],
        ),
        text(size: 1.2em, font: (
          "Liberation Mono",
          "DejaVu Sans Mono",
        ))[length List a -> Int],
      )
    ]
  ]

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 19 — THE HIGHER-ORDER POLYMORPHIC LAMBDA CALCULUS (20/21)
// ------------------------------------------------------------

#slide(title: [The Higher-Order Polymorphic Lambda Calculus $lambda omega$])[
  #v(0.8fr)

  // Main equivalence equation
  #align(center)[
    #text(size: 1.8em)[
      $lambda omega quad = quad lambda underline(omega) + lambda 2 quad = quad F_omega$
    ]
  ]

  #v(2em)

  // Polymorphic hierarchy
  #block(inset: (left: 3.5em))[
    #stack(
      spacing: 1.2em,

      text(size: 1.3em, weight: "bold")[Polymorphic $lambda$-calculi:],

      v(0.2em),

      grid(
        columns: (2.5em, auto),
        column-gutter: 1.5em,
        row-gutter: 0.9em,
        align: (left + horizon, left + horizon),

        text(size: 1.25em)[$F_omega$],
        text(
          size: 1.25em,
        )[$*, quad * -> *, quad (* -> *) -> *, quad ((* -> *) -> *) -> *, quad dots.c$],

        none, text(size: 1.3em)[$dots.v$],

        text(size: 1.25em)[$F_3$],
        text(size: 1.25em)[$*, quad * -> *, quad (* -> *) -> *$],

        text(size: 1.25em)[$F_2$], text(size: 1.25em)[$*, quad * -> *$],

        text(size: 1.25em)[$F_1$],
        text(size: 1.25em)[
          $*$ #h(2em) #text(fill: gold)[$arrow.hook.l quad lambda 2$]
        ],
      ),
    )
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 20 — CONCLUSIONS (21/21)
// ------------------------------------------------------------

#slide(title: [Conclusions])[
  #v(1fr)

  #block(inset: (left: 2em))[
    #set list(spacing: 1.4em)

    #text(size: 1.3em)[
      - Types-depending-on-types

      - kinds $*$, $* -> *$, etc.

      - $square$

      - 4 Levels #h(1em) $(lambda x : alpha . thin x) : (alpha -> alpha) : * : square$

      - $lambda underline(omega)$ has same computational power as $lambda_arrow$

      - $lambda omega = lambda 2 + lambda underline(omega)$ is more powerful than $lambda 2$
    ]
  ]

  #v(1.5fr)
]
