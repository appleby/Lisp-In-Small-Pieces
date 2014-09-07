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

;;; The `show' and `clone' generic functions are predefined in Meroon not in
;;; Meroonet.  The clone function that performs a shallow copy of a Meroonet
;;; object.

(eval '(begin
          (define-generic (show (o) . stream)
            (let ((stream (if (pair? stream) (car stream)
                              (current-output-port) )))
              (bounded-display o stream) ) )
          (define-generic (clone (o))
            (list->vector (vector->list o)) ) ) )

