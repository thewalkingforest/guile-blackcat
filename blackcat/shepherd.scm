;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd)
  #:declarative? #f
  #:use-module (blackcat shepherd services)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 optargs))

(define*-public (load-services-dir #:optional (path default-services-path))
  (for-each
   (lambda (file)
     (load (string-append path "/" file)))
   (or (scandir path (lambda (f) (string-suffix? ".scm" f)))
       '())))
