;;; $Id: chap2h.tst,v 4.0 1995/07/10 06:51:08 queinnec Exp $

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

(2 '(a b c d))
   c
(-1 '(a b c))
   (b c)

(2 '(foo bar hux wok))  
   hux
(-2 '(foo bar hux wok)) 
   (hux wok)
(0 '(foo bar hux wok))  
  foo
(2 (-3 '(a b c d e f g h)))
   f

((list + - *) 5 3)
   (8 2 15)

;;; end of chap2h.tst
