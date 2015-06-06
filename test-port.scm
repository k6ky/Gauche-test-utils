(define-module test-utils.test-port
  (extend gauche.test)
  (use text.diff)
  (export test-with-output-port
          test-with-input-port))
(select-module test-utils.test-port)

(define (test-port-writer element type)
  (case type
    ((-)
     (format/ss #t "expect: ~a\n" element))
    ((+)
     (format/ss #t "got:    ~a\n" element))
    ((#f)
     (format/ss #t "        ~a\n" element))))

(define (prim-test-port msg expect thunk)
  (flush)
  (test-count++)
  (let ((r (thunk))
        (cmp test-check))
    (cond ((cmp expect r)
           (test-pass++)
           (format/ss #t "test ~a, expects ~s ==> ok\n"
                      msg expect))
          ((not (string? r))
           (format/ss #t "test ~a, expects ~s ==> ERROR: GOT -S\n"
                      msg expect r))
          (else
           (test-fail++)
           (format/ss #t "test ~a ==> Error\n" msg)
           (diff-report expect r
                        :writer test-port-writer)
           (set! *discrepancy-list*
                 (cons (list msg expect r) *discrepancy-list*))))))

(define (test-with-output-port msg expect proc)
  (prim-test-port msg expect
                  (lambda ()
                    (guard (e [else
                               (when *test-report-error*
                                 (report-error e))
                               (make <test-error>
                                 :class (class-of e)
                                 :message (if (is-a? e <message-condition>)
                                              (ref e 'message)
                                              e))])
                      (call-with-output-string proc)))))

(define (test-with-input-port msg expect input proc)
  (test* msg expect (call-with-input-string input proc)))

(provide "test-utils.test-port")
