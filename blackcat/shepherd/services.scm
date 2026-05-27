; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd services)
  #:use-module (blackcat shepherd defaults)
  #:use-module (shepherd service)
  #:re-export (%core-services
               %core-services-service))

(define-public mcron-service
  (service
    '(mcron)
    #:start (make-forkexec-constructor '("mcron"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public guix-daemon-service
  (service
    '(guix-daemon)
    #:start (make-forkexec-constructor
             '("guix-daemon" "--build-users-group=guixbuild"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
