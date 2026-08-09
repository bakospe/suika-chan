(define-module (suika-chan services forgejo)
  #:use-module (gnu packages version-control)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system shadow)
  #:use-module (guix gexp)
  #:use-module (suika-chan packages forgejo)
  #:export (forgejo-configuration))
(define %forgejo-home "/home/forgejo")
(define %forgejo-state-dir "/var/lib/forgejo")
(define-configuration forgejo-configuration
  (environment-variables
    (list '())
    "Env vars seen by the Forgejo web process")
  (no-serialization))
(define (forgejo-shepherd-service config)
  (shepherd-service
    (documentation "Run forgejo web")
    (provision '(forgejo-web))
    (requirement '(user-processes))
    (start #~(make-forkexec-constructor
      (list
        #$(file-append forgejo "/bin/forgejo")
        "web")
      #:environment-variables (cons*
        (string-append "PATH="
          #$(file-append git "/bin") ":"
          #$(file-append git-lfs "/bin"))
        (string-append "HOME=" #$%forgejo-home)
        (string-append "FORGEJO_WORK_DIR=" #$%forgejo-state-dir)
        (list #$@(forgejo-configuration-environment-variables config)))
      #:user "forgejo"
      #:group "forgejo"))
    (stop #~(make-kill-destructor))))
(define (forgejo-activation config)
  #~(begin
      (use-modules (guix build utils))
      (let (
        (dir #$%forgejo-state-dir)
        (user (getpwnam "forgejo")))
        (mkdir-p dir)
        (chown dir (passwd:uid user) (passwd:gid user)))))
(define-public forgejo-service-type
  (service-type
    (name 'forgejo)
    (description "Run Forgejo")
    (extensions (list
      (service-extension account-service-type (const (list
        (user-group
          (name "forgejo")
          (system? #t))
        (user-account
          (name "forgejo")
          (group "forgejo")
          (home-directory %forgejo-home)
          (system? #t)))))
      (service-extension activation-service-type forgejo-activation)
      (service-extension shepherd-root-service-type
        (lambda (config)
          (list (forgejo-shepherd-service config))))))
    (default-value (forgejo-configuration))))

