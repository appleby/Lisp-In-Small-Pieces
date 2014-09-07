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

;;; This file customizes the Gambit interpreter from Marc Feeley in order
;;; to run the source files of the book. I did not try to compile it yet.
;;; Under Unix, start gsi as:
;;;          gsi '(include "gambit/book.scm")'

;;; Gambit-specific code.
;;; 
;;; Last-pair and reverse! are need to run the book sources and are included in
;;; both Bigloo and Mit-Scheme, but missing in Gambit.

(define (last-pair l)
  (if (pair? l)
      (if (pair? (cdr l)) 
          (last-pair (cdr l))
          l )
      (support-error 'last-pair l) ) )

(define (reverse! l)
  (define (nreverse l r)
    (if (pair? l)
       (let ((cdrl (cdr l)))
         (set-cdr! l r)
         (nreverse cdrl l) )
       r ) )
  (nreverse l '()) )

;;; End of Gambit-specific code.

;;; General definitions.
;;;
;;; All the definitions below are needed to run the source files of the book.
;;; When porting to another scheme, you'll need to provide equivalents for
;;; these.

;;; This variable is used in chap8k.scm to determine the underlying
;;; Scheme interpreter.
(define book-interpreter-support 'gsi)

;;; Printed when the toplevel loop is started. See START in
;;; ../common/book.scm.
(define book-interpreter-name "Gambit")

(define (system command)
  (shell-command command))

(define flush-buffer force-output)

;;; Needed by (test "src/syntax.tst")
(define (get-internal-run-time)
  (time->seconds (current-time)))

;;; Called from internal DISPALY-STATUS definition in both INTERPRETER and
;;; SUITE-TEST in src/tester.scm.
(define (display-exception values)
  (let ((exc (car values)))
      (display exc)
      (cond ((unbound-global-exception? exc)
             (display ", VAR = ")
             (display (unbound-global-exception-variable exc))
             (display ", RTE = ")
             (display (unbound-global-exception-rte exc)) )
            ((datum-parsing-exception? exc)
             (display ", KIND = ")
             (display (datum-parsing-exception-kind exc))
             (display ", PARAMS = ")
             (display (datum-parsing-exception-parameters exc)) )
            ((error-exception? exc)
             (display ", MESSAGE = ")
             (display (error-exception-message exc))
             (display ", PARAMS = ")
             (display (error-exception-parameters exc)) )
            ((type-exception? exc)
             (display ", PROC = ")
             (display (type-exception-procedure exc))
             (display ", ARGS = ")
             (display (type-exception-arguments exc))
             (display ", ARGNUM = ")
             (display (type-exception-arg-num exc))
             (display ", TYPEID = ")
             (display (type-exception-type-id exc)) ) ) ) )

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
 (current-user-interrupt-handler
   (lambda ()
     (newline stderr-port)
     (display "*** INTERRUPT" stderr-port)
     (newline stderr-port)
     (err '***) ) )
 (lambda ()
   (with-exception-catcher err
    (lambda ()
      (let* ((e (read))
             (r (eval e)) )
        (print-or-check r) ) ) ) ) )
;;; End of General definitions.
