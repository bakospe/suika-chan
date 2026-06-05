(define-module (suika-chan services docker-binary)
  #:use-module (gnu packages linux)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system shadow)
  #:use-module (guix gexp)
  #:use-module (suika-chan packages docker-binary)
  #:export (docker-binary-service-type))
(define docker-binary-shepherd-service
  (shepherd-service
    (documentation "Docker daemon (binary).")
    (provision '(dockerd-binary))
    (requirement '(
      dbus-system
      elogind
      file-system-/sys/fs/cgroup
      networking
      udev
      user-processes))
    (start #~(make-forkexec-constructor
      (list (string-append #$docker-binary "/bin/dockerd"))
      #:environment-variables (list
        (string-append "PATH="
          #$docker-binary "/bin:"
          #$iptables "/sbin"))
      #:pid-file "/var/run/docker.pid"
      #:log-file "/var/log/docker.log"))
    (stop #~(make-kill-destructor))))
(define docker-binary-service-type
  (service-type
    (name 'docker-binary)
    (description "Provide capability to run Docker application bundles in Docker containers (binary).")
    (extensions (list
      (service-extension profile-service-type (const (list docker-binary)))
      (service-extension shepherd-root-service-type (const (list docker-binary-shepherd-service)))
      (service-extension account-service-type (const (list
        (user-group
          (name "docker")
          (system? #t)))))))
    (default-value #f)))

