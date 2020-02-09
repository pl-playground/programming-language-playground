#lang racket
   
;; an interpreter that explicitly orders the evaluation of
;; every subexpression where the ordering wasn't specified
;; RIGHT to LEFT 
   
(require "environment.rkt")
; (require "../6/rec-as-data.rkt")
; (require "../4/possible-values.rkt")
   
;; #; {FExpr -> Value}
;; determine the value of ae via a substitutione semantics 
(define ((interpret promise promise->value) ae0)
   
  ;; #; {FExpr Env[Promise] -> Value}
  ;; ACCUMULATOR env tracks all declarations between ae and ae0
  (define (interpret ae env)
    (match ae
      [(? integer?) ae]
      [`(+ ,a1 ,a2)
       (define left  (number> (promise->value (interpret a1 env))))
       (define right (number> (promise->value (interpret a2 env))))
       (+ left right)]
      [`(* ,a1 ,a2)
       (define left  (number> (promise->value (interpret a1 env))))
       (define right (number> (promise->value (interpret a2 env))))
       (* left right)]
      [`(bind ,l ,r ,b)
       (interpret b (add-rec l (λ (env) (interpret r env)) env))]
      [(? symbol?)
       (if (defined? ae env)
           (lookup ae env)
           (error 'value-of "undeclared variable ~e" ae))]
      ;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      [`(call ,ae1 ,ae2)
       (define left  (function> (interpret ae1 env)))
       (define right (promise (λ () (interpret ae2 env))))
       (fun-apply left right)]
      ;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      [`(fun ,para ,body)
       `(function-value ,para ,body ,env)]
      [`(if0 ,t ,thn ,els)
       (define test-value (promise->value (interpret t env)))
       (if (and (number? test-value) (= test-value 0))
           (interpret thn env)
           (interpret els env))]))
   
  ;; #; {Value Value -> Value}
  (define (fun-apply function-representation argument-value)
    (match function-representation
      [`(function-value ,fpara ,fbody ,env)
       (interpret fbody (add fpara argument-value env))]))
   
  (promise->value (interpret ae0 empty)))
   
;; #; {Any -> Number}
(define (number> x)
  (if (integer? x)
      x
      (error 'interpreter "integer expected, given ~e " x)))
   
;; #; {Any -> Function}
(define (function> x)
  (match x
    [`(function-value ,_ ,_ ,_) x]
    [_ (error 'interpreter "function-value expected, given ~e " x)]))
   
;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   
(provide interpret (rename-out [interpret value-of]))


