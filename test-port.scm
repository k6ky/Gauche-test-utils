(define-module test-utils.test-port
  (use gauche.test)
  (export test-port))
(select-module test-utils.test-port)

(define (test-port msg expect proc)
  (test msg expect
        (call-with-output-port proc)))
;; (define-syntax test-port*
;;   (syntax-rules (port)
;;     ((_ msg expect form)
;;      (test-port msg expect ))))


(provide "test-utils.test-port")










