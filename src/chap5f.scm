;;; $Id: chap5f.scm,v 4.3 2005/07/20 09:07:43 queinnec Exp $

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


(define-syntax delay_
  (syntax-rules ()
    ((delay_ expression) (lambda () expression)) ) )

(define (force_ promise) (promise)) 

(define (print_ x)
  (display x) 
  x ) 

;;; prints 66 
(let ((p (delay_ (print_ (* 2 3)))))
  (list (force_ p) (force_ p)) )

(define-syntax memo-delay
  (syntax-rules ()
    ((memo-delay expression) 
     (let ((already-computed? #f)
           (value 'wait) )
       (lambda () 
         (if (not already-computed?)
             (begin 
               (set! value expression)
               (set! already-computed? #t) ) )
         value ) ) ) ) )

;;; prints 6 (only one time)
(let ((p (memo-delay (print_ (* 2 3)))))
  (list (force_ p) (force_ p)) )

;;; CPS 

(define (cps e)
  (if (pair? e)
      (case (car e)
        ((quote)  (cps-quote (cadr e)))
        ((if)     (cps-if (cadr e) (caddr e) (cadddr e)))
        ((begin)  (cps-begin (cdr e)))
        ((set!)   (cps-set! (cadr e) (caddr e)))
        ((lambda) (cps-abstraction (cadr e) (caddr e)))
        (else     (cps-application e)) )
      (lambda (k) (k `,e)) ) )

(define (cps-quote data)
  (lambda (k)
    (k `(quote ,data)) ) )

(define (cps-set! variable form)
  (lambda (k)
    ((cps form)
     (lambda (a)
       (k `(set! ,variable ,a)) ) ) ) ) 

(define (cps-if bool form1 form2)
  (lambda (k)
    ((cps bool)
     (lambda (b)
       `(if ,b ,((cps form1) k) 
               ,((cps form2) k) ) ) ) ) )

(define (cps-begin e)
  (if (pair? e)
      (if (pair? (cdr e))
          (let ((void (gensym "void")))
            (lambda (k)
              ((cps (car e))
               (lambda (a)
                 ((cps-begin (cdr e))
                  (lambda (b)
                    (k `((lambda (,void) ,b) ,a)) ) ) ) ) ) )
          (cps (car e)) )
      (cps '()) ) )

(define (cps-application e)
  (lambda (k)
    (if (memq (car e) primitives)
        ((cps-terms (cdr e))
         (lambda (t*)
           (k `(,(car e) ,@t*)) ) )
        ((cps-terms e)
         (lambda (t*)
           (let ((d (gensym)))
             `(,(car t*) (lambda (,d) ,(k d)) 
                         . ,(cdr t*) ) ) ) ) ) ) )

(define primitives '( cons car cdr list * + - = pair? eq? ))

(define (cps-terms e*)
  (if (pair? e*)
      (lambda (k)
        ((cps (car e*))
         (lambda (a)
           ((cps-terms (cdr e*))
            (lambda (a*) 
              (k (cons a a*)) ) ) ) ) )
      (lambda (k) (k '())) ) )

(define (cps-abstraction variables body)
  (lambda (k)
    (k (let ((c (gensym "cont")))
            `(lambda (,c . ,variables)
               ,((cps body)
                 (lambda (a) `(,c ,a)) ) ) )) ) ) 

(newline)

(pp ((cps '(set! fact (lambda (n)
                        (if (= n 1) 1
                            (* n (fact (- n 1))) ) )))
     (lambda (x) x) ))

(newline)

(pp ((cps '(begin 1 2))
     (lambda (x) x)))

(newline)
;;; end of chap5f.scm
