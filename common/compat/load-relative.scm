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

;;; This is a hack to support Guile. In Bigloo, Mit, and Gambit, if
;;; the argument to `load' is a relative path, it's considered to be
;;; relative to the scheme process' current working directory. In
;;; Guile, however, it's considered to be relative to the file which
;;; contains the `load' form. As such, we use `load-relative' in place
;;; of `load' in all common/* files, and override `load-relative' in
;;; guile/guile-book.scm. All other schemes merely include this file.
(define load-relative load)
