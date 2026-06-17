;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd services)
  #:use-module (blackcat shepherd services core)
  #:use-module (shepherd service)
  #:re-export (%core-services
               %core-services-service))

(define-public default-services-path "/etc/shepherd.d")
