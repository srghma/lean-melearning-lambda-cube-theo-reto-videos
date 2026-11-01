// ============================================================
// Computing in λ2 (3.2)
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE (1/11)
// ------------------------------------------------------------

#slide[
  #v(1fr)

  #text(size: 2.4em, weight: "bold")[
    Computing in $lambda 2$
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
// SLIDE 2 — COMPUTING IN LAMBDA 2 (2/11)
// ------------------------------------------------------------

#slide(title: [Computing in $lambda 2$])[

  #panel(
    [Definition (Primitive Recursive Functions)],

    stack(
      spacing: 0.7em,

      text(size: 1.05em)[
        The smallest class of functions over $bb(N)$ containing:
      ],

      v(0.2em),

      stack(
        spacing: 0.6em,
        text(size: 1.05em)[1. the constant function 0,],
        text(size: 1.05em)[2. successor,],
        text(size: 1.05em)[3. projection,],
      ),

      v(0.2em),

      text(size: 1.05em)[
        closed under composition and primitive recursion.
      ],
    ),
  )

  #v(1.8em)

  #text(size: 1.15em)[
    The primitive recursive functions are exactly the $lambda 2$-definable terms.
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 3 — POLYMORPHIC CHURCH NUMERALS (3/11)
// ------------------------------------------------------------

#slide(title: [Polymorphic Church Numerals])[
  #v(1.2fr)

  #align(center)[
    #grid(
      columns: (auto, auto, auto, auto),
      column-gutter: 1.8em,
      row-gutter: 1.4em,
      align: (left + horizon, left + horizon, center + horizon, left + horizon),

      text(size: 1.25em, weight: "bold")[simply typed],
      text(
        size: 1.25em,
      )[$lambda f : alpha -> alpha . thin lambda x : alpha . thin f^n x$],
      text(size: 1.25em)[$:$],
      text(size: 1.25em)[$(alpha -> alpha) -> alpha -> alpha$],

      text(size: 1.25em, weight: "bold")[polymorphic],
      text(
        size: 1.25em,
      )[$lambda alpha : * . thin lambda f : alpha -> alpha . thin lambda x : alpha . thin f^n x$],
      text(size: 1.25em)[$:$],
      text(
        size: 1.25em,
      )[$Pi alpha : * . thin (alpha -> alpha) -> alpha -> alpha$],
    )
  ]

  #v(1.8em)

  #panel(
    [Definition (Type of Church Numerals)],

    align(center)[
      #text(size: 1.3em)[
        $C equiv Pi alpha : * . thin (alpha -> alpha) -> alpha -> alpha$
      ]
    ],
  )

  #v(1.5fr)
]

// ------------------------------------------------------------
// SLIDE 4 — PAIRS OF CHURCH NUMERALS (4/11)
// ------------------------------------------------------------

#slide(title: [Pairs of Church Numerals])[

  #panel(
    [Definition (Pair of Church Numerals)],

    align(center)[
      #stack(
        spacing: 0.9em,
        text(size: 1.2em)[
          $⟨ M, N ⟩ equiv lambda z : C -> C -> C . thin z thin M thin N quad : quad (C -> C -> C) -> C$
        ],
        text(size: 1.2em)[
          $upright(p a i r) equiv (C -> C -> C) -> C$
        ],
      )
    ],
  )

  #v(1.8em)

  #align(center)[
    #stack(
      spacing: 1.8em,

      text(size: 1.25em)[
        $upright(f s t) equiv lambda p : upright(p a i r) . thin p thin underbrace((lambda x : C . thin lambda y : C . thin x), : C -> C -> C)$
      ],

      text(size: 1.25em)[
        $upright(s n d) equiv lambda p : upright(p a i r) . thin p thin (lambda x : C . thin lambda y : C . thin y)$
      ],
    )
  ]

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 5 — PAIRS OF CHURCH NUMERALS - FST AND SND (5/11)
// ------------------------------------------------------------

#slide(title: [Pairs of Church Numerals - Fst and Snd])[
  #v(0.6fr)

  #align(center)[
    #stack(
      spacing: 1.6em,

      // fst evaluation
      text(size: 1.15em)[
        $
          upright(f s t) thin ⟨ M, N ⟩
          &equiv (lambda p : upright(p a i r) . thin p thin (lambda x : C . thin lambda y : C . thin x)) thin ⟨ M, N ⟩ \
          &=_beta ⟨ M, N ⟩ (lambda x : C . thin lambda y : C . thin x) \
          &equiv (lambda z : C -> C -> C . thin z thin M thin N) (lambda x : C . thin lambda y : C . thin x) \
          &=_beta (lambda x : C . thin lambda y : C . thin x) M thin N \
          &=_beta M
        $
      ],

      // snd evaluation
      text(size: 1.15em)[
        $
          upright(s n d) thin ⟨ M, N ⟩
          &equiv (lambda p : upright(p a i r) . thin p thin (lambda x : C . thin lambda y : C . thin y)) thin ⟨ M, N ⟩ \
          &=_beta ⟨ M, N ⟩ (lambda x : C . thin lambda y : C . thin y) \
          &equiv (lambda z : C -> C -> C . thin z thin M thin N) (lambda x : C . thin lambda y : C . thin y) \
          &=_beta (lambda x : C . thin lambda y : C . thin y) M thin N \
          &=_beta N
        $
      ],
    )
  ]

  #v(0.8fr)
]

// ------------------------------------------------------------
// SLIDE 6 — FACTORIAL AS A PRIMITIVE RECURSIVE FUNCTION (6/11)
// ------------------------------------------------------------

#slide(title: [Factorial as a Primitive Recursive Function])[

  #block(
    width: 100%,
    fill: rgb("#506061"),
    inset: (x: 0.8em, y: 0.55em),
    align(center)[
      #text(font: ("Liberation Mono", "DejaVu Sans Mono"), size: 1.1em)[
        fact(n) := if (n = 0) then 1 else n $dot.c$ fact(n - 1)
      ]
    ],
  )

  #v(1.2em)

  #align(center)[
    #stack(
      spacing: 1.5em,

      grid(
        columns: (12em, 2em, 16em),
        align: (left + horizon, center + horizon, left + horizon),
        row-gutter: 0.9em,

        text(size: 1.25em)[$upright(f a c t)(0)$],
        text(size: 1.25em)[$=$],
        text(size: 1.25em)[$1$],

        text(size: 1.25em)[$upright(f a c t)(n + 1)$],
        text(size: 1.25em)[$=$],
        text(size: 1.25em)[$upright(m u l t)(n + 1, upright(f a c t)(n))$],
      ),

      grid(
        columns: (12em, 2em, 16em),
        align: (left + horizon, center + horizon, left + horizon),

        text(size: 1.25em)[$upright(n e x t) thin ⟨ n, upright(f a c t)(n) ⟩$],
        text(size: 1.25em)[$equiv$],
        text(size: 1.25em)[$⟨ n + 1, upright(f a c t)(n + 1) ⟩$],
      ),

      grid(
        columns: (12em, 2em, 16em),
        align: (left + horizon, center + horizon, left + horizon),
        row-gutter: 0.9em,

        text(size: 1.25em)[$upright(f a c t) thin c_0$],
        text(size: 1.25em)[$equiv$],
        text(size: 1.25em)[$c_1$],

        text(size: 1.25em)[$upright(f a c t) thin (upright(s u c c) thin c_n)$],
        text(size: 1.25em)[$equiv$],
        text(
          size: 1.25em,
        )[$upright(s n d) thin (upright(n e x t) thin c_n thin (upright(f a c t) thin c_n))$],
      ),
    )
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 7 — FACTORIAL - CONSTRUCTION WITH PAIRS (7/11)
// ------------------------------------------------------------

#slide(title: [Factorial - Construction With Pairs])[
  #v(0.4em)

  #align(center)[
    #text(size: 1.25em)[
      $upright(n e x t) thin ⟨n, upright(f a c t) thin n⟩ --> ⟨n + 1, upright(f a c t) thin n + 1⟩$
    ]
  ]

  #v(0.8em)

  #panel(
    align(center)[
      #text(size: 1.1em)[
        $upright(n e x t) := lambda p : upright(p a i r) . thin ⟨upright(s u c c) thin (upright(f s t) thin p), upright(m u l t) thin (upright(s u c c) thin (upright(f s t) thin p)) thin (upright(s n d) thin p)⟩$
      ]
    ],
    grid(
      columns: (2.3fr, 1.1fr),
      row-gutter: 0.75em,
      align: (left + horizon, left + horizon),

      text(size: 1.12em)[$⟨0, upright(f a c t) thin 0⟩ =_beta ⟨0, 1⟩$],
      text(size: 1.12em)[$equiv upright(n e x t)^0 thin ⟨0, 1⟩$],

      text(
        size: 1.12em,
      )[$⟨1, upright(f a c t) thin 1⟩ =_beta upright(n e x t) thin ⟨0, 1⟩$],
      text(size: 1.12em)[$equiv upright(n e x t)^1 thin ⟨0, 1⟩$],

      text(
        size: 1.12em,
      )[$⟨2, upright(f a c t) thin 2⟩ =_beta upright(n e x t) thin ⟨1, upright(f a c t)(1)⟩ =_beta upright(n e x t) thin (upright(n e x t) thin ⟨0, 1⟩)$],
      text(size: 1.12em)[$equiv upright(n e x t)^2 thin ⟨0, 1⟩$],

      align(center)[#text(size: 1.15em)[$dots$]],
      align(center)[#text(size: 1.15em)[$dots$]],

      text(
        size: 1.12em,
      )[$⟨n, upright(f a c t) thin n⟩ =_beta upright(n e x t)^n thin ⟨0, 1⟩$],
      text(size: 1.12em)[$equiv upright(n e x t)^n thin ⟨0, 1⟩$],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 8 — FACTORIAL - CONSTRUCTING THE INPUT (8/11)
// ------------------------------------------------------------

#slide(title: [Factorial - Constructing the Input])[
  #panel(
    align(center)[
      #text(size: 1.12em)[
        $upright(n e x t) := lambda p : upright(p a i r) . thin ⟨upright(s u c c) thin (upright(f s t) thin p), h thin (upright(f s t) thin p) thin (upright(s n d) thin p)⟩$
      ]
    ],
    align(center)[
      #text(size: 1.15em)[
        $upright(n e x t)^n thin ⟨0, 1⟩ =_beta ⟨n, upright(f a c t)(n)⟩$
      ]
    ],
  )

  #v(1.2em)

  #align(center)[
    #text(size: 1.25em)[
      $lambda alpha : * . thin lambda f : alpha -> alpha . thin lambda x : alpha . thin f^n x quad : quad Pi alpha : * . thin (alpha -> alpha) -> alpha -> alpha$
    ]
  ]

  #v(1.2em)

  #align(center)[
    #stack(
      spacing: 0.7em,
      text(size: 1.2em)[
        $c_n thin upright(p a i r) thin upright(n e x t) thin ⟨0, 1⟩ =_beta upright(n e x t)^n thin ⟨0, 1⟩$
      ],
      text(size: 1.2em)[
        $=_beta ⟨c_n, upright(f a c t) thin c_n⟩$
      ],
    )
  ]

  #v(1em)

  #block(
    width: 100%,
    fill: rgb("#506061"),
    inset: (x: 0.8em, y: 0.55em),
    align(center)[
      #text(size: 1.2em, weight: "bold")[
        $upright(f a c t) equiv lambda n : C . thin upright(s n d) thin (n thin upright(p a i r) thin upright(n e x t) thin ⟨0, 1⟩)$
      ]
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 9 — PRIMITIVE RECURSION IN LAMBDA 2 (9/11)
// ------------------------------------------------------------

#slide(title: [Primitive Recursion in $lambda 2$])[

  #panel(
    [Definition (Primitive Recursive Function)],

    align(center)[
      #stack(
        spacing: 0.7em,
        text(size: 1.25em)[$f(0) = a$],
        text(size: 1.25em)[$f(n + 1) = h(n, f(n))$],
      )
    ],
  )

  #v(1.8em)

  #align(center)[
    #text(size: 1.25em)[
      $upright(n e x t) equiv lambda p : upright(p a i r) . thin ⟨ upright(s u c c) thin (upright(f s t) thin p), h thin (upright(f s t) thin p) thin (upright(s n d) thin p) ⟩$
    ]
  ]

  #v(1.8em)

  #block(
    width: 100%,
    fill: rgb("#506061"),
    inset: (x: 0.8em, y: 0.55em),
    align(center)[
      #text(size: 1.25em, weight: "bold")[
        $bold(f) equiv lambda n : C . thin upright(s n d) thin (n thin upright(p a i r) thin upright(n e x t) thin ⟨ 0, a ⟩)$
      ]
    ],
  )

  #v(1.2fr)
]

// ------------------------------------------------------------
// SLIDE 10 — PRIMITIVE RECURSION IN LAMBDA_-> (10/11)
// ------------------------------------------------------------

#slide(title: [Primitive Recursion in $lambda_arrow$])[
  #v(0.2em)

  #grid(
    columns: (1fr, 1.2fr),
    gutter: 2em,
    align: top + left,

    // Left column: λ→
    stack(
      spacing: 0.9em,
      align(center, text(size: 1.5em)[$lambda_arrow$]),
      text(size: 1.1em)[$c_n quad : quad (alpha -> alpha) -> alpha -> alpha$],
      text(
        size: 1.1em,
      )[$f quad equiv quad n thin upright(n e x t) thin ⟨ 0, a ⟩$],
    ),

    // Right column: λ2
    stack(
      spacing: 0.9em,
      align(center, text(size: 1.5em)[$lambda 2$]),
      text(
        size: 1.1em,
      )[$c_n quad : quad Pi alpha : * . thin (alpha -> alpha) -> alpha -> alpha$],
      text(
        size: 1.1em,
      )[$f quad equiv quad n thin upright(p a i r) thin upright(n e x t) thin ⟨ 0, a ⟩$],
    ),
  )

  #v(1.2em)

  #text(size: 1.05em)[
    *Proof.* #h(0.5em) $upright(n e x t)$ is of type $upright(p a i r) -> upright(p a i r)$. Thus in the $lambda_arrow$ Church Numerals $alpha$ has to be $upright(p a i r)$.
  ]

  #v(0.3em)

  #text(size: 1.05em)[
    But $upright(p a i r)$ is defined as
  ]

  #align(center)[
    #text(size: 1.15em)[$upright(p a i r) equiv (C -> C -> C) -> C$]
  ]

  #text(size: 1.05em)[
    and the type $C$ is defined as
  ]

  #align(center)[
    #text(size: 1.15em)[$C equiv (alpha -> alpha) -> alpha -> alpha.$]
  ]

  #text(size: 1.05em)[
    Therefore
  ]

  #v(0.2em)

  #align(center)[
    #text(size: 0.88em)[
      $alpha = underbrace((underbrace(((alpha -> alpha) -> alpha -> alpha), C) -> underbrace(((alpha -> alpha) -> alpha -> alpha), C) -> underbrace(((alpha -> alpha) -> alpha -> alpha), C)) -> underbrace(((alpha -> alpha) -> alpha -> alpha), C), upright(p a i r)) quad #text(size: 1.5em)[#emoji.lightning]$
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 11 — CONCLUSIONS (11/11)
// ------------------------------------------------------------

#slide(title: [Conclusions])[
  #v(1fr)

  #block(inset: (left: 2em))[
    #set list(spacing: 1.4em)

    #text(size: 1.3em)[
      - Polymorphism e.g. #h(0.5em) $lambda alpha : * . thin lambda x : alpha . thin x quad : quad Pi alpha : * . thin alpha -> alpha$

      - Terms depending on types

      - Primitive recursion

      - Still strongly normalizing

      - Still not Turing complete
    ]
  ]

  #v(1.5fr)
]
