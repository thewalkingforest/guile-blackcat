; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat utils)
  #:export (get-uid get-gid))

(define (get-uid unam)
  "Get the uid number from the user's name or passes through user's numeric id"
  (cond
    ((string? unam) (passwd:uid (getpwnam unam)))
    ((integer? unam) (inexact->exact (truncate unam)))
    (else #f)))

(define (get-gid gnam)
  "Get the gid number from the group's name or passes through group's numeric id"
  (cond
    ((string? gnam) (group:gid (getgrnam gnam)))
    ((integer? gnam) (inexact->exact (truncate gnam)))
    (else #f)))
