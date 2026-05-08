(define-module (blackcat scripts autoload)
  #:use-module (ice-9 format)
  #:use-module (blackcat shepherd defaults)
  #:use-module (blackcat watch)
  #:export (main))

(define (main . args)
  (watch-directory
    default-services-path
    (lambda (_ name)
      (system (format #f
                      "herd load root ~a"
                      (string-append default-services-path "/" name))))))
