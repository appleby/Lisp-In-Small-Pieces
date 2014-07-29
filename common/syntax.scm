;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))
;;; This file is part of the files that accompany the book:
;;;     LISP Implantation Semantique Programmation (InterEditions, France)
;;; By Christian Queinnec <Christian.Queinnec@INRIA.fr>
;;; Newest version may be retrieved from:
;;;   (IP 128.93.2.54) ftp.inria.fr:INRIA/Projects/icsla/Books/LiSP*.tar.gz
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
