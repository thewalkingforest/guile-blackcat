; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd)
  #:declarative? #f
  #:export (load-services-dir))

(use-modules (ice-9 ftw))
(use-modules (blackcat shepherd defaults))

(define* (load-services-dir #:optional (path (default-services-path)))
  (let ((services-dir  path))
    (for-each
      (lambda (file)
        (when (string-suffix? ".scm" file)
          (load (string-append services-dir "/" file))))
      (or (scandir services-dir
                   (lambda (f) (string-suffix? ".scm" f)))
          '()))))
