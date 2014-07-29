;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))
;;; This file is part of the files that accompany the book:
;;;     LISP Implantation Semantique Programmation (InterEditions, France)
;;; By Christian Queinnec <Christian.Queinnec@INRIA.fr>
;;; Newest version may be retrieved from:
;;;   (IP 128.93.2.54) ftp.inria.fr:INRIA/Projects/icsla/Books/LiSP*.tar.gz
;;; Check the README file before using this file.
;;;(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))

(define (symbol-append . args)
  (string->symbol
   (apply string-append
          (map (lambda (s)
                 (cond ((string? s) s)
                       ((symbol? s) (symbol->string s))
                       ((number? s) (number->string s))
                       (else (error 'symbol-append 'bad-args args)) ) )
               args ) ) ) )
