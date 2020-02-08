#lang racket

(require web-server/servlet
         web-server/servlet-env)
(define (myresponse request)
  (define bindings (request-bindings request))
  (response/xexpr
   `(html (head (title "Simple Page"))
          (body
           (h1 "A Simple Form")
           (form
            (textarea ((name "name")(id "myTextArea")(rows "20") (cols "80")))
            (input ((type "submit")))
            ,(binding-handler request)))))
  )

(define (binding-handler request)
  (define bindings (request-bindings request))
  (if (exists-binding? 'name bindings)
      (let [(name (extract-binding/single 'name bindings))]
        (response/xexpr
         `(html (head (title "Simple Page"))
                (body (h1 "A Simple Dynamic Page")
                      (body
                       (p "Hi, " ,name))))))         
      (response/xexpr
       `(html (head (title "Simple Page"))
              (body (h1 "A Simple Dynamic Page")
                    (body
                     (p "Hi, GIVE ME A BINDING")))))
      )
  )

(serve/servlet myresponse #:port 8080)
