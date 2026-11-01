// ============================================================
// Numbers and Functions in the Untyped Lambda Calculus (1.3.1)
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE
// ------------------------------------------------------------

#slide[
  #v(1fr)

  #text(size: 2.3em, weight: "bold")[
    Numbers and Functions in the Untyped $lambda$-Calculus
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
// SLIDE 2 — NUMBERS IN THE UNTYPED LAMBDA CALCULUS
// ------------------------------------------------------------

#slide(title: [Numbers in the Untyped $lambda$-Calculus])[

  #panel(
    [Definition (Natural Numbers $bb(N)$)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 2em,
      row-gutter: 0.7em,
      align: (left + horizon, left + horizon),

      text(size: 1.1em, weight: "bold")[Zero],
      text(size: 1.1em)[$0 in bb(N).$],

      text(size: 1.1em, weight: "bold")[Successor],
      text(size: 1.1em)[If $n in bb(N)$, then $upright(s u c c)(n) in bb(N)$.],
    ),
  )

  #v(0.8em)

  #panel(
    [Definition (Church Numerals $c_n$)],

    align(center)[
      #block(width: 60%)[
        #grid(
          columns: (0.4fr, 1.6fr),
          row-gutter: 0.6em,
          align: (center + horizon, left + horizon),

          text(size: 1.15em)[0],
          text(size: 1.15em)[$lambda f . lambda x . x$],

          grid.cell(colspan: 2)[#line(length: 100%, stroke: 0.8pt + white)],

          text(size: 1.15em)[1],
          text(size: 1.15em)[$lambda f . lambda x . f x$],

          grid.cell(colspan: 2)[#line(length: 100%, stroke: 0.8pt + white)],

          text(size: 1.15em)[2],
          text(size: 1.15em)[$lambda f . lambda x . f (f(x))$],

          grid.cell(colspan: 2)[#line(length: 100%, stroke: 0.8pt + white)],

          text(size: 1.15em)[$dots$],
          text(size: 1.15em)[#h(3em) $dots$],

          grid.cell(colspan: 2)[#line(length: 100%, stroke: 0.8pt + white)],

          text(size: 1.15em, fill: rgb("#D94848"))[$n$],
          text(size: 1.15em)[
            $lambda f . lambda x . underbrace(f dots.c (f, n - upright("times")) x)$
          ],
        )
      ]
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 3 — ARITHMETIC ON CHURCH NUMERALS
// ------------------------------------------------------------

#slide(title: [Arithmetic on Church Numerals])[
  #v(0.5em)

  #align(center)[
    #stack(
      spacing: 1.1em,
      text(size: 1.35em)[$upright(s u c c) equiv lambda m . lambda f . lambda x . f (m f x)$],
      text(size: 1.35em)[$upright(p r e d) equiv lambda n . lambda f . lambda x . n (lambda g . lambda h . h (g f)) (lambda u . x) (lambda u . u)$],
      text(size: 1.35em)[$upright(a d d) equiv lambda m . lambda n . lambda f . lambda x . m f (n f x)$],
      text(size: 1.35em)[$upright(s u b) equiv lambda m . lambda n . (n upright(p r e d)) m$],
      text(size: 1.35em)[$upright(m u l) equiv lambda m . lambda n . lambda f . lambda x . m (n f) x$],
    )
  ]

  #v(1.8em)

  #align(left)[
    #block(inset: (left: 2em))[
      #stack(
        spacing: 0.6em,
        text(size: 1.1em)[Church numerals only on],
        text(size: 1.1em)[non-negative numbers!],
        v(0.2em),
        grid(
          columns: (auto, 1fr),
          gutter: 0.6em,
          align: (top, top),
          text(size: 1.4em, fill: gold)[⤷],
          stack(
            spacing: 0.4em,
            text(size: 1.25em, style: "italic")[pred 0],
            text(size: 1.25em, style: "italic")[sub 2 5],
          ),
        ),
      )
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 4 — SUCCESSOR
// ------------------------------------------------------------

#slide(title: [Arithmetic on Church Numerals - Successor])[

  #panel(
    none,
    align(center)[
      #text(size: 1.3em)[$upright(s u c c) equiv lambda m . lambda f . lambda x . f (m f x)$]
    ],
  )

  #v(1.2em)

  #align(center)[
    #text(size: 1.35em)[
      $ upright(s u c c) c_m
        &equiv (lambda m . lambda f . lambda x . f (m f x)) (lambda g . lambda y . g^m y) \
        &=_beta lambda f . lambda x . f ((lambda g . lambda y . g^m y) f x) \
        &=_beta lambda f . lambda x . f ((lambda y . f^m y) x) \
        &=_beta lambda f . lambda x . f (f^m x) \
        &equiv lambda f . lambda x . f^(m+1) x \
        &equiv c_(m+1) $
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 5 — ADDITION
// ------------------------------------------------------------

#slide(title: [Arithmetic on Church Numerals - Addition])[

  #panel(
    none,
    align(center)[
      #text(size: 1.3em)[$upright(a d d) equiv lambda m . lambda n . lambda f . lambda x . m f (n f x)$]
    ],
  )

  #v(0.8em)

  #align(center)[
    #text(size: 1.25em)[
      $ upright(a d d) c_m c_n
        &equiv (lambda m . lambda n . lambda f . lambda x . m f (n f x)) c_m c_n \
        &=_beta (lambda n . lambda f . lambda x . c_m f (n f x)) c_n \
        &=_beta lambda f . lambda x . c_m f (c_n f x) \
        &equiv lambda f . lambda x . c_m f ((lambda g . lambda y . g^n y) f x) \
        &=_beta lambda f . lambda x . c_m f ((lambda y . f^n y) x) \
        &=_beta lambda f . lambda x . c_m f (f^n x) \
        &equiv lambda f . lambda x . (lambda h . lambda z . h^m z) f (f^n x) \
        &=_beta lambda f . lambda x . f^m (f^n x) \
        &equiv lambda f . lambda x . f^(m+n) x \
        &equiv c_(m+n) $
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 6 — BOOLEANS AND CONDITIONALS
// ------------------------------------------------------------

#slide(title: [Booleans and Conditionals])[
  #v(0.5em)

  #align(center)[
    #stack(
      spacing: 1.5em,
      text(size: 1.4em, font: "Courier")[if $B$ then $M$ else $N$],
      text(size: 1.5em)[$B M N$],
    )
  ]

  #v(1.5em)

  #grid(
    columns: (1fr, 1fr),
    align: center + top,

    stack(
      spacing: 0.6em,
      text(size: 1.4em)[$T equiv lambda x . lambda y . x$],
      v(-0.3em),
      text(size: 0.9em)[$underbrace(#h(9em), "Takes two arguments and\nreturns the" bold("first") "argument")$],
    ),

    stack(
      spacing: 0.6em,
      text(size: 1.4em)[$F equiv lambda x . lambda y . y$],
      v(-0.3em),
      text(size: 0.9em)[$underbrace(#h(9em), "Takes two arguments and\nreturns the" bold("second") "argument")$],
    ),
  )

  #v(2em)

  #align(center)[
    #stack(
      spacing: 0.9em,
      align(left)[
        #text(size: 1.3em)[
          $bullet$ $T M N equiv (lambda x . lambda y . x) M N arrow.r_beta (lambda y . M) N arrow.r_beta M$
        ]
      ],
      align(left)[
        #text(size: 1.3em)[
          $bullet$ $F M N equiv (lambda x . lambda y . y) M N arrow.r_beta (lambda y . y) N arrow.r_beta N$
        ]
      ],
    )
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 7 — LOGICAL CONNECTIVES
// ------------------------------------------------------------

#slide(title: [Logical Connectives])[
  #v(0.5em)

  #align(center)[
    #stack(
      spacing: 0.6em,
      text(size: 1.3em)[$and equiv lambda x . lambda y . x y upright(F)$],
      text(size: 1.3em)[$or equiv lambda x . lambda y . x upright(T) y$],
      text(size: 1.3em)[$not equiv lambda x . x upright(F) upright(T)$],
    )
  ]

  #v(1.6em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    align: top + left,

    // Left column: AND & NOT
    stack(
      spacing: 1.4em,
      stack(
        spacing: 0.5em,
        text(size: 1.15em, fill: gold)[*Conjunction ($and$)*],
        text(size: 1.15em)[$and upright(F T) equiv (lambda x . lambda y . x y upright(F)) upright(F T) =_beta upright(F T F) =_beta upright(F)$],
        text(size: 1.15em)[$and upright(T T) =_beta upright(T T F) =_beta upright(T)$],
      ),
      stack(
        spacing: 0.5em,
        text(size: 1.15em, fill: gold)[*Negation ($not$)*],
        text(size: 1.15em)[$not upright(T) =_beta upright(T F T) =_beta upright(F)$],
        text(size: 1.15em)[$not upright(F) =_beta upright(F F T) =_beta upright(T)$],
      ),
    ),

    // Right column: OR
    stack(
      spacing: 0.5em,
      text(size: 1.15em, fill: gold)[*Disjunction ($or$)*],
      text(size: 1.15em)[$or upright(F F) =_beta upright(F T F) =_beta upright(F)$],
      text(size: 1.15em)[$or upright(T) dot.c =_beta upright(T)$],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 8 — PREDICATES (isZero)
// ------------------------------------------------------------

#slide(title: [Predicates])[
  #v(0.4em)

  #align(center)[
    #stack(
      spacing: 0.5em,
      text(size: 1.25em)[$upright(i s Z e r o) equiv lambda n . n (lambda x . upright(F)) upright(T)$],
      text(size: 1.1em, fill: grey)[$upright(l e q) equiv lambda m . lambda n . upright(i s Z e r o) (upright(s u b) m n)$],
      text(size: 1.1em, fill: grey)[$upright(e q) equiv lambda m . lambda n . (upright(l e q) m n) and (upright(l e q) n m)$],
    )
  ]

  #v(1em)

  #align(center)[
    #text(size: 1.25em)[
      $ upright(i s Z e r o) c_2
        &equiv (lambda n . n (lambda x . upright(F)) upright(T)) (lambda f . lambda x . f (f x)) \
        &=_beta (lambda f . lambda x . f (f x)) (lambda x . upright(F)) upright(T) \
        &=_beta (lambda x . (lambda y . upright(F)) ((lambda z . upright(F)) x)) upright(T) \
        &=_beta (lambda y . upright(F)) ((lambda z . upright(F)) upright(T)) \
        &=_beta (lambda y . upright(F)) upright(F) \
        &=_beta upright(F) $
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 9 — PREDICATES (leq and eq)
// ------------------------------------------------------------

#slide(title: [Predicates])[
  #v(0.4em)

  #align(center)[
    #stack(
      spacing: 0.5em,
      text(size: 1.1em, fill: grey)[$upright(i s Z e r o) equiv lambda n . n (lambda x . upright(F)) upright(T)$],
      text(size: 1.25em)[$upright(l e q) equiv lambda m . lambda n . upright(i s Z e r o) (upright(s u b) m n)$],
      text(size: 1.25em)[$upright(e q) equiv lambda m . lambda n . (upright(l e q) m n) and (upright(l e q) n m)$],
    )
  ]

  #v(1.8em)

  #align(center)[
    #text(size: 1.35em)[
      $ m > n: &quad upright(s u b) m n equiv.not_beta c_0, &quad upright("thus") quad upright(l e q) m n =_beta upright(F) \
        m = n: &quad upright(s u b) m n =_beta c_0,           &quad upright("thus") quad upright(l e q) m n =_beta upright(T) \
        m < n: &quad upright(s u b) m n =_beta c_0,           &quad upright("thus") quad upright(l e q) m n =_beta upright(T) $
    ]
  ]

  #v(1fr)
]
```

---

### Nushell Script to Apply and Compile

Run this in your terminal:

```nu
let dir = "/home/srghma/projects/lean-melearning-lambda-cube-theo-reto-videos"

# Detect if the file already exists or create it with the standard name
let matching = (glob $"($dir)/04*.typ")
let file_path = if ($matching | is-empty) {
    $"($dir)/04-Numbers and Functions in the Untyped λ-Calculus (1.3.1).typ"
} else {
    $matching | first
}

let content = r#'// ============================================================
// Numbers and Functions in the Untyped Lambda Calculus (1.3.1)
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE
// ------------------------------------------------------------

#slide[
  #v(1fr)

  #text(size: 2.3em, weight: "bold")[
    Numbers and Functions in the Untyped $lambda$-Calculus
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
// SLIDE 2 — NUMBERS IN THE UNTYPED LAMBDA CALCULUS
// ------------------------------------------------------------

#slide(title: [Numbers in the Untyped $lambda$-Calculus])[

  #panel(
    [Definition (Natural Numbers $bb(N)$)],

    grid(
      columns: (auto, 1fr),
      column-gutter: 2em,
      row-gutter: 0.7em,
      align: (left + horizon, left + horizon),

      text(size: 1.1em, weight: "bold")[Zero],
      text(size: 1.1em)[$0 in bb(N).$],

      text(size: 1.1em, weight: "bold")[Successor],
      text(size: 1.1em)[If $n in bb(N)$, then $upright(s u c c)(n) in bb(N)$.],
    ),
  )

  #v(0.8em)

  #panel(
    [Definition (Church Numerals $c_n$)],

    align(center)[
      #block(width: 60%)[
        #grid(
          columns: (0.4fr, 1.6fr),
          row-gutter: 0.6em,
          align: (center + horizon, left + horizon),

          text(size: 1.15em)[0],
          text(size: 1.15em)[$lambda f . lambda x . x$],

          grid.cell(colspan: 2)[#line(length: 100%, stroke: 0.8pt + white)],

          text(size: 1.15em)[1],
          text(size: 1.15em)[$lambda f . lambda x . f x$],

          grid.cell(colspan: 2)[#line(length: 100%, stroke: 0.8pt + white)],

          text(size: 1.15em)[2],
          text(size: 1.15em)[$lambda f . lambda x . f (f(x))$],

          grid.cell(colspan: 2)[#line(length: 100%, stroke: 0.8pt + white)],

          text(size: 1.15em)[$dots$],
          text(size: 1.15em)[#h(3em) $dots$],

          grid.cell(colspan: 2)[#line(length: 100%, stroke: 0.8pt + white)],

          text(size: 1.15em, fill: rgb("#D94848"))[$n$],
          text(size: 1.15em)[
            $lambda f . lambda x . underbrace(f dots.c (f, n - upright("times")) x)$
          ],
        )
      ]
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 3 — ARITHMETIC ON CHURCH NUMERALS
// ------------------------------------------------------------

#slide(title: [Arithmetic on Church Numerals])[
  #v(0.5em)

  #align(center)[
    #stack(
      spacing: 1.1em,
      text(size: 1.35em)[$upright(s u c c) equiv lambda m . lambda f . lambda x . f (m f x)$],
      text(size: 1.35em)[$upright(p r e d) equiv lambda n . lambda f . lambda x . n (lambda g . lambda h . h (g f)) (lambda u . x) (lambda u . u)$],
      text(size: 1.35em)[$upright(a d d) equiv lambda m . lambda n . lambda f . lambda x . m f (n f x)$],
      text(size: 1.35em)[$upright(s u b) equiv lambda m . lambda n . (n upright(p r e d)) m$],
      text(size: 1.35em)[$upright(m u l) equiv lambda m . lambda n . lambda f . lambda x . m (n f) x$],
    )
  ]

  #v(1.8em)

  #align(left)[
    #block(inset: (left: 2em))[
      #stack(
        spacing: 0.6em,
        text(size: 1.1em)[Church numerals only on],
        text(size: 1.1em)[non-negative numbers!],
        v(0.2em),
        grid(
          columns: (auto, 1fr),
          gutter: 0.6em,
          align: (top, top),
          text(size: 1.4em, fill: gold)[⤷],
          stack(
            spacing: 0.4em,
            text(size: 1.25em, style: "italic")[pred 0],
            text(size: 1.25em, style: "italic")[sub 2 5],
          ),
        ),
      )
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 4 — SUCCESSOR
// ------------------------------------------------------------

#slide(title: [Arithmetic on Church Numerals - Successor])[

  #panel(
    none,
    align(center)[
      #text(size: 1.3em)[$upright(s u c c) equiv lambda m . lambda f . lambda x . f (m f x)$]
    ],
  )

  #v(1.2em)

  #align(center)[
    #text(size: 1.35em)[
      $ upright(s u c c) c_m
        &equiv (lambda m . lambda f . lambda x . f (m f x)) (lambda g . lambda y . g^m y) \
        &=_beta lambda f . lambda x . f ((lambda g . lambda y . g^m y) f x) \
        &=_beta lambda f . lambda x . f ((lambda y . f^m y) x) \
        &=_beta lambda f . lambda x . f (f^m x) \
        &equiv lambda f . lambda x . f^(m+1) x \
        &equiv c_(m+1) $
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 5 — ADDITION
// ------------------------------------------------------------

#slide(title: [Arithmetic on Church Numerals - Addition])[

  #panel(
    none,
    align(center)[
      #text(size: 1.3em)[$upright(a d d) equiv lambda m . lambda n . lambda f . lambda x . m f (n f x)$]
    ],
  )

  #v(0.8em)

  #align(center)[
    #text(size: 1.25em)[
      $ upright(a d d) c_m c_n
        &equiv (lambda m . lambda n . lambda f . lambda x . m f (n f x)) c_m c_n \
        &=_beta (lambda n . lambda f . lambda x . c_m f (n f x)) c_n \
        &=_beta lambda f . lambda x . c_m f (c_n f x) \
        &equiv lambda f . lambda x . c_m f ((lambda g . lambda y . g^n y) f x) \
        &=_beta lambda f . lambda x . c_m f ((lambda y . f^n y) x) \
        &=_beta lambda f . lambda x . c_m f (f^n x) \
        &equiv lambda f . lambda x . (lambda h . lambda z . h^m z) f (f^n x) \
        &=_beta lambda f . lambda x . f^m (f^n x) \
        &equiv lambda f . lambda x . f^(m+n) x \
        &equiv c_(m+n) $
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 6 — BOOLEANS AND CONDITIONALS
// ------------------------------------------------------------

#slide(title: [Booleans and Conditionals])[
  #v(0.5em)

  #align(center)[
    #stack(
      spacing: 1.5em,
      text(size: 1.4em, font: "Courier")[if $B$ then $M$ else $N$],
      text(size: 1.5em)[$B M N$],
    )
  ]

  #v(1.5em)

  #grid(
    columns: (1fr, 1fr),
    align: center + top,

    stack(
      spacing: 0.6em,
      text(size: 1.4em)[$T equiv lambda x . lambda y . x$],
      v(-0.3em),
      text(size: 0.9em)[$underbrace(#h(9em), "Takes two arguments and\nreturns the" bold("first") "argument")$],
    ),

    stack(
      spacing: 0.6em,
      text(size: 1.4em)[$F equiv lambda x . lambda y . y$],
      v(-0.3em),
      text(size: 0.9em)[$underbrace(#h(9em), "Takes two arguments and\nreturns the" bold("second") "argument")$],
    ),
  )

  #v(2em)

  #align(center)[
    #stack(
      spacing: 0.9em,
      align(left)[
        #text(size: 1.3em)[
          $bullet$ $T M N equiv (lambda x . lambda y . x) M N arrow.r_beta (lambda y . M) N arrow.r_beta M$
        ]
      ],
      align(left)[
        #text(size: 1.3em)[
          $bullet$ $F M N equiv (lambda x . lambda y . y) M N arrow.r_beta (lambda y . y) N arrow.r_beta N$
        ]
      ],
    )
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 7 — LOGICAL CONNECTIVES
// ------------------------------------------------------------

#slide(title: [Logical Connectives])[
  #v(0.5em)

  #align(center)[
    #stack(
      spacing: 0.6em,
      text(size: 1.3em)[$and equiv lambda x . lambda y . x y upright(F)$],
      text(size: 1.3em)[$or equiv lambda x . lambda y . x upright(T) y$],
      text(size: 1.3em)[$not equiv lambda x . x upright(F) upright(T)$],
    )
  ]

  #v(1.6em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    align: top + left,

    // Left column: AND & NOT
    stack(
      spacing: 1.4em,
      stack(
        spacing: 0.5em,
        text(size: 1.15em, fill: gold)[*Conjunction ($and$)*],
        text(size: 1.15em)[$and upright(F T) equiv (lambda x . lambda y . x y upright(F)) upright(F T) =_beta upright(F T F) =_beta upright(F)$],
        text(size: 1.15em)[$and upright(T T) =_beta upright(T T F) =_beta upright(T)$],
      ),
      stack(
        spacing: 0.5em,
        text(size: 1.15em, fill: gold)[*Negation ($not$)*],
        text(size: 1.15em)[$not upright(T) =_beta upright(T F T) =_beta upright(F)$],
        text(size: 1.15em)[$not upright(F) =_beta upright(F F T) =_beta upright(T)$],
      ),
    ),

    // Right column: OR
    stack(
      spacing: 0.5em,
      text(size: 1.15em, fill: gold)[*Disjunction ($or$)*],
      text(size: 1.15em)[$or upright(F F) =_beta upright(F T F) =_beta upright(F)$],
      text(size: 1.15em)[$or upright(T) dot.c =_beta upright(T)$],
    ),
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 8 — PREDICATES (isZero)
// ------------------------------------------------------------

#slide(title: [Predicates])[
  #v(0.4em)

  #align(center)[
    #stack(
      spacing: 0.5em,
      text(size: 1.25em)[$upright(i s Z e r o) equiv lambda n . n (lambda x . upright(F)) upright(T)$],
      text(size: 1.1em, fill: grey)[$upright(l e q) equiv lambda m . lambda n . upright(i s Z e r o) (upright(s u b) m n)$],
      text(size: 1.1em, fill: grey)[$upright(e q) equiv lambda m . lambda n . (upright(l e q) m n) and (upright(l e q) n m)$],
    )
  ]

  #v(1em)

  #align(center)[
    #text(size: 1.25em)[
      $ upright(i s Z e r o) c_2
        &equiv (lambda n . n (lambda x . upright(F)) upright(T)) (lambda f . lambda x . f (f x)) \
        &=_beta (lambda f . lambda x . f (f x)) (lambda x . upright(F)) upright(T) \
        &=_beta (lambda x . (lambda y . upright(F)) ((lambda z . upright(F)) x)) upright(T) \
        &=_beta (lambda y . upright(F)) ((lambda z . upright(F)) upright(T)) \
        &=_beta (lambda y . upright(F)) upright(F) \
        &=_beta upright(F) $
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 9 — PREDICATES (leq and eq)
// ------------------------------------------------------------

#slide(title: [Predicates])[
  #v(0.4em)

  #align(center)[
    #stack(
      spacing: 0.5em,
      text(size: 1.1em, fill: grey)[$upright(i s Z e r o) equiv lambda n . n (lambda x . upright(F)) upright(T)$],
      text(size: 1.25em)[$upright(l e q) equiv lambda m . lambda n . upright(i s Z e r o) (upright(s u b) m n)$],
      text(size: 1.25em)[$upright(e q) equiv lambda m . lambda n . (upright(l e q) m n) and (upright(l e q) n m)$],
    )
  ]

  #v(1.8em)

  #align(center)[
    #text(size: 1.35em)[
      $ m > n: &quad upright(s u b) m n equiv.not_beta c_0, &quad upright("thus") quad upright(l e q) m n =_beta upright(F) \
        m = n: &quad upright(s u b) m n =_beta c_0,           &quad upright("thus") quad upright(l e q) m n =_beta upright(T) \
        m < n: &quad upright(s u b) m n =_beta c_0,           &quad upright("thus") quad upright(l e q) m n =_beta upright(T) $
    ]
  ]

  #v(1fr)
]
