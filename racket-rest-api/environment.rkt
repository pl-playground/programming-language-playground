#lang racket
 
(provide
 
 #; {type Env :
          empty :: Env,
          add :: Var Number Env -> Env,
          defined? :: Var Env -> Any,
          lookup :: Var Env -> Number
          position-of :: Var Env -> N}
 
 empty add add-rec defined? lookup position-of)
 
;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;; here is one way to implement an environment 
 
#; (type Env = [Listof [List Var Number]])
 
(define empty '[])
(define (add x val env) (cons (list x val) env))
(define (defined? x env) (assoc x env))
; (define (lookup x env) (second (defined? x env)))

#;  (defined? x env)
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