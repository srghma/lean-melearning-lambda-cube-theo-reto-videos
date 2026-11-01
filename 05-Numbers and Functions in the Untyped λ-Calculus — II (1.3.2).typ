// ============================================================
// Numbers and Functions in the Untyped Lambda Calculus — II (1.3.2)
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE (1/18)
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
// SLIDE 2 — FACTORIAL: RECURSIVE DEFINITION (10/18)
// ------------------------------------------------------------

#slide(title: [Factorial - Recursive Definition])[

  #panel(
    align(center)[#text(font: (
      "Liberation Mono",
      "DejaVu Sans Mono",
    ))[fact(n) := if (n = 0) then 1 else n $dot.c$ fact(n - 1)]],
    align(center)[
      #text(size: 1.15em)[
        $upright(f a c t) equiv lambda n . (upright(i s Z e r o) thin n) thin 1 thin (upright(m u l t) thin n thin (upright(f a c t) #h(0.25em) (upright(p r e d) thin n)))$
      ]
    ],
  )

  #v(0.8em)

  #block(inset: (left: 1.5em))[
    #stack(
      spacing: 0.6em,
      text(
        size: 1.1em,
      )[*Problem* We cannot use $upright(f a c t)$ inside its own definition.],
      text(
        size: 1.1em,
      )[*Solution* Self-application! (as in $Omega equiv (lambda x . x thin x) (lambda x . x thin x)$)],
    )
  ]

  #v(0.8em)

  #panel(
    align(center)[#text(
      size: 1.15em,
    )[$upright(f a c t) equiv upright(f a c t)' thin upright(f a c t)'$]],
    align(center)[
      #text(size: 1.15em)[
        $upright(f a c t)' equiv lambda f . lambda n . (upright(i s Z e r o) thin n) thin 1 thin (upright(m u l t) thin n thin (f thin f thin (upright(p r e d) thin n)))$
      ]
    ],
  )

  #v(0.8em)

  #align(center)[
    #text(size: 1.2em)[
      $
        upright(f a c t)
        &equiv (lambda f . lambda n . (upright(i s Z e r o) thin n) thin 1 thin (upright(m u l t) thin n thin (#text(fill: gold)[$f thin f$] thin (upright(p r e d) thin n)))) #h(0.35em) upright(f a c t)' \
        &=_beta lambda n . (upright(i s Z e r o) thin n) thin 1 thin (upright(m u l t) thin n thin (#text(fill: gold)[$upright(f a c t)' thin upright(f a c t)'$] thin (upright(p r e d) thin n))) \
        &equiv lambda n . (upright(i s Z e r o) thin n) thin 1 thin (upright(m u l t) thin n thin (#text(fill: gold)[$upright(f a c t)$] #h(0.25em) (upright(p r e d) thin n)))
      $
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 3 — FACTORIAL: RECURSIVE CASE (12/18)
// ------------------------------------------------------------

#slide(title: [Factorial - Recursive Definition: Recursive Case])[

  #panel(
    [Recursion ($n > 0$)],

    align(center)[
      #text(size: 1.15em)[
        $
          upright(f a c t) thin c_n
          &equiv upright(f a c t)' thin upright(f a c t)' thin c_n \
          &equiv (lambda f . lambda x . (upright(i s Z e r o) thin x) thin 1 thin (upright(m u l t) thin x thin (#text(fill: gold)[$f thin f$] thin (upright(p r e d) thin x)))) #h(0.35em) upright(f a c t)' thin c_n \
          &=_beta (lambda x . (upright(i s Z e r o) thin x) thin 1 thin (upright(m u l t) thin x thin (#text(fill: gold)[$upright(f a c t)' thin upright(f a c t)'$] thin (upright(p r e d) thin x)))) thin c_n \
          &=_beta (upright(i s Z e r o) thin c_n) thin 1 thin (upright(m u l t) thin c_n thin (#text(fill: gold)[$upright(f a c t)' thin upright(f a c t)'$] thin (upright(p r e d) thin c_n))) \
          &=_beta upright(F) thin 1 thin (upright(m u l t) thin c_n thin (#text(fill: gold)[$upright(f a c t)' thin upright(f a c t)'$] thin (upright(p r e d) thin c_n))) \
          &=_beta upright(m u l t) thin c_n thin (#text(fill: gold)[$upright(f a c t)' thin upright(f a c t)'$] thin (upright(p r e d) thin c_n)) \
          &equiv upright(m u l t) thin c_n thin (#text(fill: gold)[$upright(f a c t)$] #h(0.25em) (upright(p r e d) thin c_n))
        $
      ]
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 4 — FIXED POINT THEOREM (13/18)
// ------------------------------------------------------------

#slide(title: [Fixed Point Theorem])[

  #panel(
    [Definition (Fixed Point - Mathematics)],

    stack(
      spacing: 0.6em,
      text(
        size: 1.05em,
      )[A fixed point of a function $f : A arrow.r B$ is an element $x in A$ such that],
      align(center)[#text(size: 1.15em)[$f(x) = x.$]],
    ),
  )

  #v(0.8em)

  #panel(
    [Theorem (Fixed Point Theorem)],

    text(size: 1.05em)[
      For all $M in Lambda$ there exists $P in Lambda$ such that $M thin P =_beta P.$
    ],
  )

  #v(0.8em)

  #block(inset: (left: 1em))[
    #text(size: 1.1em, style: "italic")[Proof.]
  ]

  #v(0.4em)

  #align(center)[
    #text(size: 1.25em)[
      $
        P &equiv (lambda x . #text(fill: rgb("#D94848"))[$M$] #text(fill: gold)[$(x thin x)$]) (lambda x . #text(fill: rgb("#D94848"))[$M$] #text(fill: gold)[$(x thin x)$]) \
        &=_beta M ((lambda x . M (x thin x)) (lambda x . M (x thin x))) \
        &equiv M thin P
      $
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 5 — FIXED POINT COMBINATOR: DEFINITION (14/18)
// ------------------------------------------------------------

#slide(title: [Fixed Point Combinator])[

  #panel(
    [Definition (Combinator)],

    text(size: 1.05em)[
      A combinator is a term without any free variables.
    ],
  )

  #v(0.8em)

  #panel(
    [Definition (Fixed Point Combinator - Mathematics)],

    text(size: 1.05em)[
      A fixed point combinator is a higher-order function that takes a function as argument and returns the fixed point of that function.
    ],
  )

  #v(0.8em)

  #panel(
    [Definition ($Y$-Combinator)],

    align(center)[
      #text(size: 1.25em)[
        $Y equiv lambda f . (lambda x . f #h(0.2em) (x thin x)) (lambda x . f #h(0.2em) (x thin x))$
      ]
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 6 — FIXED-POINT COMBINATOR: LEMMA (15/18)
// ------------------------------------------------------------

#slide(title: [Fixed-Point Combinator])[

  #panel(
    [Lemma],

    stack(
      spacing: 0.6em,
      text(size: 1.05em)[For all $g in Lambda$],
      align(center)[#text(size: 1.25em)[$Y g =_beta g #h(0.2em) (Y g)$]],
    ),
  )

  #v(0.8em)

  #align(center)[
    #text(size: 1.2em)[
      $
        Y g &equiv (lambda f . (lambda x . #text(fill: gold)[$f$] (x thin x)) (lambda x . #text(fill: gold)[$f$] (x thin x))) #h(0.35em) g \
        &=_beta (lambda x . #text(fill: gold)[$g$] (x thin x)) (lambda x . #text(fill: gold)[$g$] (x thin x)) \
        &=_beta g ((lambda x . g (x thin x)) (lambda x . g (x thin x))) \
        &=_beta g #h(0.2em) (Y g) \
        &dots.c \
        &=_beta g (g #h(0.2em) (Y g)) \
        &dots.c \
        &=_beta g (g (g (dots.c (Y g))))
      $
    ]
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 7 — FACTORIAL: WITH Y-COMBINATOR (16/18)
// ------------------------------------------------------------

#slide(title: [Factorial - Definition With Y-Combinator])[

  #panel(
    [Reminder: Recursive Definition],

    align(center)[
      #stack(
        spacing: 0.6em,
        text(
          size: 1.1em,
        )[$upright(f a c t)'_r equiv lambda f . lambda n . (upright(i s Z e r o) thin n) thin 1 thin (upright(m u l t) thin n thin (f thin f thin (upright(p r e d) thin n)))$],
        text(
          size: 1.1em,
        )[$upright(f a c t)_r equiv upright(f a c t)'_r thin upright(f a c t)'_r$],
      )
    ],
  )

  #v(0.8em)

  #align(center)[
    #stack(
      spacing: 0.6em,

      text(size: 1.15em)[
        $upright(f a c t)'_Y equiv lambda f . lambda n . (upright(i s Z e r o) thin n) thin 1 thin (upright(m u l t) thin n thin (f thin (upright(p r e d) thin n)))$
      ],

      text(size: 1.15em)[
        $
          upright(f a c t)_Y &equiv Y thin upright(f a c t)'_Y \
          &=_beta upright(f a c t)' (Y thin upright(f a c t)'_Y) \
          &equiv (lambda f . lambda n . (upright(i s Z e r o) thin n) thin 1 thin (upright(m u l t) thin n thin (#text(fill: gold)[$f$] thin (upright(p r e d) thin n)))) #h(0.35em) (Y thin upright(f a c t)'_Y) \
          &=_beta lambda n . (upright(i s Z e r o) thin n) thin 1 thin (upright(m u l t) thin n thin (#text(fill: gold)[$(Y thin upright(f a c t)'_Y)$] #h(0.25em) (upright(p r e d) thin n))) \
          &equiv lambda n . (upright(i s Z e r o) thin n) thin 1 thin (upright(m u l t) thin n thin (#text(fill: gold)[$upright(f a c t)_Y$] #h(0.25em) (upright(p r e d) thin n)))
        $
      ],
    )
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 8 — DEFINABILITY (17/18)
// ------------------------------------------------------------

#slide(title: [Definability])[
  #v(1fr)

  #text(size: 1.2em)[
    History and correspondence of different version of computability:
  ]

  #v(1.5em)

  #align(center)[
    #text(size: 1.35em)[
      *"Propositions as Types"* by Philip Wadler
    ]
  ]

  #v(2em)

  #text(size: 1.2em)[
    $lambda$-definability is equivalent to turing-definability.
  ]

  #v(1em)

  #text(size: 1.2em)[
    In particular, the $lambda$-calculus is turing-complete, see Barendregt 1991.
  ]

  #v(1.5fr)
]

// ------------------------------------------------------------
// SLIDE 9 — CONCLUSIONS (18/18)
// ------------------------------------------------------------

#slide(title: [Conclusions])[
  #v(1fr)

  #set list(indent: 2.2em, spacing: 1.3em)

  #text(size: 1.3em)[
    - Lambda Calculus: _variables_, _abstraction_, _application_

    - $beta$-reduction, $alpha$-conversion

    - Normalisation

    - Lambda Calculus $arrow.l.r$ Turing Machine

    - Church Numerals, Arithmetic

    - Self-Application, Fixed-Point Combinator
  ]

  #v(1.5fr)
]
