#lang racket
 
(provide
  empty add add-rec defined? lookup position-of)
 

 
#; (type Env = [Listof [List Var Lang]])
 
(define empty '[])
(define (add x val env) (cons (list x val) env))
(define (defined? x env) (assoc x env))
; (define (lookup x env) (second (defined? x env)))


(define (position-of x env)
  (- (length env) (length (member x (map first env)))))


; - - -

(define (add-rec x val-maker env)
  (cons (list x 'rec val-maker) env))


(define (lookup x env0)
  (let lookup ([env env0])
    (cond
      [(equal? (first (first env)) x) (dispatch env)]
      [else (lookup (rest env))])))
   
  
(define (dispatch env)
  (match (first env)
    [(list (? symbol? x) 'rec val) (val env)]
    [(list (? symbol? x) val) val]))