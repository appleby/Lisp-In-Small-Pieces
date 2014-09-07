;;; $Id: chap6g.tst,v 4.0 1995/07/10 06:51:45 queinnec Exp $

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

;;; test that only explicitely defined variables are created.

(define xfoo 3)
   ---
(define xfoo (lambda () xbar))
   ***
(begin (define xfoo (lambda () xbar))
       (define xbar 33) )
   ---
(begin (define xfoo (lambda () xbar))
       (define xbar (lambda () xhux)) )
   ***
(begin (define xfoo (lambda () xbar))
       (define xbar (lambda () (xhux))) )
   ***
