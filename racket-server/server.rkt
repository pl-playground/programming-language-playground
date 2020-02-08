#lang racket

(require web-server/servlet
         web-server/servlet-env
         "interpreters/interp1.rkt")

; Repl is a
; (list Source : String
;       Value  : String)

; Repl when no binding exists
(define NO-BINDING-REPL (list "" ""))

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
            (p ,(second (binding-handler request))))))))

; start the server
(serve/servlet main #:port 8080)
