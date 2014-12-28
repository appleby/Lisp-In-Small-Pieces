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

;;(include "~~lib/syntax-case.scm")

(include "gambit-book.scm")
(include "../common/compat/gensym.scm")
(include "../common/compat/property-lists.scm")
(include "../common/compat/symbol-append.scm")
(include "../common/definitions.scm")
(include "../common/pp.scm")
(include "../common/format.scm")
(include "../src/tester.scm")
(include "../common/syntax.scm")

(define-macro (define-meroonet-macro call . body)
  `(define-macro ,call . ,body) )

(include "../meroonet/meroonet.scm")
(include "../common/generics.scm")
(include "../common/toplevel.scm")

;; Warp into the new toplevel
(start)
