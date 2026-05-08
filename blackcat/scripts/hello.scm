(define-module (blackcat scripts hello)
  #:use-module (ice-9 format)
  #:export (main))

(define (main . args)
   (format #t "hello ~a~%" (string-join args "")))
