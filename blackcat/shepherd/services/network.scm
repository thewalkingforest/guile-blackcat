; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd services network)
  #:use-module (shepherd service))

(define-public dhcpcd
  (service
    '(dhcpcd)
    #:start (make-forkexec-constructor
              '("dhcpcd" "-B" "-M"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public network-manager
  (service
    '(network-manager)
    #:requirement '(dbus)
    #:start (make-forkexec-constructor
              '("NetworkManager" "-n"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public openntpd
  (service
    '(openntpd)
    #:requirement '(dns)
    #:start (make-forkexec-constructor
              '("openntpd" "-d"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(define-public sshd-inetd
  (service
    '(sshd-inetd)
    #:requirement '(halt-hook)
    #:start (make-inetd-constructor
              '("sshd" "-D" "-i")
              (list (endpoint (make-socket-address AF_INET INADDR_ANY 22))
                    (endpoint (make-socket-address AF_INET6 IN6ADDR_ANY 22)))
              #:max-connections 10)
    #:stop (make-inetd-destructor)
    #:respawn? #t))

(define-public sshd
  (service
    '(sshd)
    #:start (make-forkexec-constructor
              '("sshd" "-D"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
