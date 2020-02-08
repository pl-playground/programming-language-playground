#lang racket

(provide interp1)

(define (interp1 str)
  (string-append "interp1 was run on " str))