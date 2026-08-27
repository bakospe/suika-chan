(define-module (suika-chan systems devcontainer)
  #:use-module (gnu)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (gnu services ssh)
  #:use-module (suika-chan systems docker-base))
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

