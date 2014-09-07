;;; $Id: chap8b.tst,v 4.0 1995/07/10 06:52:02 queinnec Exp $

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

;;; Eval with dynamic variables

"Testing dynamic variables"
   ---
(dynamic-let (a 1)
  (eval '(dynamic a)) )
   1
(dynamic-let (a 1)
  (dynamic-let (b 2)
    (eval '(dynamic b)) ) )
   2
((lambda (f)
   (dynamic-let (a 33)
     ((eval 'f)) ) )
 (lambda () (dynamic a)) )
   33

;;; end of chap8b.tst
