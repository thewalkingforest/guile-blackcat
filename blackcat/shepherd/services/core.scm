; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd services core)
  #:use-module (shepherd service))

(define-public agetty-tty1
  (service
    '(agetty-tty1)
    #:requirement '(system)
    #:start (make-forkexec-constructor
              '("agetty" "--noclear" "tty1" "38400" "linux"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public agetty-tty2
  (service
    '(agetty-tty2)
    #:requirement '(system)
    #:start (make-forkexec-constructor
              '("agetty" "tty2" "38400" "linux"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public agetty-tty3
  (service
    '(agetty-tty3)
    #:requirement '(system)
    #:start (make-forkexec-constructor
              '("agetty" "tty3" "38400" "linux"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public agetty-tty4
  (service
    '(agetty-tty4)
    #:requirement '(system)
    #:start (make-forkexec-constructor
              '("agetty" "tty4" "38400" "linux"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public agetty-tty5
  (service
    '(agetty-tty5)
    #:requirement '(system)
    #:start (make-forkexec-constructor
              '("agetty" "tty5" "38400" "linux"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public agetty-tty6
  (service
    '(agetty-tty6)
    #:requirement '(system)
    #:start (make-forkexec-constructor
              '("agetty" "tty6" "38400" "linux"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define seedrng
  (service
    '(seedrng)
    #:requirement '(hwclock)
    #:stop (lambda (_sig . _rst)
             (system* "seedrng")
             #f)))

(define hwclock
  (service
    '(hwclock)
    #:requirement '(udevadm)
    #:stop (lambda (_sig . _rst)
             (system* "hwclock" "--systohc")
             #f)))

; (define wtmp
;   (service
;     '(wtmp)
;     #:start (const #t)
;     #:stop (lambda (_sig . _rst)
;              (system "halt -w")
;              #f)))

(define udevadm
  (service
    '(udevadm)
    #:requirement '(pkill)
    #:stop (lambda (_sig . _rst)
             (system* "udevadm" "control" "--exit")
             #f)))

(define pkill
  (service
    '(pkill)
    #:requirement '(filesystems)
    #:stop (lambda (_sig . _rst)
             (system* "pkill" "--inverse" "-s0,1" "-TERM")
             (system* "pkill" "--inverse" "-s0,1" "-KILL")
             #f)))

(define filesystems
  (service
    '(filesystems)
    #:stop (lambda (_sig . _rst)
             (system* "swapoff" "-a")
             (system "umount" "-r" "-a" "-t" "nosysfs,noproc,nodevtmpfs,notmpfs")
             (let* ((env (cons* "LIBMOUNT_FORCE_MOUNT2=always" (environ)))
                    (pid (spawn "mount" '("mount" "-o" "remount,ro" "/") #:environment env)))
               (waitpid pid))
             #f)))

(define halt-hook
  (service
    '(halt-hook)
    #:requirement '(seedrng
                     hwclock
                     udevadm
                     pkill
                     filesystems)))

(define shutdown-services
  '(seedrng
    hwclock
    udevadm
    pkill
    filesystems
    halt-hook))

(register-services shutdown-services)

(register-services (list
  (service
    '(service-autoloader)
    #:requirement '(system)
    #:start (make-forkexec-constructor
              '("service-autoloader"))
    #:stop (make-kill-destructor)
    #:respawn? #t)))

(register-services
  (service
    '(system)))
