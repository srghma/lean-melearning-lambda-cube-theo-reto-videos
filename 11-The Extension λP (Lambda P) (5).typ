// ============================================================
// The Extension λP (Lambda P) (5)
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
    The Extension $lambda upright(P)$ (Lambda P)
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
// SLIDE 2 — THE MISSING PIECE (2/11)
// ------------------------------------------------------------

#slide(title: [The Missing Piece])[
  #v(1.4fr)

  #align(center)[
    #table(
      columns: (6.5em, 6.5em, 10em),
      stroke: (x, y) => (
        bottom: if y == 0 { 1.2pt + white } else { none },
        right: if x == 1 { 1.2pt + white } else { none },
      ),
      align: center + horizon,
      inset: (x: 0.9em, y: 0.8em),

      // Header Row
      [#text(size: 1.25em, weight: "bold")[Terms]],
      [#text(size: 1.25em, weight: "bold")[Types]],
      [#text(size: 1.25em, weight: "bold")[depending on]],

      // Data Rows
      [#text(size: 1.35em)[$lambda_arrow$]],
      [#text(size: 1.35em)[$lambda upright(P)$]],
      [#text(size: 1.25em)[Terms]],

      [#text(size: 1.35em)[$lambda 2$]],
      [#text(size: 1.35em)[$lambda underline(omega)$]],
      [#text(size: 1.25em)[Types]],
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 3 — TYPES DEPENDING ON TERMS (3/11)
// ------------------------------------------------------------

#slide(title: [Types Depending on Terms])[
  #v(1.2fr)

  #align(center)[
    #stack(
      spacing: 3.5em,

      // Bn with handwritten annotations
      grid(
        columns: (auto, auto),
        column-gutter: 1.2em,
        align: horizon,

        text(size: 3em)[$B_n$],

        stack(
          spacing: 1.2em,
          text(size: 1.15em, fill: gold)[$arrow.hook.l$ all multiples of $n$],
          text(size: 1.15em, fill: gold)[#h(1.2em) $arrow.hook.l c_n dots$],
        ),
      ),

      // x : A -> Bx
      text(size: 2.2em)[
        $x : A quad --> quad B_x$
      ],
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 4 — PI-TYPES (AGAIN) (4/11)
// ------------------------------------------------------------

#slide(title: [$Pi$-Types (Again)])[
  #v(1.2fr)

  #align(center)[
    #stack(
      spacing: 1.6em,

      text(size: 2.1em)[
        $Pi x : A . thin B$
      ],

      text(size: 2.3em)[
        $equiv$
      ],

      text(size: 2.1em)[
        $A -> B$
      ],

      v(1.4em),

      text(size: 1.25em)[
        if $x$ does not occur free in $B$
      ],
    )
  ]

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 5 — A PRACTICAL EXAMPLE (5/11)
// ------------------------------------------------------------

#slide(title: [A Practical Example])[
  #v(1fr)

  #block(inset: (left: 3em))[
    #stack(
      spacing: 1.7em,

      text(size: 1.35em)[$upright(L i s t) : bb(N) -> *$],

      text(size: 1.35em)[$upright(L i s t) thin 1 : *$],

      text(size: 1.35em)[$upright(L i s t) thin 35 : *$],

      text(size: 1.35em)[
        $upright(a p p e n d) : Pi m : bb(N) . thin Pi x : upright(L i s t) thin m . thin Pi n : bb(N) . thin Pi y : upright(L i s t) thin n . thin upright(L i s t) thin m + n$
      ],
    )
  ]

  #v(1.5fr)
]

// ------------------------------------------------------------
// SLIDE 6 — DERIVATION RULES (COMPARISON PREVIEW) (6/11)
// ------------------------------------------------------------

#slide(title: [Derivation Rules])[
  #let dim(body) = text(fill: rgb("#455c5d"))[#body]
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

        // (sort) - dimmed
        dim(grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(sort)],
          text(size: 1.15em)[$emptyset tack * : square$],
        )),

        // (var) - dimmed
        dim(grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(var)],
          text(size: 1.15em)[
            $(Gamma tack A : s) / (Gamma, x : A tack x : A) quad upright("if") thin x in.not Gamma$
          ],
        )),

        // (weak) - dimmed
        dim(grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(weak)],
          text(size: 1.15em)[
            $(Gamma tack A : B quad Gamma tack C : s) / (Gamma, x : C tack A : B) quad upright("if") thin x in.not Gamma$
          ],
        )),

        // (form) - active
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(form)],
          text(size: 1.15em)[
            $frac(Gamma tack A : s quad Gamma tack B : s, Gamma tack A -> B : s)$
          ],
        ),

        // (appl) - active
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(appl)],
          text(size: 1.15em)[
            $frac(Gamma tack M : A -> B quad Gamma tack N : A, Gamma tack M N : B)$
          ],
        ),

        // (abst) - active
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(abst)],
          text(size: 1.15em)[
            $(Gamma, x : A tack M : B quad Gamma tack A -> B : s) / (Gamma tack lambda x : A . thin M : A -> B)$
          ],
        ),

        // (conv) - dimmed
        dim(grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(conv)],
          text(size: 1.15em)[
            $frac(Gamma tack A : B quad Gamma tack B' : s, Gamma tack A : B') quad upright("if") thin B =_beta B'$
          ],
        )),
      ),
    ),
  )

  #v(0.6fr)
]

// ------------------------------------------------------------
// SLIDE 7 — FORMATION RULE (7/11)
// ------------------------------------------------------------

#slide(title: [Formation Rule])[
  #v(1.4fr)

  #grid(
    columns: (1fr, 1.25fr),
    gutter: 3em,
    align: top + center,

    // Left: λω_
    stack(
      spacing: 2em,
      text(size: 1.5em)[$lambda underline(omega)$],
      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.3em,
        )[$Gamma tack A : s quad quad Gamma tack B : s$]),
        line(length: 19em, stroke: 1.2pt + white),
        align(center, text(size: 1.3em)[$Gamma tack A -> B : s$]),
      ),
    ),

    // Right: λP
    stack(
      spacing: 2em,
      text(size: 1.5em)[$lambda upright(P)$],
      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.3em,
        )[$Gamma tack A : * quad quad Gamma, x : A tack B : s$]),
        line(length: 22em, stroke: 1.2pt + white),
        align(center, text(size: 1.3em)[$Gamma tack Pi x : A . thin B : s$]),
      ),
    ),
  )

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 8 — APPLICATION RULE (8/11)
// ------------------------------------------------------------

#slide(title: [Application Rule])[
  #v(1.4fr)

  #grid(
    columns: (1fr, 1.25fr),
    gutter: 3em,
    align: top + center,

    // Left: λω_
    stack(
      spacing: 2em,
      text(size: 1.5em)[$lambda underline(omega)$],
      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.3em,
        )[$Gamma tack M : A -> B quad quad Gamma tack N : A$]),
        line(length: 22em, stroke: 1.2pt + white),
        align(center, text(size: 1.3em)[$Gamma tack M N : B$]),
      ),
    ),

    // Right: λP
    stack(
      spacing: 2em,
      text(size: 1.5em)[$lambda upright(P)$],
      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.3em,
        )[$Gamma tack M : Pi x : A . thin B quad quad Gamma tack N : A$]),
        line(length: 24em, stroke: 1.2pt + white),
        align(center, text(size: 1.3em)[$Gamma tack M N : B [x := N]$]),
      ),
    ),
  )

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 9 — ABSTRACTION RULE (9/11)
// ------------------------------------------------------------

#slide(title: [Abstraction Rule])[
  #v(1.4fr)

  #grid(
    columns: (1fr, 1.25fr),
    gutter: 3em,
    align: top + center,

    // Left: λω_
    stack(
      spacing: 2em,
      text(size: 1.5em)[$lambda underline(omega)$],
      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.25em,
        )[$Gamma, x : A tack M : B quad quad Gamma tack A -> B : s$]),
        line(length: 24em, stroke: 1.2pt + white),
        align(center, text(
          size: 1.25em,
        )[$Gamma tack lambda x : A . thin M : A -> B$]),
      ),
    ),

    // Right: λP
    stack(
      spacing: 2em,
      text(size: 1.5em)[$lambda upright(P)$],
      stack(
        spacing: 0.45em,
        align(center, text(
          size: 1.25em,
        )[$Gamma, x : A tack M : B quad quad Gamma tack Pi x : A . thin B : s$]),
        line(length: 25em, stroke: 1.2pt + white),
        align(center, text(
          size: 1.25em,
        )[$Gamma tack lambda x : A . thin M : Pi x : A . thin B$]),
      ),
    ),
  )

  #v(1.8fr)
]

// ------------------------------------------------------------
// SLIDE 10 — DERIVATION RULES (COMPLETE LAMBDA P) (10/11)
// ------------------------------------------------------------

#slide(title: [Derivation Rules])[
  #v(0.2fr)

  #grid(
    columns: (1fr, 3.8fr),
    gutter: 2em,
    align: horizon,

    align(center)[
      #text(size: 3.4em)[$lambda upright(P)$]
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
            $(Gamma tack A : * quad Gamma, x : A tack B : s) / (Gamma tack Pi x : A . thin B : s)$
          ],
        ),

        // (appl)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(appl)],
          text(size: 1.15em)[
            $frac(Gamma tack M : Pi x : A . thin B quad Gamma tack N : A, Gamma tack M N : B [x := N])$
          ],
        ),

        // (abst)
        grid(
          columns: (4.5em, 1fr),
          align: (left + horizon, left + horizon),
          text(size: 1.05em)[(abst)],
          text(size: 1.15em)[
            $(Gamma, x : A tack M : B quad Gamma tack Pi x : A . thin B : s) / (Gamma tack lambda x : A . thin M : Pi x : A . thin B)$
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
// SLIDE 11 — CONCLUSIONS (11/11)
// ------------------------------------------------------------

#slide(title: [Conclusions])[
  #v(1fr)

  #block(inset: (left: 2em))[
    #set list(spacing: 1.4em)

    #text(size: 1.3em)[
      - _Dependent-Types_

      - $lambda upright(P) = lambda_arrow + upright("types-depending-on-terms")$

      - Same computational power as $lambda_arrow$

      - More expressive type-system
    ]
  ]

  #v(1.5fr)
]
