;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))
;;; This file is part of the files that accompany the book:
;;;     LISP Implantation Semantique Programmation (InterEditions, France)
;;; By Christian Queinnec <Christian.Queinnec@INRIA.fr>
;;; Newest version may be retrieved from:
;;;   (IP 128.93.2.54) ftp.inria.fr:INRIA/Projects/icsla/Books/LiSP*.tar.gz
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
