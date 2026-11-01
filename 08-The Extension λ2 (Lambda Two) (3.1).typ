// ============================================================
// The Extension λ2 (Lambda Two) (3.1)
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
    The Extension $lambda 2$ (Lambda Two)
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
// SLIDE 2 (a) — TYPED IDENTITY FUNCTIONS (2/11)
// ------------------------------------------------------------

#slide(title: [Typed Identity Functions])[
  #v(0.8fr)

  #grid(
    columns: (1fr, 1fr),
    align: (left + horizon, right + horizon),
    text(
      size: 1.25em,
    )[$(lambda x : alpha -> beta . thin x) : (alpha -> beta) -> (alpha -> beta)$],
    text(size: 1.25em)[$(lambda x : gamma . thin x) : gamma -> gamma$],
  )

  #v(1.8fr)

  #align(center)[
    #text(size: 2.1em)[
      $(lambda x : alpha . thin x) : alpha -> alpha$
    ]
  ]

  #v(1.8fr)

  #grid(
    columns: (1fr, 1.3fr),
    align: (left + horizon, right + horizon),
    text(size: 1.25em)[$(lambda x : beta . thin x) : beta -> beta$],
    text(
      size: 1.25em,
    )[$(lambda x : alpha -> alpha . thin x) : (alpha -> alpha) -> (alpha -> alpha)$],
  )

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 2 (b) — TYPED IDENTITY FUNCTIONS: PROBLEM & SOLUTION (2/11)
// ------------------------------------------------------------

#slide(title: [Typed Identity Functions])[
  #let dim(body) = text(fill: rgb("#455c5d"))[#body]

  #v(0.6fr)

  #grid(
    columns: (1fr, 1fr),
    align: (left + horizon, right + horizon),
    dim(text(
      size: 1.2em,
    )[$(lambda x : alpha -> beta . thin x) : (alpha -> beta) -> (alpha -> beta)$]),
    dim(text(size: 1.2em)[$(lambda x : gamma . thin x) : gamma -> gamma$]),
  )

  #v(0.8fr)

  #align(center)[
    #stack(
      spacing: 1.2em,

      text(size: 1.25em)[
        *Problem* #h(0.8em) The identity function is always bound to a specific type.
      ],

      dim(text(size: 2em)[
        $(lambda x : alpha . thin x) : alpha -> alpha$
      ]),

      text(size: 1.25em)[
        *Solution* #h(0.8em) Create an identity function that works on arbitrary types.
      ],
    )
  ]

  #v(0.8fr)

  #grid(
    columns: (1fr, 1.3fr),
    align: (left + horizon, right + horizon),
    dim(text(size: 1.2em)[$(lambda x : beta . thin x) : beta -> beta$]),
    dim(text(
      size: 1.2em,
    )[$(lambda x : alpha -> alpha . thin x) : (alpha -> alpha) -> (alpha -> alpha)$]),
  )

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 3 — POLYMORPHIC IDENTITY FUNCTION (3/11)
// ------------------------------------------------------------

#slide(title: [Polymorphic identity function])[
  #v(1fr)

  #align(center)[
    #stack(
      spacing: 1.8em,

      text(size: 2.4em)[
        $lambda alpha : * . thin lambda x : alpha . thin x$
      ],

      v(0.8em),

      stack(
        spacing: 1.2em,

        text(size: 1.3em)[
          $(lambda alpha : * . thin lambda x : alpha . thin x) thin sigma -->_beta lambda x : sigma . thin x$
        ],

        text(size: 1.3em)[
          $(lambda alpha : * . thin lambda x : alpha . thin x) thin alpha -->_beta lambda x : alpha . thin x$
        ],

        text(size: 1.3em)[
          $(lambda alpha : * . thin lambda x : alpha . thin x) ((alpha -> beta) -> tau) -->_beta lambda x : ((alpha -> beta) -> tau) . thin x$
        ],

        text(size: 1.4em)[$dots.v$],
      ),
    )
  ]

  #v(1.5fr)
]

// ------------------------------------------------------------
// SLIDE 4 — HOW TO TYPE ABSTRACTION OF TYPES - PI-TYPES (4/11)
// ------------------------------------------------------------

#slide(title: [How to Type Abstraction of Types - $Pi$-Types])[
  #v(1.4fr)

  #align(center)[
    #grid(
      columns: (1fr, auto, 1fr),
      row-gutter: 1.8em,
      align: center + horizon,

      text(size: 1.5em)[$lambda alpha : * . thin lambda x : alpha . thin x$],
      text(size: 1.5em)[$:$],
      text(size: 1.5em)[$Pi alpha : * . thin (alpha -> alpha)$],

      text(size: 2.2em)[$equiv$], none, text(size: 2.2em)[$equiv.not$],

      text(size: 1.5em)[$lambda beta : * . thin lambda x : beta . thin x$],
      text(size: 1.5em)[$:$],
      text(size: 1.5em)[$Pi beta : * . thin (beta -> beta)$],
    )
  ]

  #v(2fr)
]

// ------------------------------------------------------------
// SLIDE 5 — THE CALCULUS LAMBDA_2 (5/11)
// ------------------------------------------------------------

#slide(title: [The Calculus $lambda_2$])[

  #panel(
    [Definition (The Set $bb(T)_2$ of $lambda 2$-Types)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 1.4em,
      row-gutter: 0.7em,
      align: (left + horizon, left + horizon),

      text(size: 1.05em, weight: "bold")[(Variable Type)],
      text(size: 1.05em)[If $alpha in V$, then $alpha in bb(T)_2$.],

      text(size: 1.05em, weight: "bold")[(Arrow Type)],
      text(
        size: 1.05em,
      )[If $sigma, tau in bb(T)_2$, then $(sigma -> tau) in bb(T)_2$.],

      text(size: 1.05em, weight: "bold")[($Pi$-type)],
      text(
        size: 1.05em,
      )[If $alpha in V$ and $sigma in bb(T)_2$, then $(Pi alpha : * . thin sigma) in bb(T)_2$.],
    ),
  )

  #v(0.9em)

  #panel(
    [Definition (The Set $Lambda_2$ of Pre-Typed $lambda 2$-Terms)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 1.4em,
      row-gutter: 0.7em,
      align: (left + top, left + top),

      text(size: 1.05em, weight: "bold")[(Variable)],
      text(size: 1.05em)[If $x in V$, then $x in Lambda_2$.],

      text(size: 1.05em, weight: "bold")[(Application)],
      stack(
        spacing: 0.45em,
        text(
          size: 1.05em,
        )[*(a)* If $M, N in Lambda_2$, then $(M thin N) in Lambda_2$.],
        text(
          size: 1.05em,
        )[*(b)* If $M in Lambda_2$ and $sigma in V$, then $(M thin sigma) in Lambda_2$.],
      ),

      text(size: 1.05em, weight: "bold")[(Abstraction)],
      stack(
        spacing: 0.45em,
        text(
          size: 1.05em,
        )[*(a)* If $x in V$, $sigma in bb(T)_2$ and $M in Lambda_2$, then $(lambda x : sigma . thin M) in Lambda_2$.],
        text(
          size: 1.05em,
        )[*(b)* If $sigma in V$ and $M in Lambda_2$, then $(lambda sigma : * . thin M) in Lambda_2$.],
      ),
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 6 — BETA-REDUCTION (6/11)
// ------------------------------------------------------------

#slide(title: [$beta$-Reduction])[

  #panel(
    [Definition ($beta$-Reduction)],

    stack(
      spacing: 0.8em,

      grid(
        columns: (auto, 1fr),
        column-gutter: 1.4em,
        row-gutter: 0.8em,
        align: (left + top, left + top),

        text(size: 1.05em, weight: "bold")[(Basis)],
        stack(
          spacing: 0.5em,
          text(
            size: 1.05em,
          )[*(a)* $(lambda x : sigma . thin M) thin N -->_beta M [x := N]$],
          text(
            size: 1.05em,
          )[*(b)* $(lambda alpha : * . thin M) thin sigma -->_beta M [alpha := sigma]$],
        ),

        text(size: 1.05em, weight: "bold")[(Compatibility)],
        stack(
          spacing: 0.5em,
          text(size: 1.05em)[
            If $M -->_beta N$, then $M thin L -->_beta N thin L$, $L thin M -->_beta L thin N$, $M thin sigma -->_beta N thin sigma$ and
          ],
          text(size: 1.05em)[
            $lambda x : alpha . thin M -->_beta lambda x : alpha . thin N$, $lambda alpha : * . thin M -->_beta lambda alpha : * . thin N$.
          ],
        ),
      ),

      v(0.3em),

      text(size: 1.05em)[
        Many-Step Reduction $-->_beta^*$ and $beta$-conversion $=_beta$ are defined analogously.
      ],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 7 — DERIVATION IN LAMBDA 2 (7/11)
// ------------------------------------------------------------

#slide(title: [Derivation in $lambda 2$])[

  #panel(
    [Definition],

    stack(
      spacing: 0.65em,

      text(size: 1.02em)[
        (1) A _statement_ is of the form $M : sigma$. $M$ is called the _subject_ and $sigma$ the _type_.
      ],

      text(size: 1.02em)[
        (2) *(a)* A _term declaration_ is a statement $x : sigma$. \
        #h(1.8em) *(b)* A _type declaration_ is of the form $sigma : *$.
      ],

      text(size: 1.02em)[
        (3) A _context_ $Gamma$ is a list of declarations with different subjects.
      ],

      text(size: 1.02em)[
        (4) A _judgement_ is of the form $Gamma tack M : sigma$.
      ],

      text(size: 1.02em)[
        (5) A term $M$ is called _legal_ if there exists $Gamma$ and $sigma$ such that $Gamma tack M : sigma$.
      ],
    ),
  )

  #v(0.8em)

  #panel(
    [Definition ($lambda_2$-Context)],

    stack(
      spacing: 0.8em,

      text(size: 1.05em)[
        In a $lambda_2$-context every type variable $sigma$ is declared ($sigma : *$) before it is used ($M : sigma$).
      ],

      v(0.2em),

      align(center)[
        #stack(
          spacing: 0.6em,
          text(
            size: 1.2em,
          )[$Gamma_1 = alpha : *, x : alpha, beta : *, y : alpha -> beta$],
          text(size: 1.2em)[$Gamma_2 = x : alpha, y : alpha -> beta, beta : *$],
        )
      ],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 8 — DERIVATION RULES (8/11)
// ------------------------------------------------------------

#slide(title: [Derivation rules])[
  #v(0.5fr)

  #grid(
    columns: (1fr, 3.4fr),
    gutter: 2em,
    align: horizon,

    align(center)[
      #text(size: 3.4em)[$lambda 2$]
    ],

    rect(
      stroke: 1pt + white,
      inset: (x: 1.4em, y: 1.2em),
      width: 100%,

      stack(
        spacing: 1.1em,

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(var)],
          text(
            size: 1.08em,
          )[$Gamma tack x : sigma quad upright("if") thin Gamma thin upright("is") thin lambda 2 upright("-context and") thin x : sigma in Gamma$],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + top, left + top),
          text(size: 1.05em)[(form)],
          text(size: 1.08em)[
            $Gamma tack B : * quad upright("if") thin Gamma thin upright("is a") thin lambda 2 upright("-context,") thin B in bb(T) 2 thin upright("and")$ \
            #text(
              size: 0.95em,
            )[all free type variables in $B$ are declared in $Gamma$]
          ],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(appl)],
          text(size: 1.1em)[
            $frac(Gamma tack M : sigma -> tau quad Gamma tack N : sigma, Gamma tack M N : tau)$
          ],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(abst)],
          text(size: 1.1em)[
            $(Gamma, x : sigma tack M : tau) / (Gamma tack (lambda x : sigma . thin M) : sigma -> tau)$
          ],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[($upright(a b s t)_2$)],
          text(size: 1.1em)[
            $(Gamma, alpha : * tack M : A) / (Gamma tack (lambda alpha : * . thin M) : (Pi alpha : * . thin A))$
          ],
        ),

        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[($upright(a p p l)_2$)],
          text(size: 1.1em)[
            $frac(Gamma tack M : (Pi alpha : * . thin A) quad Gamma tack B : *, Gamma tack M B : A [alpha := B])$
          ],
        ),
      ),
    ),
  )

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 9 — FORMATION (9/11)
// ------------------------------------------------------------

#slide(title: [Formation])[
  #v(1.4fr)

  #align(center)[
    #stack(
      spacing: 1.6em,

      text(size: 1.4em)[
        $(upright(f o r m)) quad Gamma tack B : *$
      ],

      text(size: 1.15em)[
        if $Gamma$ is a $lambda 2$-context, $B in bb(T) 2$ and all free type variables in $B$ are declared in $Gamma$
      ],

      v(1.2em),

      stack(
        spacing: 1em,
        text(
          size: 1.35em,
        )[$alpha : *, beta : * tack Pi sigma . thin alpha -> sigma -> beta$],
        text(
          size: 1.35em,
        )[$alpha : * tack Pi sigma . thin alpha -> sigma -> beta$],
      ),
    )
  ]

  #v(2fr)
]

// ------------------------------------------------------------
// SLIDE 10 — SECOND ORDER ABSTRACTION (10/11)
// ------------------------------------------------------------

#slide(title: [Second Order Abstraction])[
  #v(1.8fr)

  #align(center)[
    #grid(
      columns: (auto, auto),
      column-gutter: 1.5em,
      align: horizon,

      text(size: 1.4em)[($upright(a b s t)_2$)],

      stack(
        spacing: 0.5em,
        text(size: 1.4em)[$Gamma, alpha : * tack M : A$],
        line(length: 22em, stroke: 1.2pt + white),
        text(
          size: 1.4em,
        )[$Gamma tack (lambda alpha : * . thin M) : (Pi alpha : * . thin A)$],
      ),
    )
  ]

  #v(2.2fr)
]

// ------------------------------------------------------------
// SLIDE 11 — SECOND ORDER APPLICATION (11/11)
// ------------------------------------------------------------

#slide(title: [Second Order Application])[
  #v(1.8fr)

  #align(center)[
    #grid(
      columns: (auto, auto),
      column-gutter: 1.5em,
      align: horizon,

      text(size: 1.4em)[($upright(a p p l)_2$)],

      stack(
        spacing: 0.5em,
        text(
          size: 1.35em,
        )[$Gamma tack M : (Pi alpha : * . thin A) quad quad Gamma tack B : *$],
        line(length: 26em, stroke: 1.2pt + white),
        text(size: 1.35em)[$Gamma tack M B : A [alpha := B]$],
      ),
    )
  ]

  #v(2.2fr)
]
