;;; $Id: chap9z.scm,v 4.2 2006/11/25 17:01:28 queinnec Exp $

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

;;; Various excerpts for chapter on macros

(define (prepare expression directives)
  (let ((macroexpand (generate-macroexpand directives)))
    (really-prepare (macroexpand expression)) ) )

(define (prepare expression)
  (really-prepare (macroexpand expression)) )

(define-abbreviation (while condition . body)         \[\hfill\em{LOOP}\]
  `(if ,condition (begin (begin . ,body) 
                         (while ,condition . ,body) )) )

(define-abbreviation (incredible x)               \[\hfill\em{BAD TASTE}\]
  (call/cc (lambda (k) `(quote (,k ,x)))) )

(define-abbreviation (define-immediate-abbreviation call . body)
  (let ((name (gensym)))
    `(begin (define ,name (lambda ,(cdr call) . ,body))
            (define-abbreviation ,call (,name . ,(cdr call))) ) ) )

;;; end of chap9z.scm
