#import "common.typ": *

#let lambda-systems-table(compact: false) = {
  let system-width = if compact { 6.5em } else { 8em }
  let pairs-width = if compact { 16.5em } else { 20em }

  rect(
    stroke: 1pt + white,
    inset: 0pt,
    table(
      columns: (system-width, pairs-width),
      stroke: none,
      align: (center + horizon, left + horizon),
      inset: (x: 0.8em, y: 0.45em),

      table.cell(stroke: (bottom: 1.2pt + white))[
        #text(weight: "bold")[System]
      ],

      table.cell(
        align: center,
        stroke: (bottom: 1.2pt + white),
      )[
        #text(weight: "bold")[Pairs of Sorts]
      ],

      [$lambda_arrow$], [$(*, *)$],
      [$lambda 2$], [$(*, *) quad (square, *)$],
      [$lambda underline(omega)$], [$(*, *) quad (square, square)$],
      [$lambda upright(P)$], [$(*, *) quad (*, square)$],
      [$lambda omega$], [$(*, *) quad (square, *) quad (square, square)$],
      [$lambda upright(P) 2$], [$(*, *) quad (square, *) quad (*, square)$],
      [$lambda upright(P) underline(omega)$],
      [$(*, *) quad (square, square) quad (*, square)$],
      [$lambda upright(C)$],
      [$(*, *) quad (square, *) quad (square, square) quad (*, square)$],
    ),
  )
}

#let formation-rule(
  system,
  premises,
  conclusion,
  width: 21em,
  size: 1.25em,
) = {
  grid(
    columns: (6.5em, auto),
    column-gutter: 1.2em,
    align: horizon,

    text(size: size)[#system],

    stack(
      spacing: 0.4em,
      align(
        center,
        text(size: size)[#premises],
      ),
      line(
        length: width,
        stroke: 1.2pt + white,
      ),
      align(
        center,
        text(size: size)[#conclusion],
      ),
    ),
  )
}

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let lambda-cube-diagram(
  compact: false,
) = {
  let node-size = if compact { 1.1em } else { 1.3em }
  let spacing = if compact {
    (1.6cm, 1.15cm)
  } else {
    (2.8cm, 1.7cm)
  }

  diagram(
    spacing: spacing,
    node-stroke: none,
    node-fill: none,
    mark-scale: 75%,

    node((0, 2), text(node-size)[$lambda_arrow$], name: <base>),
    node((2, 2), text(node-size)[$lambda upright(P)$], name: <lp>),
    node((0, 0), text(node-size)[$lambda 2$], name: <l2>),
    node((2, 0), text(node-size)[$lambda upright(P) 2$], name: <lp2>),

    node(
      (0.9, 1.2),
      text(node-size)[$lambda underline(omega)$],
      name: <lw-low>,
    ),
    node(
      (2.9, 1.2),
      text(node-size)[$lambda upright(P) underline(omega)$],
      name: <lpw>,
    ),
    node((0.9, -0.8), text(node-size)[$lambda omega$], name: <lw-top>),
    node((2.9, -0.8), text(node-size)[$lambda upright(C)$], name: <lc>),

    edge(<base>, <l2>, "->", stroke: 1.8pt + green),
    edge(<base>, <lp>, "->", stroke: 1.8pt + green),
    edge(<base>, <lw-low>, "->", stroke: (
      paint: green,
      thickness: 1.8pt,
      dash: "dotted",
    )),

    edge(<l2>, <lp2>, "->", stroke: 1pt + grey),
    edge(<lp>, <lp2>, "->", stroke: 1pt + grey),

    edge(<l2>, <lw-top>, "->", stroke: 1pt + grey),
    edge(<lp2>, <lc>, "->", stroke: 1pt + grey),
    edge(<lp>, <lpw>, "->", stroke: 1pt + grey),

    edge(<lw-low>, <lw-top>, "->", stroke: (
      paint: grey,
      thickness: 1pt,
      dash: "dotted",
    )),
    edge(<lw-low>, <lpw>, "->", stroke: (
      paint: grey,
      thickness: 1pt,
      dash: "dotted",
    )),
    edge(<lw-top>, <lc>, "->", stroke: 1pt + grey),
    edge(<lpw>, <lc>, "->", stroke: 1pt + grey),
  )
}
