#lang racket

(provide interp1)

(define (interp1 str)
  (define sexp (read str))
  (if (list? sexp)
      "it is an sexpression"
      "it is not an sexpression"))

(displayln (interp1 (command-line #:args (str) str)))