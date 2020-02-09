#lang racket
   
(provide
 (struct-out promise)
 promise->value)
   
(struct promise [p] #:transparent)
#; {Promise = (U (promise [-> Promise]) Value)}
#; {Value = Number || (function-value parameter FExpr Env)}
   
#; {(U Promise Value) -> Value}
(define (promise->value Promise-or-value)
  (cond
    [(promise? Promise-or-value)
     (promise->value [(promise-p Promise-or-value)])]
    [else Promise-or-value]))