; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat)
  #:use-module (blackcat config)
  #:use-module (blackcat watch)
  #:use-module (blackcat inotify)
  #:use-module (blackcat shepherd)
  #:use-module (blackcat scripts hello)
  #:use-module (blackcat scripts service-watcher)
  #:use-module (blackcat shepherd utils)
  #:use-module (blackcat shepherd defaults)
  #:re-export (%blackcat-version))
