(define-module (suika-chan systems devcontainer)
  #:use-module (gnu)
  #:use-module (gnu services ssh))
(define-public devcontainer-operating-system
  (operating-system
    (host-name "compose")
    (services (cons
      (service openssh-service-type (openssh-configuration
        (port-number 2222)
        (password-authentication? #f)
        (challenge-response-authentication? #f)
        (permit-root-login #t)
        (authorized-keys `(
          ("root" ,(local-file (in-vicinity (getcwd) "authorized_keys")))))))
      %base-services))
    (file-systems %base-file-systems)
    (bootloader (bootloader-configuration
      (bootloader grub-bootloader)
      (targets '("/dev/null"))))))

