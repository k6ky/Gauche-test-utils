(define-module test-utils.test-values
  (extend gauche.test)
  (use gauche.sequence)
  (export test-values
          test-values*))
(select-module test-utils.test-values)

(define (prim-test-values msg expects thunk)
  (flush)
  (receive vals (thunk)
    (cond ((= (length vals) (length expects))
           (for-each-with-index
            (lambda (i r expect)
              (test-count++)
              (let ((cmp test-check)
                                        ;(expect (if (pair? expect) (car expect) expect))
                                        ;(cmp (if (pair? expect) (cadr expect) test-check))
                    )
                (format/ss #t "test ~a(value ~a), expects ~s ==> " msg i expect)
                (cond [(cmp expect r)
                       (format #t "ok\n")
                       (test-pass++)]
                      [else
                       (format/ss #t "ERROR: GOT ~S\n" r)
                       (set! *discrepancy-list*
                             (cons (list msg expect r) *discrepancy-list*))
                       (test-fail++)])))
            vals expects))
          (else
           (for-each (lambda (_)
                       (test-count++)
                       (format/ss #t "ERROR: GOT ~S\n" vals)
                       (set! *discrepancy-list*
                             (cons (list msg expects vals) *discrepancy-list*))
                       (test-fail++))
                     expects)))
    (flush)))

(define (test-values msg expects thunk)
  (prim-test-values
   msg expects
   (lambda ()
     (guard (e [else
                (when *test-report-error*
                  (report-error e))
                (make <test-error>
                  :class (class-of e)
                   :message (if (is-a? e <message-condition>)
                                (ref e 'message)
                                e))])
       (thunk)))))

(define-syntax test-values*
  (syntax-rules ()
    ((_ msg (expects ...) form)
     (test-values msg (list expects ...) (lambda () form)))
    ((_ msg expects form)
     (test-values msg expects (lambda () form)))))

(provide "test-values")
