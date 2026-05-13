; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd defaults)
  #:export (default-services-path
            %core-services))

(define default-services-path "/etc/shepherd.d")

(define %core-services
  '(seedrng
    hwclock
    udevadm
    pkill
    filesystems
    halt-hook
    system
    agetty-tty1
    agetty-tty2
    agetty-tty3
    agetty-tty4
    agetty-tty5
    agetty-tty6
    service-autoloader))
