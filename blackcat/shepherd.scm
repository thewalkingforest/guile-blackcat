; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd)
  #:declarative? #f
  #:use-module (ice-9 ftw)
  #:use-module (blackcat shepherd defaults)
  #:export (load-services-dir)
  #:re-export (%core-services))

(define* (load-services-dir #:optional (path (default-services-path)))
  (let ((services-dir  path))
    (for-each
      (lambda (file)
        (when (string-suffix? ".scm" file)
          (load (string-append services-dir "/" file))))
      (or (scandir services-dir
                   (lambda (f) (string-suffix? ".scm" f)))
          '()))))

(define* (declare-service provides #:keys (requirement ’())
                                          (one-shot? #f)
                                          (transient? #f)
                                          (respawn? #f)
                                          (start (const #t))
                                          (stop (const #f))
                                          (actions (actions))
                                          (termination-handler default-service-termination-handler)
                                          (documentation #f)
                                          (setup #t))
  (define s
    (service
      provides
      #:requirement requirement
      #:one-shot? one-shot?
      #:transient? transient?
      #:respawn? respawn?
      #:start start
      #:stop stop
      #:actions actions
      #:termination-handler termination-handler
      #:documentation documentation))

  (when (setup)
    (register-services (list s)))
  )
