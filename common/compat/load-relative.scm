;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))
;;; This file is part of the files that accompany the book:
;;;     LISP Implantation Semantique Programmation (InterEditions, France)
;;; By Christian Queinnec <Christian.Queinnec@INRIA.fr>
;;; Newest version may be retrieved from:
;;;   (IP 128.93.2.54) ftp.inria.fr:INRIA/Projects/icsla/Books/LiSP*.tar.gz
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
