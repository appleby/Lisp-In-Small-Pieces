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

;;; Mit-Scheme-specific code.
;;; 
;;; Definitions in this section are specific to Mit-Scheme, and are unlikely to
;;; be needed if you're porting this file to another scheme.

(load-option 'synchronous-subprocess)

;;; Mit-Scheme does not provide current-error-port.
(define current-error-port notification-output-port)

;;; Mit-scheme's eval requires a second argument, the environment. Redefine
;;; eval to make the second argument optional, so as not to break code that
;;; expects a one-arg eval.
(define native-eval eval)

(define (eval exp . env)
  (native-eval exp (if (null? env) user-initial-environment (car env))) )

;;; Mit-scheme does not provide define-macro, which is used (indirectly) in
;;; Meroonet.  Simulate it via define-syntax.
(define-syntax define-macro
  (syntax-rules ()
    ((define-macro (name . args) body ...)
     (define-syntax name
       (rsc-macro-transformer
         (let ((transformer (lambda args body ...)))
           (lambda (exp env)
             (apply transformer (cdr exp))) ) ) ) ) ) )

;;; End of Mit-Scheme-specific code.


;;; General definitions.
;;;
;;; All the definitions below are needed to run the source files of the book.
;;; When porting to another scheme, you'll need to provide equivalents for
;;; these.

;;; This variable is used in chap8k.scm to determine the underlying
;;; Scheme interpreter.
(define book-interpreter-support 'mit)

;;; Printed when the toplevel loop is started. See START in
;;; ../common/book.scm.
(define book-interpreter-name "Mit-Scheme")

(define (system command)
  (run-shell-command command))

(define flush-buffer flush-output)

;;; Needed by (test "src/syntax.tst")
(define (get-internal-run-time)
  (real-time-clock) )

;;; Called from internal DISPALY-STATUS definition in both INTERPRETER and
;;; SUITE-TEST in src/tester.scm.
(define (display-exception v)
  (let ((condition (and (pair? v) (car v))))
    (if (condition? condition)
      (write-condition-report condition stdout-port)
      (display v) ) ) )

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
    (bind-condition-handler () err
        (lambda ()
          (let ((e (read)))
            (print-or-check (eval e user-initial-environment)) ) ) ) ) )

;;; End of General definitions.
