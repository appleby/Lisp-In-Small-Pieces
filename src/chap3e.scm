;;; $Id: chap3e.scm,v 4.0 1995/07/10 06:51:13 queinnec Exp $

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

;;; Excerpts from chapter 3 (not necessarily Scheme)

(define (fact n)
  (let ((r 1))
    (let ((k (call/cc (lambda (c) c))))
      (set! r (* r n))
      (set! n ( - n 1))
      (if (= n 1) r (k k)) ) ) )

;; (define-syntax catch
;;   (syntax-rules
;;     ((catch tag . body)
;;      (let ((saved-catchers *active-catchers*))
;;        (unwind-protect
;;          (block label
;;            (set! *active-catchers*
;;                  (cons (cons tag (lambda (x) (return-from label x)))
;;                        *active-catchers* ) )
;;            . body )
;;          (set! *active-catchers* saved-catchers) ) ) ) ) )

;; (define-syntax let/cc
;;   (syntax-rules ()
;;     ((let/cc variable . body)
;;      (block variable
;;        (let ((variable (lambda (x) (return-from variable x))))
;;          . body ) ) ) ) )

;;; end of chap3e.scm
