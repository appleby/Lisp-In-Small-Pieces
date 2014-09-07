;;; Some tests for chap5e.scm

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

3
   (3)
'(a b)         
   ((a b))
(car '(a b))    
   (a a)
(if 1 2 3)     
   (2)
(+ 2 3)
   (5 5 5 5 5 5)
(list 2 3 4)
   ((2 3 4) (2 3 4) (2 3 4) (2 3 4) (2 3 4) (2 3 4)
    (2 3 4) (2 3 4) (2 3 4) (2 3 4) (2 3 4) (2 3 4)
    (2 3 4) (2 3 4) (2 3 4) (2 3 4) (2 3 4) (2 3 4)
    (2 3 4) (2 3 4) (2 3 4) (2 3 4) (2 3 4) (2 3 4) )
(call/cc 
 (lambda (k) 
   ((k 1) (k 2)) ) )
    (1 1 1 1 2 2 2 2)

;;; end of chap5e.tst
