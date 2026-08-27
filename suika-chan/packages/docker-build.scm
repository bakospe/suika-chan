(define-module (suika-chan packages docker-build)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system trivial))
(define-public docker-build
  (package
    (name "docker-build")
    (version "0.0.1")
    (source #f)
    (build-system trivial-build-system)
    (arguments (list
      #:modules '((guix build utils))
      #:builder #~(begin
        (use-modules (guix build utils))
        (let* (
          (out (assoc-ref %outputs "out"))
          (target (string-append out "/bin"))
          (dest (string-append target "/docker-build")))
          (mkdir-p target)
          (call-with-output-file dest
            (lambda (port)
              (display
                "#!/usr/bin/env bash
set -xe
if [ $# -eq 0 ]; then
    exit 1
fi
DOCKER_TAG=\"$1\"
if [ $# -eq 1 ]; then
    SYSTEM_FILEPATH=container.scm
else
    SYSTEM_FILEPATH=\"$2\"
fi
DOCKER_IMAGE_TARBALL_FILEPATH=$(guix system image -t docker \"${@:3}\" \"$SYSTEM_FILEPATH\")
docker load -i \"$DOCKER_IMAGE_TARBALL_FILEPATH\"
docker tag guix:latest \"$DOCKER_TAG\"
guix gc -D \"$DOCKER_IMAGE_TARBALL_FILEPATH\"
"
                port)))
          (chmod dest #o555)))))
    (home-page #f)
    (synopsis "Docker Build")
    (description "Build Docker images without docker build.")
    (license #f)))

