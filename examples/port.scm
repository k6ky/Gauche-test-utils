(use gauche.test)
(use test-utils.test-port)


(test-start "Example of Test using port")

(test-module 'test-utils.test-port)

(test-with-output-port "procedure"
                       "hoge"
                       (pa$ display "hoge"))

(use text.html-lite)
(use text.tree)
(test-with-output-port "HTML construction fail"
                       "<html><head><title>test port</title
></head
><body><p>port test</p
></body
></html
>
"
                       (^p (write-tree (html:html (html:head (html:title "port test"))
                                                  (html:body (html:p "port test")))
                           p)))

(test-with-input-port "port consumer"
                      1
                      "1"
                      ($ read $))

(test-end)
