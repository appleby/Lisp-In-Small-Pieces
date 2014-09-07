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

;;; Two macros that I frequently use:
(define-syntax unless
  (syntax-rules ()
    ((unless condition form ...)
     (if (not condition) (begin form ...)) ) ) )

(define-syntax when
  (syntax-rules ()
    ((when condition form ...)
     (if condition (begin form ...)) ) ) )

;;; Since the define-abbreviation is also necessary for the book when non high
;;; level macros are defined, register define-abbreviation for syntax-case. 

(define-syntax define-abbreviation
  (syntax-rules ()
    ((define-abbreviation call . body)
     (define-macro call . body) ) ) )
