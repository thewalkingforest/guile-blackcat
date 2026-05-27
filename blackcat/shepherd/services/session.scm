; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd services session)
  #:use-module (shepherd service)
  #:use-module (blackcat shepherd utils))

(define-public (dbus-service)
  (setup-dir "/run/dbus" #o755 "dbus")
  (service
    '(dbus)
    #:start (make-forkexec-constructor
              '("dbus-daemon" "--system" "--nofork" "--nopidfile"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public elogind-service
  (service
    '(elogind)
    #:start (make-forkexec-constructor
              '("/usr/libexec/elogind/elogind.wrapper"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public seatd-service
  (service
    '(seatd)
    #:start (make-forkexec-constructor
              '("seatd" "-g" "_seatd"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public turstiled-service
  (service
    '(turstiled)
    #:start (make-forkexec-constructor
              '("turstiled"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
