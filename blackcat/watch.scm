;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat watch)
  #:use-module (blackcat inotify)
  #:use-module (ice-9 optargs))

(define*-public (watch-directories dirs callback #:optional (events '(create delete modify moved-from moved-to)))
  (let ((inotify (make-inotify)))
    (for-each (lambda (dir) (inotify-add-watch! inotify dir events)) dirs)
    (let loop ()
      (let ((event (inotify-read-event inotify)))
        (callback (inotify-event-type event)
                  (inotify-event-file-name event)
                  (inotify-watch-file-name (inotify-event-watch event))))
      (loop))))

(define*-public (watch-directory dir callback #:optional (events '(create delete modify moved-from moved-to)))
  (watch-directories (list dir)
                     (lambda (type name dir) (callback type name))
                     events))
