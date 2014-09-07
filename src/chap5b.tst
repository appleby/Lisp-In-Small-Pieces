;;; Test for Lambda-calculus

;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))
;;; This file is derived from the files that accompany the book:
;;;     LISP Implantation Semantique Programmation (InterEditions, France)
;;;     or  Lisp In Small Pieces (Cambridge University Press).
;;; By Christian Queinnec <Christian.Queinnec@INRIA.fr>
;;; The original sources can be downloaded from the author's website at
;;;   http://pagesperso-systeme.lip6.fr/Christian.Queinnec/WWW/LiSP.html
;;; This file may have been altered from the original in order to work with
;;; modern schemes. The latest copy of these altered sources can be found at
;;;   https://github.com/appleby/Lisp-In-Small-Pieces
;;; If you want to report a bug in this program, open a GitHub Issue at the
;;; repo mentioned above.
;;; Check the README file before using this file.
;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))
;;; The initial environment maps identifiers to numbers and also contain
;;; the addition as a delta rule.

a
   1
b
   2
(+ a)
   ---
((+ a) b)
   3

((lambda (K) ((K a) b))
 (lambda (x) (lambda (y) x)) )
   1

((lambda (S) 
   ((lambda (K) (((S K) K) b))
    (lambda (x) (lambda (y) x)) ) )
 (lambda (f) (lambda (g) (lambda (x) ((f x) (g x))))) )
   2

;;; these three loop
((label fact (lambda (x)
               ((((= x) a)
                 a )
                ((* x) (fact ((- x) a))) ) ))
  a )
    1
((label fact (lambda (x)
               ((((= x) a)
                 a )
                ((* x) (fact ((- x) a))) ) ))
  ((+ b) b) )
    24

((lambda (Y)
   ((lambda (meta-fact)
      ((Y meta-fact) ((+ b) b)) )
    (lambda (f)
      (lambda (x)
        ((((= x) a)
          a )
         ((* x) (f ((- x) a))) ) ) ) ) )
 (lambda (f)
   ((lambda (x) (f (lambda (y) ((x x) y))))
    (lambda (x) (f (lambda (y) ((x x) y)))) ) ) )
   24

;;; end of chap5b.tst
