// ============================================================
// Shared presentation theme
// Lambda Cube Unboxed series
// ============================================================

#let bg = rgb("#24393A")
#let white = rgb("#F5F5F5")
#let teal = rgb("#24393A")
#let gold = rgb("#A77D42")
#let green = rgb("#24B94F")
#let grey = rgb("#899596")

// Document-level slide configuration
#let setup(doc) = {
  set page(
    paper: "presentation-16-9",
    margin: 0pt,
    fill: bg,
  )

  set text(
    font: ("Arial", "Liberation Sans", "DejaVu Sans"),
    size: 13pt,
    fill: white,
  )

  doc
}

// Reusable responsive slide container
#let slide(title: none, body) = {
  grid(
    columns: 100%,
    rows: (
      if title != none { 3.2em } else { 0pt },
      1fr,
      auto,
    ),
    // Top white section header (only when title is present)
    if title != none {
      block(
        width: 100%,
        height: 100%,
        fill: rgb("#FFFFFF"),
        stroke: (bottom: 1pt + rgb("#E7E7E7")),
        inset: (x: 2.5em),
        align(left + horizon)[
          #text(size: 1.4em, weight: "medium", fill: teal)[#title]
        ],
      )
    } else {
      none
    },

    // Slide main content area
    block(
      width: 100%,
      height: 100%,
      inset: (
        x: 2.5em,
        top: if title != none { 1.2em } else { 2.5em },
        bottom: 0.8em,
      ),
      body,
    ),

    // Bottom gold separator & slide counter
    block(
      width: 100%,
      stroke: (top: 1.5pt + gold),
      inset: (x: 2.5em, top: 0.4em, bottom: 0.6em),
      align(right + top)[
        #text(size: 0.8em, fill: white)[
          #context [
            #counter(page).display()/#counter(page).final().first()
          ]
        ]
      ],
    ),
  )
  pagebreak(weak: true)
}

// ============================================================
// Reusable content panels
// ============================================================

#let panel(title, body) = {
  block(
    width: 100%,
    fill: rgb("#354A4B"),
    inset: 0pt,
    stack(
      spacing: 0pt,

      // Panel heading
      block(
        width: 100%,
        fill: rgb("#506061"),
        inset: (x: 0.5em, y: 0.3em),
        text(size: 1.05em, weight: "bold")[#title],
      ),

      // Panel content
      block(
        width: 100%,
        inset: (x: 0.8em, y: 0.55em),
        body,
      ),
    ),
  )
}

#let title-slide(
  title,
  year: 2021,
  institution: "Technische Universität Berlin",
) = {
  slide[
    #v(1fr)

    #text(size: 2.4em, weight: "bold")[#title]

    #v(0.8em)
    #line(length: 100%, stroke: 1.2pt + gold)

    #v(0.8em)

    #grid(
      columns: (1fr, 1fr),
      align: horizon,
      stack(
        spacing: 1.2em,
        text(size: 1.1em)[#year],
        text(size: 1em)[#institution],
      ),
      none,
    )

    #v(2fr)
  ]
}

#let inference-rule(
  premise,
  conclusion,
  width: 22em,
  size: 1.3em,
  spacing: 0.45em,
) = {
  stack(
    spacing: spacing,
    align(center, text(size: size)[#premise]),
    line(length: width, stroke: 1.2pt + white),
    align(center, text(size: size)[#conclusion]),
  )
}

#let comparison(
  left,
  right,
  left-title: [Logic],
  right-title: [$lambda$-Calculus],
  gutter: 2.5em,
) = {
  grid(
    columns: (1fr, 1.4fr),
    gutter: gutter,
    align: top + center,

    stack(
      spacing: 2em,
      text(size: 1.5em, weight: "bold")[#left-title],
      left,
    ),

    stack(
      spacing: 2em,
      text(size: 1.5em, weight: "bold")[#right-title],
      right,
    ),
  )
}

// ============================================================
// Generic truth table
// ============================================================

#let truth-table(
  headers: (),
  rows: (),
  columns: (),
  highlight-cols: (),
  header-size: 1.3em,
  body-size: 1.2em,
  inset: (x: 0.6em, y: 0.55em),
  result-color: gold,
) = {
  // Generate styled header cells.
  let header-cells = headers.map(
    h => text(size: header-size)[#h],
  )

  // Start with the header row.
  let cells = (
    table.header(..header-cells),
  )

  // Generate data cells.
  for row in rows {
    for (i, value) in row.enumerate() {
      let highlighted = i in highlight-cols

      let cell = if highlighted {
        text(
          size: body-size,
          weight: "bold",
          fill: result-color,
        )[#value]
      } else {
        text(size: body-size)[#value]
      }

      cells.push(cell)
    }
  }

  table(
    columns: columns,
    stroke: none,
    align: center + horizon,
    inset: inset,
    ..cells,
  )
}

#let logic-comparison(
  left,
  right,
  left-title: [Logic],
  right-title: [$lambda$-Calculus],
  columns: (1fr, 1.4fr),
  gutter: 2.5em,
  spacing: 2.2em,
) = {
  grid(
    columns: columns,
    gutter: gutter,
    align: top + center,

    stack(
      spacing: spacing,
      left-title,
      left,
    ),

    stack(
      spacing: spacing,
      right-title,
      right,
    ),
  )
}
