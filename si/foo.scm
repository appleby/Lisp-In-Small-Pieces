;;; $Id$

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

;;; This file introduces a lot of things to test.
;;; (compile-file "si/foo")
;;; (run-application 100 "si/foo")

(set! foo '(a b))

(set! bar 
      (lambda (x) 
        (cons x (dynamic x)) ) )

(set! hux (dynamic-let (x '(c d))
            (dynamic-let (y 'foo)
              (dynamic-let (x foo)
                (bar 'bar) ) ) ))

(display (list foo hux))

;;; end of foo.scm
