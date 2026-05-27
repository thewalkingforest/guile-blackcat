; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at https://mozilla.org/MPL/2.0/.

(define-module (blackcat shepherd defaults)
  #:use-module (blackcat shepherd services core))

(define-public default-services-path "/etc/shepherd.d")

(define-public %core-services
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
    agetty-tty6))

(define-public %core-services-service
  (list
    seedrng-service
    hwclock-service
    udevadm-service
    pkill-service
    filesystems-service
    halt-hook-service
    system-service
    agetty-tty1-service
    agetty-tty2-service
    agetty-tty3-service
    agetty-tty4-service
    agetty-tty5-service
    agetty-tty6-service))
