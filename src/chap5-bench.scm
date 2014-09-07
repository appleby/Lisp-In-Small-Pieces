;;; $Id: chap5-bench.scm,v 4.0 1995/07/10 06:51:22 queinnec Exp $

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
;;; This expression serves to compare the speed of two denotational
;;; interpreters (chap5a and chap5d).

(begin
  (set! primes
        (lambda (n f max)
          ((lambda (filter)
             (begin
               (set! filter (lambda (p)
                              (lambda (n) (= 0 (remainder n p))) ))
               (if (> n max)
                   '()
                   (if (f n)
                       (primes (+ n 1) f max)
                       (cons n
                             ((lambda (ff)
                                (primes (+ n 1)
                                        (lambda (p) (if (f p) t (ff p)))
                                        max ) )
                              (filter n) ) ) ) ) ) )
           'wait ) ) )
  (display (primes 2 (lambda (x) f) 500)) )

;;; With interpreted-chap5a on blaye: 62. seconds
;;; With interpreted-chap5d on blaye: 58. seconds
;;; With compiled-chap5a on blaye: 20. seconds
;;; With compiled-chap5d on blaye: 12. seconds
;;; With interpreted-chap6a on blaye: 2. seconds
;;; Compiled to C on blaye: 0.02 seconds 
;;;               size: 
;;; text    data    bss     dec     hex
;;; 28672   4096    96      32864   8060

;;; end of chap5-bench.scm
