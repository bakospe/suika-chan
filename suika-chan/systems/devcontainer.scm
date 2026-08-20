(define-module (suika-chan systems devcontainer)
  #:use-module (gnu)
  #:use-module (gnu packages commencement)
  #:use-module (gnu services ssh))
(define-public devcontainer-operating-system
  (operating-system
    (host-name "compose")
    (users (cons
      (user-account
        (name "app")
        (group "users"))
      %base-user-accounts))
    (packages (cons
      gcc-toolchain
      %base-packages))
    (services (cons*
      (service openssh-service-type (openssh-configuration
        (port-number 2222)
        (password-authentication? #f)
        (challenge-response-authentication? #f)
        (authorized-keys `(
          ("app" ,(local-file (in-vicinity (getcwd) "authorized_keys")))))))
      (simple-service 'my-session-environment-service session-environment-service-type '(
        ("LD_LIBRARY_PATH" . "/lib64")))
      (extra-special-file "/lib64" "/run/current-system/profile/lib")
      (extra-special-file "/usr/lib64" "/lib64")
      %base-services))
    (file-systems %base-file-systems)
    (bootloader (bootloader-configuration
      (bootloader grub-bootloader)
      (targets '("/dev/null"))))))

