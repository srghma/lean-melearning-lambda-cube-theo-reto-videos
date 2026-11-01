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
