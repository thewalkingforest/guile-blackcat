;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at https://mozilla.org/MPL/2.0/.


(define-module (blackcat scripts reload)
  #:use-module (blackcat shepherd defaults)
  #:use-module (blackcat watch)
  #:use-module (ice-9 format)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 getopt-long)
  #:use-module (ice-9 match)
  #:use-module (shepherd comm)
  #:use-module (shepherd support)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-171)
  #:use-module (srfi srfi-9)
  #:use-module (mkusage))

(define reload-arg-spec '((watch (single-char #\w) (value #f))
                          (service-directory  (single-char #\d) (value #t))
                          (unload-deleted (value #f))
                          (help (single-char #\h))))
(define reload-arg-spec-desc '((watch             "Watch services for reloading")
                               (service-directory "Specify service directory. Can be given more than one time")
                               (unload-deleted    "Unload service if deleted")
                               (help              "Print this help message")))

(define usage (make-usage reload-arg-spec
                          '(many "SERVICE")
                          #:spec-desc reload-arg-spec-desc
                          #:name "reload"))

(define-record-type <CliParams>
  (make-CliParams watch services-directories unload-deleted services)
  CliParams?
  (watch CliParams-watch)
  (services-directories CliParams-services-directories)
  (unload-deleted CliParams-unload-deleted)
  (services CliParams-services))

(define (parse-service-directories opts)
  (filter-map
   (lambda (v)
     (and (equal? (car v) 'service-directory)
          (cdr v)))
   opts))

(define (parse-args args)
  (let* ((opts (getopt-long args
                            reload-arg-spec
                            #:stop-at-first-non-option #t))
         (watch (option-ref opts 'watch #f))
         (service-directories  (parse-service-directories opts))
         (unload-deleted (option-ref opts 'unload-deleted #f))
         (services (cdar opts))
         (help (option-ref opts 'help #f)))
    (values help (make-CliParams watch
                                 services-directories
                                 unload-deleted
                                 services))))

(define get-file-names
  (match-lambda
    ((name stat) name)
    ((name stat children) (map get-file-names children))))

(define (get-services path)
  (let* ((tree (file-system-tree path))
         (files (list-transduce tflatten rcons tree)))
    files))

(define (reload-service name path)
  (let ((path (string-append path "/" name)))
    (write-command (shepherd-command 'load 'root #:arguments `(,path))
                   (current-socket-file))))

(define (remove-suffix str suffix)
  (if (string-suffix? suffix str)
      (string-drop-right str (string-length suffix))
      str))

(define (unload-service file)
  (let ((name (remove-suffix file ".scm")))
    (write-command (shepherd-command 'unload 'root #:arguments `(,name))
                   (current-socket-file))))

(define-public (main . args)
  (define-values (help params) (parse-args args))
  (when help (usage #:exit-with 0))
  (let ((watch (CliParams-watch params))
        (services (CliParams-services params))
        (services-directories (CliParams-services-directories  params))
        (unload-deleted (CliParams-unload-deleted params))
        )
    (cond
     [(and (not watch) (null? services))
      (usage "Must specify service(s) when not watching"
             #:exit-with 1)]
     [else
      (for-each
       (lambda (s) (display s))
       services)])
    (when watch
      (watch-directories
       services-directories
       (lambda (ty name)
         (match ty
           ((or 'create 'modify) (reload-service name services-directory))
           ('delete (if unload-deleted (unload-service name) '()))
           (_ #f)))))
    )
  )
