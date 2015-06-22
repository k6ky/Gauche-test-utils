(use gauche.test)
(use test-utils.test-combinations)

(test-start "Example of test-combinations")

(test-section "method covering")
(define-class <x> () ())
(define-class <a> (<x>) ())
(define-class <b> (<x>) ())
(define-class <y> () ())
(define-class <c> (<y>) ())
(define-class <d> (<y>) ())
(define-method hoge ((x <a>) (y <c>)) #t)
(define-method hoge ((x <b>) (y <c>)) #t)
(define-method hoge ((x <a>) y) #t)
(define-method hoge ((x <b>) (y <d>)) #t)

(test-combinations "method covering"
                   (((make <a>) (make <b>))
                    ((make <c>) (make <d>)))
                   hoge)


(test-section "Coverage")
(define (fuga a b)
  (if (= a 0)
    0
    (if (> b 10)
      (/ b a)
      b)))
(test-combinations "coverage" ((0 1) (9 10 11))
                   (.$ integer? fuga))
(define (piyo a b)
  (/ a b))
(test-combinations "failed case" ((1) (0 1)) (.$ integer? piyo))

(test-end)
