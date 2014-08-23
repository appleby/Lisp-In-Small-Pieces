;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))
;;; This file is part of the files that accompany the book:
;;;     LISP Implantation Semantique Programmation (InterEditions, France)
;;; By Christian Queinnec <Christian.Queinnec@INRIA.fr>
;;; Newest version may be retrieved from:
;;;   (IP 128.93.2.54) ftp.inria.fr:INRIA/Projects/icsla/Books/LiSP*.tar.gz
;;; Check the README file before using this file.
;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))

;;; This file is used to customize Mit-Scheme in order to run the source files
;;; of the book. It may serve as a basis for other ports to other Scheme
;;; interpreters.

;;; Guile-specific code.
;;;
;;; Definitions in this section are specific to Mit-Scheme, and are unlikely to
;;; be needed if you're porting this file to another scheme.

;;; Guile's eval requires a second argument, the environment. Redefine eval to
;;; make the second argument optional, so as not to break code that expects a
;;; one-arg eval.
(define native-eval eval)

(define (eval exp . env)
  (native-eval exp (if (null? env) (interaction-environment) (car env))) )

;;; Define `load-relative' to be `primitive-load', rather than `load'
;;; so that loading of files in common/* works as expected. See the
;;; comment in common/compat/load-relative.scm for more info.
(define load-relative primitive-load)

;;; End of Guile-specific code.

;;; General definitions.
;;;
;;; All the definitions below are needed to run the source files of the book.
;;; When porting to another scheme, you'll need to provide equivalents for
;;; these.

;;; This variable is used in chap8k.scm to determine the underlying
;;; Scheme interpreter.
(define book-interpreter-support 'guile)

;;; Printed when the toplevel loop is started. See START in
;;; ../common/book.scm.
(define book-interpreter-name "Guile")

(define flush-buffer force-output)

;;; Needed by (test "src/syntax.tst")
(define (get-internal-run-time)
  (current-time) )

;;; Called from internal DISPALY-STATUS definition in both INTERPRETER and
;;; SUITE-TEST in src/tester.scm.
(define display-exception display)

;;; The test-driver should try to catch errors of the underlying Scheme system.
;;; This is non-portable and difficult in many implementations. If do not
;;; succeed writing it, you can still run the programs of the book but you will
;;; not be able to run all the test-suites since some tests (for instance in
;;; meroonet/oo-tests.scm) require errors to be caught when signalled by
;;; list-tail with a non-numeric second argument.

;;; Returns a toplevel that handles exceptions.
;;;
;;; Used in:
;;;     START and TEST in ../common/book.scm
;;;     INTERPRETER and SUITE-TEST in ../src/tester.scm
;;;
(define (make-toplevel read print-or-check err)
  (set! tester-error   err)
  (set! meroonet-error err)
  (lambda ()
    (catch #t
       (lambda ()
         (let ((e (read)))
           (print-or-check (eval e (interaction-environment))) ) )
       err ) ) )

;;; End of General definitions.
