; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd services desktop)
  #:use-module (shepherd service)
  #:use-module (blackcat shepherd utils))

(define-public (lightdm-service)
  (setup-dir "/run/lightdm" #o711 "lightdm")
  (service
    '(lightdm)
    #:requirement '(dbus)
    #:start (make-forkexec-constructor '("lightdm"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public emptty-service
  (service
    '(emptty)
    #:start (make-forkexec-constructor
              '("setsid" "/usr/bin/emptty" "-d"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public xdm-service
  (service
    '(xdm)
    #:start (make-forkexec-constructor
              '("xdm" "-error" "/dev/stdout" "-nodaemon"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
