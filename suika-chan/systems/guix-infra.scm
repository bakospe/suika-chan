(define-module (suika-chan systems guix-infra)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 match)
  #:use-module (gnu)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages python)
  #:use-module (gnu packages rsync)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages version-control)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services ssh)
  #:use-module (gnu machine hetzner)
  #:use-module (guix gexp)
  #:use-module (suika-chan packages guix-infra)
  #:use-module (suika-chan services docker-binary))
(define-public (make-base-vps-operating-system hetzner-server-type)
  (let ((base-operating-system (make-hetzner-os hetzner-server-type)))
    (operating-system
      (inherit base-operating-system)
      (host-name "base-vps")
      (users (cons
        (user-account
          (name "app")
          (group "users")
          (supplementary-groups '(
            "docker")))
        (operating-system-users base-operating-system)))
      (sudoers-file (plain-file
        "sudoers"
        (string-append
          (plain-file-content %sudoers-specification)
          "app ALL=(ALL) NOPASSWD: ALL\n")))
      (packages (cons*
        curl
        fastfetch-minimal
        git
        gnupg
        guix-infra
        htop
        iptables
        nano
        pigz
        rsync
        tmux
        (operating-system-packages base-operating-system)))
      (services (cons*
        (service docker-binary-service-type)
        (simple-service 'my-base-service shepherd-root-service-type (list
          (shepherd-service
            (provision '(firewall-configurator))
            (one-shot? #t)
            (start #~(lambda ()
              (system (string-append
                "PATH=\"/run/current-system/profile/sbin\" && "
                "iptables -P INPUT DROP && "
                "iptables -P FORWARD DROP && "
                "iptables -A INPUT -p tcp --dport 22 -j ACCEPT && "
                "iptables -A INPUT -p icmp -j ACCEPT && "
                "iptables -A INPUT -i lo -j ACCEPT && "
                "iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT"))
              #t)))))
        (extra-special-file
          "/home/app/.gnupg/gpg.conf"
          (plain-file
            "gpg.conf"
            "pinentry-mode loopback\nno-symkey-cache\n"))
        (modify-services (operating-system-user-services base-operating-system)
          (openssh-service-type
            config => (openssh-configuration
              (inherit config)
              (password-authentication? #f)
              (challenge-response-authentication? #f))))))
      (file-systems (append
        (list
          (file-system
            (mount-point "/home/app/stuff")
            (device (string-append "/dev/disk/by-id/" (or (getenv "STUFF_DISK_ID") "")))
            (type "ext4")
            (mount-may-fail? #t))
          (file-system
            (mount-point "/var/lib/docker")
            (device (string-append "/dev/disk/by-id/" (or (getenv "DOCKER_DISK_ID") "")))
            (type "ext4")
            (mount-may-fail? #t)))
        %control-groups
        (operating-system-file-systems base-operating-system))))))
(define-public docker-base-operating-system
  (operating-system
    (initrd-modules '())
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

