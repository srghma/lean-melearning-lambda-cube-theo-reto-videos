/-
  LambdaCube.lean

  Formalization of the Lambda Cube based on lecture notes.
  Exports all common definitions and all 8 systems forming the vertices of the Lambda Cube.

  Lecture references:
  - Lecture 01: "Lambda Cube Unboxed (0)"
  - Lecture 06: "The Simply Typed Lambda Calculus (2.1)"
  - Lecture 07: "Properties of the Simply Typed Lambda Calculus (2.2)"
  - Lecture 08: "The Extension λ2 (Lambda Two) (3.1)"
  - Lecture 09: "Computing in λ2 (3.2)"
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)"
  - Lecture 11: "The Extension λP (Lambda P) (5)"
  - Lecture 12: "The Lambda Cube and λC (6)"
  - Lecture 13: "Propositions as Types (7)"
-/

-- import LambdaCube.Common.Syntax
-- import LambdaCube.Common.Substitution
-- import LambdaCube.Common.Context
-- import LambdaCube.Common.Typing
-- import LambdaCube.LambdaOmegaWeakWeak
import LambdaCube.LambdaOmegaWeakWithoutConv
-- import LambdaCube.LambdaOmegaWeakWeak2
import LambdaCube.LambdaOmegaWeak
import LambdaCube.LambdaArrow
import LambdaCube.LambdaTwo
-- import LambdaCube.LambdaOmegaWeak
-- import LambdaCube.LambdaP
-- import LambdaCube.LambdaTwoP
-- import LambdaCube.LambdaTwoOmega
-- import LambdaCube.LambdaPOmega
-- import LambdaCube.LambdaC
