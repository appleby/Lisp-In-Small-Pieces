;;; $Id: chap10ex.scm,v 4.0 1995/07/10 06:50:39 queinnec Exp $ 

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

;;; This is the running example of chapter 10. This expression will be
;;; compiled to C in the src/c/chap10ex.c file. It contains at least
;;; one example of all syntactic structures.

(begin
  (set! index 1)
  ((lambda (cnter . tmp)
      (set! tmp (cnter (lambda (i) (lambda x (cons i x)))))
      (if cnter (cnter tmp) index) )
   (lambda (f) 
     (set! index (+ 1 index))
     (f index) )
   'foo ) ) 

;;; end of chap10ex.scm
