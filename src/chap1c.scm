;;; $Id: chap1c.scm,v 4.0 1995/07/10 06:50:54 queinnec Exp $

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

;;;                  variants of chapter 1.

(define (s.make-function variables body env)
  (lambda (values current.env)
    (let ((old-bindings
           (map (lambda (var val) 
                      (let ((old-value (getprop var 'apval)))
                        (putprop var 'apval val)
                        (cons var old-value) ) )
                variables
                values ) ))
      (let ((result (eprogn body current.env)))
        (for-each (lambda (b) (putprop (car b) 'apval (cdr b)))
                  old-bindings )
        result ) ) ) )

(define (s.lookup id env)
  (getprop id 'apval) )

(define (s.update! id env value)
  (putprop id 'apval value) ) 

;;; end of chap1c.scm
