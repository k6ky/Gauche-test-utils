(define-module test-utils.test-quickcheck
  (use gauche.test)
  (use math.mt-random)
  (export test-quickcheck
          gen-integer
          gen-boolean
          gen-char
          gen-list
          gen-string))
(select-module test-utils.test-quickcheck)

(define (test-quickcheck msg times property :rest generators)
  (test msg
        times
        (lambda ()
          (let* ((test-cases (map (^x (map (^f (f x)) generators))
                                  (iota times 1)))
                 (success-cases
                  (filter (lambda (test-case) (apply property test-case))
                          test-cases)))
            (length success-cases)))))

(define mt (make <mersenne-twister> :seed (sys-time)))

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
