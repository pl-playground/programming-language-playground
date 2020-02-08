#lang web-server/insta

(define (start request)
  (response/xexpr
   '(html
     (head (title "PL Playground")
           '(style ((type "text/css")) "textarea  { font-family:Menlo;   font-size: 24px; }"))
     (body (h1 "Programming Language Playground")
           (form
            (textarea ((id "myTextArea")(rows "20") (cols "80"))))))))







