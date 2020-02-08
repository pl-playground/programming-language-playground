#lang racket

(require web-server/servlet
         web-server/servlet-env)

(define (binding-handler request)
  (define bindings (request-bindings request))
  (if (exists-binding? 'name bindings)
      (extract-binding/single 'name bindings)
      ""))

(define (display-code request)
  `(textarea ((name "name") (id "myTextArea")(rows "20") (cols "80"))
             ,(binding-handler request)))

(define (myresponse request)
  (define bindings (request-bindings request))
  (response/xexpr
   `(html (head (title "Simple Page"))
          (body
           (h1 "A Simple Form")
           (form
            ,(display-code request)
            (p (input ((type "submit"))))
            (p ,(binding-handler request)))))))



(serve/servlet myresponse #:port 8080)
