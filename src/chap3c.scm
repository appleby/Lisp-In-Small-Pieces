;;; $Id: chap3c.scm,v 4.1 1996/02/16 19:28:34 queinnec Exp $

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

;; (define-syntax block
;;   (syntax-rules ()
;;     ((block label . body)
;;      (let ((label (list 'label)))
;;        (catch label . body) ) ) ) )

;; (define-syntax return-from
;;   (syntax-rules ()
;;     ((return-from label value)
;;      (throw label value) ) ) )

;; (define (find-symbol id tree)
;;   (block find
;;     (letrec ((find (lambda (tree)
;;                      (if (pair? tree)
;;                          (or (find (car tree))
;;                              (find (cdr tree)) )
;;                          (if (eq? id tree) (return-from find #t)
;;                              #f ) ) )))
;;       (find tree) ) ) )

;;; end of chap3c.scm
