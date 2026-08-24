(define-module (suika-chan services forgejo)
  #:use-module (gnu packages base)
  #:use-module (gnu packages version-control)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system shadow)
  #:use-module (guix gexp)
  #:use-module (suika-chan packages forgejo)
  #:export (forgejo-configuration))
(define %forgejo-user "forgejo")
(define %forgejo-group %forgejo-user)
(define %forgejo-home (string-append "/home/" %forgejo-user))
(define %forgejo-state-dir "/var/lib/forgejo")
(define %forgejo-config-file (string-append %forgejo-state-dir "/custom/conf/app.ini"))
(define-configuration forgejo-configuration
  (server-http-port
    (integer 3000)
    "FORGEJO__server__HTTP_PORT")
  (server-root-url
    string
    "FORGEJO__server__ROOT_URL")
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
      #:environment-variables (list
        (string-append "PATH="
          #$(file-append git "/bin") ":"
          #$(file-append git-lfs "/bin"))
        (string-append "HOME=" #$%forgejo-home)
        (string-append "FORGEJO_WORK_DIR=" #$%forgejo-state-dir))
      #:user #$%forgejo-user
      #:group #$%forgejo-group))
    (stop #~(make-kill-destructor))))
(define (forgejo-activation config)
  #~(begin
      (use-modules (guix build utils))
      (let* (
        (state-dir #$%forgejo-state-dir)
        (config-file #$%forgejo-config-file)
        (config-dir (dirname config-file))
        (user #$%forgejo-user)
        (group #$%forgejo-group)
        (chown #$(file-append coreutils "/bin/chown")))
        (mkdir-p state-dir)
        (invoke chown "-R" (string-append user ":" group) state-dir)
        (mkdir-p config-dir)
        (unless (file-exists? config-file)
          (call-with-output-file config-file
            (lambda (port)
              (format
                port
                "[server]
HTTP_PORT = ~a
ROOT_URL = ~a
"
                #$(forgejo-configuration-server-http-port config)
                #$(forgejo-configuration-server-root-url config)))))
        (invoke chown "-R" (string-append user ":" group) config-dir)
        (chmod config-file #o644))))
(define-public forgejo-service-type
  (service-type
    (name 'forgejo)
    (description "Run Forgejo")
    (extensions (list
      (service-extension account-service-type (const (list
        (user-group
          (name %forgejo-user)
          (system? #t))
        (user-account
          (name %forgejo-user)
          (group %forgejo-group)
          (home-directory %forgejo-home)
          (system? #t)))))
      (service-extension activation-service-type forgejo-activation)
      (service-extension shepherd-root-service-type
        (lambda (config)
          (list (forgejo-shepherd-service config))))))))

