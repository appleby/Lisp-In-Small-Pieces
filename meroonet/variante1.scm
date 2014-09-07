;;; $Id: variante1.scm,v 1.5 2006/11/25 17:44:13 queinnec Exp $

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

;;; This file is part of the Meroonet package.

;;; VARIANT 1:  a simple-minded define-class

;;; a define-class that works only for interpreters, the class is
;;; created at macroexpansion time and grafted to the inheritance tree
;;; at that same time. The version in Meroonet is safer.

(define-meroonet-macro (define-class name super-name 
                                     own-field-descriptions )
  (let ((class (register-class name super-name 
                               own-field-descriptions )))
    (Class-generate-related-names class) ) )

;;; end of variante1.scm
