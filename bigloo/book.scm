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

;;; This file defines an interpreter containing all that is needed to
;;; interpret the programs of C. Queinnec's book. This file is to be
;;; compiled by Bigloo. It contains Meroonet, the syntax-case package
;;; of Hieb and Dybvig, and the tester utility to run test suites.

(module book (main main)
        ;; Import the run-time of this interpreter
        (import (rtbook  "bigloo/rtbook.scm")) )

;;; Start the interpreter. In fact everything comes from the rtbook
;;; module which is separately compiled in order to provide a library
;;; which can be linked with other programs. See an example with the
;;; test.chap6a.bgl entry of the Makefile.

(define (main options)
  (format #f "")                        ; forces rtbookp to be linked
  (start) )

;;; end of book.scm
