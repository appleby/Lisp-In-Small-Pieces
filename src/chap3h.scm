;;; $Id: chap3h.scm,v 4.1 1996/02/16 19:28:34 queinnec Exp $

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

;;; UNWIND-PROTECT

(define-class unwind-protect-cont continuation (cleanup r))

(define-class protect-return-cont continuation (value))

(define (evaluate-unwind-protect form cleanup r k)
  (evaluate form
            r
            (make-unwind-protect-cont k cleanup r) ) )

(define-method (resume (k unwind-protect-cont) v)
  (evaluate-begin (unwind-protect-cont-cleanup k)
                  (unwind-protect-cont-r k)
                  (make-protect-return-cont
                   (unwind-protect-cont-k k) v ) ) )

(define-method (resume (k protect-return-cont) v)
  (resume (protect-return-cont-k k) (protect-return-cont-value k)) )
        
(define-method (resume (k throwing-cont) v)            ; \modified
  (unwind (throwing-cont-k k) v (throwing-cont-cont k)) )

(define-class unwind-cont continuation (value target))

(define-method (unwind (k unwind-protect-cont) v target)
  (evaluate-begin (unwind-protect-cont-cleanup k)
                  (unwind-protect-cont-r k)
                  (make-unwind-cont
                   (unwind-protect-cont-k k) v target ) ) ) 

(define-method (resume (k unwind-cont) v)
  (unwind (unwind-cont-k k) 
          (unwind-cont-value k) 
          (unwind-cont-target k) ) ) 

(define-method (block-lookup (r block-env) n k v) ; \modified
  (if (eq? n (block-env-name r))
      (unwind k v (block-env-cont r))
      (block-lookup (block-env-others r) n k v) ) )

;;; end of chap3h.scm
