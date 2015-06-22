Gauche-test-utils
================================

Overview
---------
`test-utils' is a set of modules that extend gauche.test module for some specific usages.

# Getting started
Put these modules on your $GAUCHE_LOAD_PATH, and use necessary module by (use test-utils.test-*).
Then you can use specific test macros and procedures between `test-start' and `test-end' like `test' or `test*'.

Usage examples are in test-utils/example directory.

# Modules 
+ test-quickcheck
  Provides "QuickCheck" like random test tool.
  It consists of random testing procedure `test-quickcheck' and some random value generators.
  You need to specify tested procedure's arguments types by choosing and compositing these generators.
  These generators output small values at first, and make them bigger gradually.
+ test-port
  To test procedures which use output or input port.
  It provides `test-with-input-port' and `test-with-output-port'
  You can describe port contents which tested procedure consumes or produces by string.
  Moreover, you can check error by diff between expected string and output-port contents which tested procedure produces.
+ test-values
  To test expr which returns multiple values.
  It provides `test-values*' macro and `test-values' procedure.
+ test-combinations
  Cover all listed arguments candidates combination.
+ test-by-expection
  To check the expection value of expr with randomness.
  It provides `test-by-expection*' and `coin-test*' macros.
