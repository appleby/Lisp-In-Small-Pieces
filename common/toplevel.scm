;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))
;;; This file is part of the files that accompany the book:
;;;     LISP Implantation Semantique Programmation (InterEditions, France)
;;; By Christian Queinnec <Christian.Queinnec@INRIA.fr>
;;; Newest version may be retrieved from:
;;;   (IP 128.93.2.54) ftp.inria.fr:INRIA/Projects/icsla/Books/LiSP*.tar.gz
;;; Check the README file before using this file.
;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))

;;; This function loads a file expanded with syntax-expand.
;;;
;;; 2014 Note: This function is not needed anymore, since the built-in load can
;;; now do syntax-case expansion. Leaving this here for now since the verbose
;;; loading might prove useful for debugging.

(define *syntax-case-load-verbose?* #f)

(define (syntax-case-load file)
  (call-with-input-file file
    (lambda (in)
      (if *syntax-case-load-verbose?* 
          (begin (newline)
                 (display ";;; Loading ")
                 (display file)
                 (newline) ) )
      (let loop ((e (read in)))
        (if (eof-object? e) 
            file
            (let ((r (eval e)))
              (if *syntax-case-load-verbose?*
                  (begin (display ";= ")
                         (display r)
                         (newline) ) )
              (loop (read in)) ) ) ) ) ) )

;;; This function will test a suite of tests.

(define (test file)
  (suite-test
   file "?? " "== " #t
   make-toplevel
   equal? ) )
;;; Test: 
;;;	(test "meroonet/oo-tests.scm")
;;;	(test "src/syntax.tst")

;;; A small toplevel loop.
(define (start)
  (display "[C. Queinnec's book] ")
  (display book-interpreter-name)
  (display "+Meroonet...")
  (newline)
  ;(set! *syntax-case-load-verbose?* #t)
  ;(set! load syntax-case-load)
  (interpreter
   "? " "= " #t
   make-toplevel )
  (display " Ite LiSP est.")
  (newline)
  (exit 0) )
