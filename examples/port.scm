(use gauche.test)
(use test-utils.test-port)


(test-start "Example of Test using port")

(test-module test-utils.test-port)

(use text.html-lite)
(use text.tree)
(test-with-output-port "HTML construction"
                       "<html><head><title>test port</title
></head
><body><p>test port</p

></body
></html
>
"
                       (^p (write-tree (html:html (html:head (html:title "port test"))
                                                  (html:body (html:p "port test")))
                           p)))

(test-end)
