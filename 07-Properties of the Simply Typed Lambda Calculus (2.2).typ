// ============================================================
// Properties of the Simply Typed Lambda Calculus (2.2)
// Technische Universität Berlin — 2021
// ============================================================

#import "common.typ": *
#show: setup

// ------------------------------------------------------------
// SLIDE 1 — TITLE (1/10)
// ------------------------------------------------------------

#slide[
  #v(1fr)

  #text(size: 2.3em, weight: "bold")[
    Properties of the Simply Typed Lambda Calculus $lambda_arrow$
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
// SLIDE 2 (a) — PROBLEMS IN TYPE THEORY: TYPE CHECKING (2/10)
// ------------------------------------------------------------

#slide(title: [Problems in Type Theory])[
  #v(1.2fr)

  #align(center)[
    #stack(
      spacing: 1.1em,

      text(size: 1.5em, weight: "bold")[?],

      text(size: 1.4em)[
        Type Checking $quad Gamma tack M : sigma$
      ],

      v(1.4em),

      stack(
        spacing: 0.45em,

        text(size: 1.3em)[
          $Gamma, x : alpha tack M : sigma$
        ],

        grid(
          columns: (auto, auto),
          column-gutter: 0.8em,
          align: horizon,
          line(length: 22em, stroke: 1.2pt + white),
          text(size: 1.1em, style: "italic")[(abst)],
        ),

        text(size: 1.3em)[
          $Gamma tack (lambda x : alpha . thin M) : alpha -> sigma$
        ],
      ),
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 2 (b) — PROBLEMS IN TYPE THEORY: OVERVIEW (2/10)
// ------------------------------------------------------------

#slide(title: [Problems in Type Theory])[
  #v(1.2fr)

  #align(center)[
    #stack(
      spacing: 1.2em,

      text(size: 1.5em, weight: "bold")[?],

      v(0.4em),

      grid(
        columns: (auto, auto),
        column-gutter: 1.5em,
        row-gutter: 1.2em,
        align: (right + horizon, left + horizon),

        text(size: 1.35em)[Type Checking],
        text(size: 1.35em)[$Gamma tack M : sigma$],

        text(size: 1.35em)[Well-typedness], text(size: 1.35em)[$? tack M : ?$],

        text(size: 1.35em)[Type Assignment],
        text(size: 1.35em)[$Gamma tack M : ?$],

        text(size: 1.35em)[Inhabitation],
        text(size: 1.35em)[$Gamma tack ? : sigma$],
      ),
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 3 — FREE VARIABLES LEMMA (3/10)
// ------------------------------------------------------------

#slide(title: [Free Variables Lemma])[

  #panel(
    [Definition (Domain)],

    text(size: 1.05em)[
      The _domain_ of a context $Gamma = x_1 : sigma_1, dots, x_n : sigma_n$ is $upright(d o m)(Gamma) = {x_1, dots, x_n}$.
    ],
  )

  #v(1.1em)

  #panel(
    [Free Variables Lemma],

    text(size: 1.05em)[
      If $Gamma tack M : sigma$, then $upright(F V)(M) subset.eq upright(d o m)(Gamma)$
    ],
  )

  #v(1.8fr)

  #align(center)[
    #stack(
      spacing: 1.2em,

      text(size: 1.35em)[
        #strike(stroke: 1.2pt + white)[
          $emptyset tack (lambda x : alpha . thin y x) : alpha -> sigma$
        ]
      ],

      text(size: 1.35em)[
        $y : alpha -> sigma tack (lambda x : alpha . thin y x) : alpha -> sigma$
      ],
    )
  ]

  #v(2.2fr)
]

// ------------------------------------------------------------
// SLIDE 4 — LEMMATA (4/10)
// ------------------------------------------------------------

#slide(title: [Lemmata])[

  #panel(
    [Thinning Lemma],

    text(size: 1.05em)[
      If $Gamma tack M : sigma$ and $Gamma subset.eq Gamma'$, then $Gamma' tack M : sigma$.
    ],
  )

  #v(1em)

  #panel(
    [Subexpression Lemma],

    text(size: 1.05em)[
      If $M$ is a legal term, then every subterm of $M$ is legal as well.
    ],
  )

  #v(1em)

  #panel(
    [Uniqueness of Types Lemma],

    text(size: 1.05em)[
      If $Gamma tack M : sigma$ and $Gamma tack M : tau$, then $sigma equiv tau$.
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 5 — BETA-REDUCTION, SUBJECT REDUCTION & CR (5/10)
// ------------------------------------------------------------

#slide(
  title: [$beta$-Reduction, Subject Reduction and the Church-Rosser Theorem],
)[

  #panel(
    [Definition ($beta$-Reduction)],

    stack(
      spacing: 0.7em,

      grid(
        columns: (auto, 1fr),
        column-gutter: 1.5em,
        row-gutter: 0.7em,
        align: (left + top, left + top),

        text(size: 1.05em, weight: "bold")[Basis],
        text(
          size: 1.05em,
        )[$(lambda x : alpha . thin M) thin N -->_beta M [x := N]$,],

        text(size: 1.05em, weight: "bold")[Compatibility],
        text(size: 1.05em)[
          If $M -->_beta N$, then $M thin L -->_beta N thin L$,
          $L thin M -->_beta L thin N$ and
          $lambda x : alpha . thin M -->_beta lambda x : alpha . thin N$.
        ],
      ),

      v(0.1em),

      text(size: 1.05em)[
        Many-Step Reduction $-->_beta^*$ and $beta$-conversion $=_beta$ are defined analogously.
      ],
    ),
  )

  #v(0.8em)

  #panel(
    [Subject Reduction Lemma],

    text(size: 1.05em)[
      If $Gamma tack M_1 : sigma$ and $M_1 -->_beta^* M_2$, then $Gamma tack M_2 : sigma$.
    ],
  )

  #v(0.8em)

  #panel(
    [Church-Rosser Theorem],

    text(size: 1.05em)[
      Let $M, N_1, N_2 in Lambda^arrow$ be simply typed $lambda$-terms with
      $M -->_beta^* N_1$ and $M -->_beta^* N_2$. Then there is a simply typed
      $lambda$-term $N_3 in Lambda^arrow$ such that $N_1 -->_beta^* N_3$ and $N_2 -->_beta^* N_3$.
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 6 — NORMALIZATION (6/10)
// ------------------------------------------------------------

#slide(title: [Normalization in the Simply Typed Lambda Calculus])[

  #panel(
    [Definition (Weak Normalization, Strong Normalization)],

    stack(
      spacing: 0.8em,

      text(size: 1.05em)[
        (1) $M$ is weakly normalizing if there is an $N in Lambda$ in $beta$-normal form such that $M -->_beta^* N$.
      ],

      text(size: 1.05em)[
        (2) $M$ is strongly normalizing if every chain of reductions starting from $M$ reaches the $beta$-normal form.
      ],
    ),
  )

  #v(1.2em)

  #panel(
    [Strong Normalization Theorem],

    text(size: 1.05em)[
      Every legal term in $lambda_arrow$ is strongly normalizing.
    ],
  )

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 7 — SELF-APPLICATION (7/10)
// ------------------------------------------------------------

#slide(title: [Self-Application in the Simply Typed Lambda Calculus])[

  #panel(
    [Self-Application],

    text(size: 1.05em)[
      Self-application is not typeable in $lambda_arrow$.
    ],
  )

  #v(1em)

  #block(inset: (left: 0.5em))[
    #stack(
      spacing: 1.1em,

      text(size: 1.1em, weight: "bold")[Proof.],

      text(size: 1.05em)[
        Assume $Gamma tack M M : sigma$ and consider the following derivation.
      ],

      align(center)[
        #stack(
          spacing: 0.45em,

          text(size: 1.25em)[
            $Gamma tack M : tau -> sigma quad quad Gamma tack M : tau$
          ],

          grid(
            columns: (auto, auto),
            column-gutter: 0.8em,
            align: horizon,
            line(length: 22em, stroke: 1.2pt + white),
            text(size: 1.1em, style: "italic")[(appl)],
          ),

          text(size: 1.25em)[
            $Gamma tack (M M) : sigma$
          ],
        )
      ],

      text(size: 1.05em)[
        So $M$ is required to have the type $tau$ and $tau -> sigma$.
      ],

      grid(
        columns: (1fr, auto),
        align: horizon,
        text(size: 1.05em)[
          By the Uniqueness of Types Lemma, this yields a contradiction.
        ],
        rect(width: 0.8em, height: 0.8em, stroke: 1.2pt + white, fill: none),
      ),
    )
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 8 — COMPUTING IN LAMBDA_-> (8/10)
// ------------------------------------------------------------

#slide(title: [Computing in $lambda_arrow$])[

  #panel(
    [Definition (Extended Polynomials)],

    stack(
      spacing: 0.7em,

      text(size: 1.05em)[
        The smallest class of functions over $bb(N)$ containing:
      ],

      v(0.2em),

      stack(
        spacing: 0.6em,
        text(size: 1.05em)[1. the constant functions: 0 and 1,],
        text(size: 1.05em)[2. projection,],
        text(size: 1.05em)[3. addition,],
        text(size: 1.05em)[4. multiplication,],
        text(size: 1.05em)[
          5. $upright(i f z e r o)(n, m, p) = upright("if") thin n = 0 thin upright("then") thin m thin upright("else") thin p$,
        ],
      ),

      v(0.2em),

      text(size: 1.05em)[
        closed under composition.
      ],
    ),
  )

  #v(1.5em)

  #text(size: 1.15em)[
    The extended polynomials are exactly the simply typed lambda terms.
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 9 — CHURCH NUMERALS (9/10)
// ------------------------------------------------------------

#slide(title: [Computing in $lambda_arrow$ with Church Numerals])[

  #panel(
    [Definition (Extended Polynomials in $lambda_arrow$)],

    stack(
      spacing: 0.65em,

      text(size: 1.05em)[
        The smallest class of terms over $c_n := lambda f : alpha -> alpha . thin lambda x : alpha . thin f^n x$ containing:
      ],

      v(0.15em),

      stack(
        spacing: 0.55em,
        text(size: 1.02em)[1. the constant terms $c_0$ and $c_1$,],
        text(size: 1.02em)[
          2. $upright(p r o j)_i := lambda x_1 : sigma . dots.c lambda x_n : sigma . thin x_i$,
        ],
        text(size: 1.02em)[
          3. $upright(a d d) := lambda m : sigma . thin lambda n : sigma . thin lambda f : alpha -> alpha . thin lambda x : alpha . thin m thin f (n thin f thin x)$,
        ],
        text(size: 1.02em)[
          4. $upright(m u l) := lambda m : sigma . thin lambda n : sigma . thin lambda f : alpha -> alpha . thin lambda x : alpha . thin m (n thin f) x$,
        ],
        text(size: 1.02em)[
          5. $upright(i f z e r o) := lambda n : sigma . thin lambda m : sigma . thin lambda p : sigma . thin lambda f : alpha -> alpha . thin lambda x : alpha -> alpha . thin n (lambda y : tau . thin p thin f thin x) (m thin f thin x)$,
        ],
      ),

      v(0.15em),

      text(size: 1.05em)[
        closed under composition, with $sigma equiv (alpha -> alpha) -> alpha -> alpha$ being the type of church numerals.
      ],
    ),
  )

  #v(1.4em)

  #text(size: 1.15em)[
    The extended polynomials are exactly the simply typed lambda terms.
  ]

  #v(1fr)
]

// ------------------------------------------------------------
// SLIDE 10 — CONCLUSIONS (10/10)
// ------------------------------------------------------------

#slide(title: [Conclusions])[
  #v(1fr)

  #block(inset: (left: 1.5em))[
    #stack(
      spacing: 1.6em,

      stack(
        spacing: 0.7em,
        text(size: 1.25em)[$bullet$ All terms are strongly normalizing],
        text(size: 1.2em)[#h(1.2em) $->$ All computations terminate],
        text(size: 1.2em)[#h(1.2em) $->$ $lambda_arrow$ is not Turing complete],
      ),

      stack(
        spacing: 0.7em,
        text(size: 1.25em)[$bullet$ No self-application],
        text(size: 1.2em)[#h(1.2em) $->$ No recursion],
        text(
          size: 1.2em,
        )[#h(1.2em) $->$ Can't define factorial function in $lambda_arrow$],
        text(
          size: 1.2em,
        )[#h(1.2em) $->$ Can't define all total functions in $lambda_arrow$],
      ),
    )
  ]

  #v(1.5fr)
]
