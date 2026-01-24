(define-module (blackcat shepherd-utils)
  #:use-module (blackcat utils)
  #:export (setup-dir))

(define* (setup-dir path mode uid' #:optional (gid' uid'))
  "Ensure directory exists at PATH with MODE and owned by UID:GID"
  (let ((uid (getuid uid'))
        (gid (getgid gid')))
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
