(define-module (suika-chan systems docker-base)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 match)
  #:use-module (gnu)
  #:use-module (gnu services shepherd))
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

