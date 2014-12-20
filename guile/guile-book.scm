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

;;; This file is used to customize Guile in order to run the source
;;; files of the book.
;;;
;;; See mit-scheme/mit-book.scm for a fully-commented version of this
;;; file that can be used as a template for ports to other scheme's.

;;; Guile-specific code.

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

;;; Guile doesn't have pp. Load pretty-print from common/pp.scm (which
;;; will get re-loaded from common/book.scm).
(primitive-load "common/pp.scm")
(define pp pretty-print)

;;; Pull in SRFI 43 for vector operations.
(use-modules (srfi srfi-43))

;;; General definitions.

(define book-interpreter-support 'guile)

(define book-interpreter-name "Guile")

(define flush-buffer force-output)

(define (get-internal-run-time)
  (current-time) )

(define (display-exception args)
  (if (and (symbol? (car args))
	   (= 5 (length args)))
      ;; Args smell like a guile exception. Call display-error.
      (apply display-error #f (current-error-port) (cdr args))
      ;; Not a guile exception, most likely a call to wrong.
      (display args)))

(define (make-toplevel read print-or-check err)
  (set! tester-error   err)
  (set! meroonet-error err)
  (lambda ()
    (catch #t
       (lambda ()
         (let ((e (read)))
           (print-or-check (eval e (interaction-environment))) ) )
       err ) ) )
