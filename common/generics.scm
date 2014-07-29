;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))
;;; This file is part of the files that accompany the book:
;;;     LISP Implantation Semantique Programmation (InterEditions, France)
;;; By Christian Queinnec <Christian.Queinnec@INRIA.fr>
;;; Newest version may be retrieved from:
;;;   (IP 128.93.2.54) ftp.inria.fr:INRIA/Projects/icsla/Books/LiSP*.tar.gz
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

