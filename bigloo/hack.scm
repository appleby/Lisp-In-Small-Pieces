;;; $Id: hack.bgl,v 1.5 1998/05/01 09:38:43 queinnec Exp queinnec $

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

;;; NOTE: I'm not sure whether the following comments are any longer relevant.

;(display "starting hack.scm")(newline)           ;; DEBUG

;;; Three macros are defined in meroonet.scm: define-class,
;;; define-method and define-generic. They must be compiled and made
;;; pervasive so that interpreters containing meroonet.o code make
;;; these macros available. Fortunately, they are not needed by
;;; meroonet itself so they must be only installed at run-time.

(define-macro (define-meroonet-macro call . body)
  `(begin (eval '(define-macro ,call . ,body))
          (define-macro ,call . ,body) ) )

;;;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;;; The define-abbreviation macro is used throughout the book and
;;; should be present in the generated interpreter.

;;; This code is compiled with Bigloo so it is expanded by Bigloo's
;;; expand which knows the define-meroonet-macro which was defined
;;; just before. It will generate a Dybvig-macro named
;;; define-abbreviation whose aim is to be a Dybvig-macro
;;; definer. That's why define-meroonet-macro and define-abbreviation
;;; use the same expander (except that macros defined by
;;; define-meroonet-macro call a compiled expander whereas macros
;;; defined by define-abbreviation are interpreted since they are
;;; defined on the fly).

(define-meroonet-macro (define-abbreviation call . body)
  `(begin (eval '(define-macro ,call . ,body))
          (define-macro ,call . ,body) ) )

;(display "end of hack.scm")(newline)           ;; DEBUG

;;; end of hack.scm
