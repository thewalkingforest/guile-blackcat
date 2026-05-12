; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat scripts autoload)
  #:use-module (blackcat shepherd defaults)
  #:use-module (blackcat watch)
  #:use-module (ice-9 format)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module (shepherd comm)
  #:use-module (shepherd support)
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

(define* (reload-service name #:optional (path default-services-path))
  (let ((path (string-append path "/" name)))
    (write-command (shepherd-command 'load 'root #:arguments `(,path)))))

(define (remove-suffix str suffix)
  (if (string-suffix? suffix str)
    (string-drop-right str (string-length suffix))
    str))

(define (unload-service file)
  (let ((name (remove-suffix file ".scm")))
    (write-command (shepherd-command 'unload 'root #:arguments `(,file)))))

(define (main . args)
  (watch-directory
    default-services-path
    (lambda (ty name)
      (match ty
        ((or 'create 'modify) (reload-service name))
        ('delete (unload-service name))
        (_ #f)))))
