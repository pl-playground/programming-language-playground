#lang racket

(require "interp-delay.rkt")

(define (promise f) (f))
(define (promise->value p) p)

(define interp-val (interpret promise promise->value))

    
(define constant-example
  `(bind constant (fun x 42)
         (call constant (+ (fun x x) 1))))

 (define constant-example2
    `(bind constant (fun x x)
          (bind y (call constant (fun x (+ (fun x x) 1)))
                42)))


; (interp-val constant-example) = error
; (interp-val constant-example2) = 42