(use gauche.test)
(use test-utils.test-quickcheck)

(test-start "Example of Quickcheck")

(test-section "Integer Quickcheck")
(define (collatz-problem n)
  (cond ((= n 1) #t)
        ((even? n) (collatz-problem (/ n 2)))
        ((odd? n) (collatz-problem (+ (* 3 n) 1)))
        (else (error "Invalid argument" n))))

(test-quickcheck "Collatz Problem" 1000 collatz-problem (^x (+ (gen-integer x) 1)))

(test-section "List Quickcheck")
(define (sorted? compare list)
  (cond ((or (null? list) (null? (cdr list))) #t)
        ((compare (car list) (cadr list))
         (sorted? compare (cdr list)))
        (else #f)))
(test-quickcheck "Sort" 100 (.$ (pa$ sorted? <=) sort) (pa$ gen-list gen-integer))

(test-section "Composite input type")
(define (compare-char-and-integer x y)
  (cond ((and (integer? x) (integer? y)) (<= x y))
        ((integer? x) #t)
        ((integer? y) #f)
        (else (char<=? x y))))
(test-quickcheck "Sort" 100
                 (^l (sorted? compare-char-and-integer
                              (sort l compare-char-and-integer)))
                 (pa$ gen-list (composite-generator gen-integer gen-char)))

(test-section "Failed Cases")
(test-quickcheck "Some failed and error cases" 10 even?
                 (composite-generator gen-integer gen-char))

(test-end)
