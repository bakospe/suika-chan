(define-module (suika-chan services docker)
  #:use-module (gnu packages docker)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (gnu services shepherd)
  #:use-module (guix gexp)
  #:export (docker-registry-configuration))
(define %docker-registry-state-dir "/var/lib/registry")
(define %docker-registry-config-file "/etc/docker/registry/config.yml")
(define-configuration docker-registry-configuration
  (port
    (integer 5000)
    "Port on which the docker registry should listen.")
  (no-serialization))
(define (docker-registry-shepherd-service config)
  (shepherd-service
    (documentation "Run registry")
    (provision '(docker-registry))
    (requirement '(user-processes))
    (start #~(make-forkexec-constructor
      (list
        #$(file-append docker-registry "/bin/registry")
        "serve"
        #$%docker-registry-config-file)
      #:environment-variables (list
        "REGISTRY_STORAGE=filesystem"
        (string-append
          "REGISTRY_HTTP_ADDR=:"
          (number->string #$(docker-registry-configuration-port config))))))
    (stop #~(make-kill-destructor))))
(define (docker-registry-activation config)
  #~(begin
      (use-modules (guix build utils))
      (let* (
        (state-dir #$%docker-registry-state-dir)
        (config-file #$%docker-registry-config-file))
        (mkdir-p state-dir)
        (mkdir-p (dirname config-file))
        (call-with-output-file config-file
          (lambda (port)
            (display "version: 0.1\n" port)))
        (chmod config-file #o444))))
(define-public docker-registry-service-type
  (service-type
    (name 'docker-registry)
    (description "Run Docker registry")
    (extensions (list
      (service-extension activation-service-type docker-registry-activation)
      (service-extension shepherd-root-service-type
        (lambda (config)
          (list (docker-registry-shepherd-service config))))))))

