#lang racket

(require web-server/servlet
         web-server/servlet-env)
(define (myresponse request)
  (define bindings (request-bindings request))
  (cond ((exists-binding? 'name bindings)
         (define name (extract-binding/single 'name bindings))
         (response/xexpr
          `(html (head (title "Simple Page"))
                 (body (h1 "A Simple Dynamic Page")
                       (body
                        (p "Hi, " ,name)))))
         )
        (else (response/xexpr
               '(html (head (title "Simple Page"))
                      (body
                       (h1 "A Simple Form")
                       (form
                        (textarea ((name "name")(id "myTextArea")(rows "20") (cols "80")))
               
                        (input ((type "submit")))))))
              ))
  )

(serve/servlet myresponse #:port 8080)
