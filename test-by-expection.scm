(define-module test-utils.test-by-expection
  (use gauche.test)
  (export test-by-ex*
          coin-test*))
(select-module test-utils.test-by-expection)

(define (trying number thunk)
  (/ (fold (lambda (_ acc)
             (+ acc (thunk)))
           0
           (iota number))
     number))
(define (in-pardon? exception pardon value)
  (if (and (> value (* exception (- 1 pardon)))
           (< value (* exception (+ 1 pardon))))
      #t
       (error "the value is not in ragne" (+ 0.0 value))))
(define-syntax test-by-ex*
  (syntax-rules ()
    ((_ test-name exception trying-number pardon expr)
     (test* (string-append "RANDOM: " test-name)
            #t
             (in-pardon? exception
                         pardon
                         (trying trying-number (lambda () expr)))))))
(define-syntax coin-test*
  (syntax-rules ()
    ((_ test-name trying-number pardon succuess-rate fail-rate expr)
     (test-by-ex* test-name
                  (/ succuess-rate (+ succuess-rate fail-rate))
                  trying-number
                  pardon
                  (if expr 1 0)))))


(provide "test-by-expection")
