#lang racket

(require web-server/servlet
         web-server/servlet-env
         web-server/formlets
         "interpreters/interp1.rkt")

; Repl is a
; (list Source : String
;       Value  : String)

; Repl when no binding exists
(define NO-BINDING-REPL (list "" ""))

(define (radio-group values name)
  (make-input*
   (lambda (n)
     `(div
       ,@(for/list ((value values))
           `(div
             (input
              ((name ,name) (type "radio") (value ,(bytes->string/utf-8 value))))
             ,(bytes->string/utf-8 value)))))))

(define radio-button-formlet
  (formlet
   (div
    ,{(default #"default" (radio-group (list #"Interp1" #"Interp2" #"Interp3") "interpreter")) . => . ci} )
   (list ci)))

; Request -> Repl
; returns a REPL with src code from textarea 
; and the the interpreted value. If no binding,
; returns NO-BINDING-REPL
(define (binding-handler request)
  (define bindings (request-bindings request))
  (if (exists-binding? 'name bindings)
      (let ([b (extract-binding/single 'name bindings)])
        (list b (interp1 b)))
      NO-BINDING-REPL))

; Request -> Xexpr
; wraps the src code from Repl into a text area
(define (display-code request)
  `(textarea ((name "name") (id "myTextArea") (rows "20") (cols "80"))
             ,(first (binding-handler request))))


(define (show-current-interpreter request)
  (define bindings (request-bindings request))
  (displayln bindings)
  (if (exists-binding? 'checked bindings)
      (let ([b (map  (λ (x) (extract-binding/single 'checked x)) bindings)])
        b)
      "no interpreter chosen"))

; Request -> Response
; response to server with Xexpr
(define (main request)
  (define bindings (request-bindings request))
  (response/xexpr
   `(html (head (title "PL Playground"))
          (body
           (h1 "Programming Language Playground")
           (form
            ,(display-code request)
            (p (input ((type "Submit"))))
            (p ,(second (binding-handler request)))
            (p , "TODO THESE ARE THE INSTRUCTIONS")
            (p ,(first (formlet-display radio-button-formlet)))
            (p ,(show-current-interpreter request)))))))

; start the server
(serve/servlet main #:port 8080)
