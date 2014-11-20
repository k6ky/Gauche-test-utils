(define-module test-utils.test-quickcheck
  (extend gauche.test)
  (use math.mt-random)
  (export test-quickcheck
          composite-generator
          gen-integer
          gen-boolean
          gen-char
          gen-list
          gen-string))
(select-module test-utils.test-quickcheck)

(define (prim-test-quickcheck msg times proc test-cases)
  (format/ss #t "test ~a, ~a times trying ==> " msg times)
  (flush)
  (test-count++)
  (let ((fail-cases
         (remove (lambda (test-case) (eq? #t (proc test-case))) test-cases)))
    (cond ((= 0 (length #?=fail-cases))
           (format #t "ok\n")
           (test-pass++))
          (else
           (format/ss #t "ERROR: ~a cases fail\n" (length fail-cases))
           (format/ss #t "failed cases are: ~S\n" fail-cases)
           (set! *discrepancy-list*
                 (cons (list msg
                             (format "~a cases success" times)
                             (format "~a cases success" (- times
                                                           (length fail-cases))))
                       *discrepancy-list*))
           (test-fail++)))))

(define (test-quickcheck msg times property :rest generators)
  (prim-test-quickcheck
   msg times
   (lambda (test-case)
     (guard (e [else
                (when *test-report-error*
                  (report-error e))
                (make <test-error>
                  :class (class-of e)
                   :message (if (is-a? e <message-condition>)
                                (ref e 'message)
                                e))])
       (property test-case)))
   (map (^x (map (^g (g x)) generators))
        (iota times 1))))

(define mt (make <mersenne-twister> :seed (sys-time)))

(define (composite-generator . generators)
  (lambda (x)
    ((list-ref generators (mt-random-integer mt (length generators)))
     x)))

(define (gen-integer x)
  (mt-random-integer mt (* x 10)))
(define (gen-boolean x)
  (= (mt-random-integer mt 2) 0))
(define (gen-char x)
  (integer->char (mt-random-integer mt 128)))
(define (gen-list gen x)
  (map (^_ (gen x)) (make-list (gen-integer x))))
(define (gen-string)
  (list->string (gen-list gen-char)))

(provide "test-quickcheck")
