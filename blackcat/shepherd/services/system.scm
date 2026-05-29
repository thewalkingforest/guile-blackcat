;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd services system)
  #:use-module (shepherd service))

(define-public acpid-service
  (service
   '(acpid)
   #:requirement '(system)
   #:start (make-forkexec-constructor
            '("acpid" "-f" "-l"))
   #:stop (make-kill-destructor)
   #:respawn? #t))
