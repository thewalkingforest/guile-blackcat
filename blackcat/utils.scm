(define-module (blackcat utils)
  #:export (getuid getgid))

(define (getuid unam)
  "Get the uid number from the user's name or passes through user's numeric id"
  (cond
    ((string? unam) (passwd:uid (getpwnam unam)))
    ((integer? unam) (inexact->exact (truncate unam)))
    (else #f)))

(define (getgid gnam)
  "Get the gid number from the group's name or passes through group's numeric id"
  (cond
    ((string? gnam) (group:gid (getgrnam gnam)))
    ((integer? gnam) (inexact->exact (truncate gnam)))
    (else #f)))
