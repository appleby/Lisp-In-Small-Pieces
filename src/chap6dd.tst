;;; $Id: chap6dd.tst,v 4.0 1995/07/10 06:51:40 queinnec Exp $

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

;;; Tests for chap6dd.scm

(redefine car)
   ---
(set! car car)
   ---
(car '(a b))
   a
((lambda (old v)
   (begin (set! old car)
          (set! car cdr)
          (set! v (car '(a b)))
          (set! car old)
          v ) )
  'old 'v )
   (b)

;;; testing errors
(redefine car)
  ***
(redefine foo)
  ***

;;; end of chap6dd.tst
