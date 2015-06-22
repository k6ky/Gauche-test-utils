(use gauche.test)
(use test-utils.test-values)

(test-start "Example of Multiple Values Test")

(test-values* "quotient and remiainder" (2 1) (quotient&remainder 7 3))
(test-values* "only first value failed and reported"
              (0 1) (quotient&remainder 7 3))

(test-end)
