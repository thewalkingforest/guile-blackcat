; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat watch)
  #:use-module (blackcat inotify)
  #:export (watch-directory))

(define* (watch-directory dir callback #:optional (events '(create delete modify moved-from moved-to)))
  (let ((inotify (make-inotify)))
    (inotify-add-watch! inotify dir events)
    (let loop ()
      (when (inotify-pending-events? inotify)
        (let ((event (inotify-read-event inotify)))
          (callback (inotify-event-type event)
                    (inotify-event-file-name event))))
      (loop))))
