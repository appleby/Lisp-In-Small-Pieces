;;; Testing dynamic binding

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

(dynamic-let (a 1) 2)
   2
(dynamic-let (a 1) 2 3 4)
   4
(dynamic-let (a 1) (dynamic a))
   1
(dynamic-let (a 1) (+ (dynamic a) (dynamic a)))
   2
(dynamic-let (a 1)
  (dynamic-let (a (+ (dynamic a) (dynamic a)))
     (dynamic a) ) )
   2

;;; with respect to functions
((lambda (f)
   (dynamic-let (a 1) (f)) ) 
 (lambda () (dynamic a)) )
   1
((lambda (f)
   (dynamic-let (a 1)
     (list (f)
           (dynamic-let (a 2) (f)) ) ) )
 (lambda () (dynamic a)) )
   (1 2)

;;; with respect to continuations
(dynamic-let (a 1)
   ((call/cc (lambda (k)
               ((lambda (f) 
                   (dynamic-let (a 2) f) )                      
                (lambda () (dynamic a)) ) ))) )
   1
