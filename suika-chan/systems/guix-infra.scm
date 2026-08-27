(define-module (suika-chan systems guix-infra)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 match)
  #:use-module (gnu)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services ssh))
(define-public docker-base-operating-system
  (operating-system
    (host-name "docker-base")
    (users (cons
      (user-account
        (name "app")
        (group "users"))
      %base-user-accounts))
    (services (cons
      (simple-service 'dummy-networking shepherd-root-service-type (list
        (shepherd-service
          (provision '(networking))
          (start #~(lambda _ #t)))))
      %base-services))
    (essential-services
      (modify-services
        (operating-system-default-essential-services this-operating-system)
        (delete host-name-service-type)
        (etc-service-type files => (remove
          (match-lambda ((name _) (string=? name "hostname")))
          files))))
    (file-systems %base-file-systems)
    (bootloader (bootloader-configuration
      (bootloader grub-bootloader)
      (targets '("/dev/null"))))))
(define-public devcontainer-operating-system
  (operating-system
    (inherit docker-base-operating-system)
    (host-name "devcontainer")
    (packages (cons*
      gcc-toolchain
      git
      openssl
      (operating-system-packages docker-base-operating-system)))
    (services (cons*
      (service openssh-service-type (openssh-configuration
        (port-number 2222)
        (password-authentication? #f)
        (challenge-response-authentication? #f)))
      (simple-service 'my-session-environment-service session-environment-service-type '(
        ("LD_LIBRARY_PATH" . "/lib64")))
      (extra-special-file "/lib64" "/run/current-system/profile/lib")
      (extra-special-file "/usr/lib64" "/lib64")
      (operating-system-user-services docker-base-operating-system)))))
(define-public devcontainer-quick-operating-system
  (operating-system
    (inherit devcontainer-operating-system)
    (packages (cons
      python
      (operating-system-packages devcontainer-operating-system)))))

