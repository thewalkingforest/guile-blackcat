; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat scripts autoload)
  #:use-module (blackcat shepherd defaults)
  #:use-module (blackcat watch)
  #:use-module (ice-9 format)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-171)
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

(define (remove-suffix str suffix)
  (if (string-suffix? suffix file)
    (string-drop-right file (string-length suffix))
    file))

(define (unload-service file)
  (let* ((name (remove-suffix file ".scm"))
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
