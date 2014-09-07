;;; $Id: chap10e.tst,v 4.0 1995/07/10 06:50:39 queinnec Exp $

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

;;; Additional tests for chap10e the compiler from Scheme to C.

;;; negative numbers
(- 3 33)
   -30
;;; explicit syntax for booleans
(if (car (cons #f #t)) 'void #t)
   #t

;;; test closures sharing
(if (car (cons 2 3))
    22 33 )
   22
;;; This would need to recognize functions equivalence modulo alpha-conversion.
((lambda (x) 
   (list (lambda () x) (lambda () x)) )
 'x )
   (?- ?-)

;;; foreign interface
(list (system "date"))
   ---

;;; This program was used as a running example of the compiler. It is
;;; no longer true since the example is now in src/chap10ex.scm.
;;; Pay attention that `if' should be ternary for objectify.
(begin
 (set! foo (lambda (l c)
             ((lambda (max)
                ((lambda (walk) (walk l walk c))
                 (lambda (l f c)
                   (if (pair? l)
                       (begin (if (< max (car l))
                                  (set! max (car l))
                                  #t )
                              (f (cdr l) f (lambda (max min)
                                             (if (< (car l) min)
                                                 (cons max (car l))
                                                 (c max min) ) ) ) )
                       (c max 100) ) ) ) )
              0 ) ))
 (foo '(1 2 3 2 1) cons) )
   (3 . 1)

;;; end of chap10e.tst
