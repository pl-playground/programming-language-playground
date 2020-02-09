#lang racket

(provide parser)

; String -> S-expression
(define (parser s)
  (read (open-input-string (string-replace s "\\n" ""))))