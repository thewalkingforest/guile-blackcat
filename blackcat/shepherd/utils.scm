; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd utils)
  #:use-module (blackcat utils)
  #:export (setup-dir))

(define* (setup-dir path mode uid' #:optional (gid' uid'))
  "Ensure directory exists at PATH with MODE and owned by UID:GID"
  (let ((uid (get-uid uid'))
        (gid (get-gid gid')))
    (cond
      ((or (not uid) (not gid)) #f)
      ((not (access? path F_OK))
       (mkdir path mode)
       (chown path uid gid)
       #t)
      ((eq? (stat:type (stat path)) 'directory)
       (chown path uid gid)
       #t)
      (else #f))))
