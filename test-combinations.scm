(define-module test-utils.test-combinations
  (use gauche.test)
  (export test-combinations))
(select-module test-utils.test-combinations)

(define (make-test-name test-name args)
  (string-append test-name ", with args ("
                 ($ fold string-append "" $ map x->string $ intersperse " " args)
                 ")"))

(define (arguments-combinations arg-candidacies)
  (if (null? arg-candidacies)
    '(())
     (let* ((args (car arg-candidacies))
            (rest (arguments-combinations (cdr arg-candidacies))))
       (append-map (^a (map (pa$ cons a) rest)) args))))

(define-syntax test-combinations
  (syntax-rules ()
    ((test-combinations test-name ((arg ...) ...) pred)
     (for-each (lambda (args)
                 (test* (make-test-name test-name args)
                        #t
                         (apply pred args)))
               (arguments-combinations (list (list arg ...) ...))))
    ((test-combinations test-name (arg ...) pred)
     (for-each (lambda (args)
                 (test* (make-test-name test-name args)
                        #t
                         (apply pred args)))
               (arguments-combinations (list arg ...))))))

(provide "test-combinations")
