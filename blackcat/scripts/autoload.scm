(define-module (blackcat scripts autoload)
  #:use-module (ice-9 format)
  #:use-module (ice-9 ftw)
  #:use-module (srfi srfi-171)
  #:use-module (blackcat shepherd defaults)
  #:use-module (blackcat watch)
  #:export (main))

(define get-file-names
  (match-lambda
    ((name stat) name)
    ((name stat children) (map get-file-names children))))

(define (get-services path)
  (let* ((tree (file-system-tree path))
         (files (list-transduce tflatten rcons tree)))
    files))

(define* (reload-service name #:optional (path default-services-path)) name
  (let* ((path (string-append path "/" name))
         (args `("herd" "load" "root" ,path))
         (pid (spawn "herd" args)))
    (waitpid pid)))

(define (unload-service file)
  (let* ((name (string-replace-substring file ".scm" ""))
         (args `("herd" "unload" "root" ,name))
         (pid (spawn "herd" args)))
    (waitpid pid)))

(define (main . args)
  (watch-directory
    default-services-path
    (lambda (ty name)
      (match ty
        ((or 'create 'modify) (reload-service name))
        ('delete (unload-service name))
        (_ #f)))))
