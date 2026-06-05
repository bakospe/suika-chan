(define-module (suika-chan packages docker-binary)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:))
(define-public docker-binary
  (package
    (name "docker-binary")
    (version "29.5.3")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://download.docker.com/linux/static/stable/x86_64/docker-"
        version
        ".tgz"))
      (sha256 (base32 "02wkywzixfxq2cccvsfnq9zxc72ndajjf23n3fpzad9lki7advil"))))
    (build-system trivial-build-system)
    (arguments (list
      #:modules '((guix build utils))
      #:builder #~(begin
        (use-modules (guix build utils))
        (let (
          (out (assoc-ref %outputs "out"))
          (source (assoc-ref %build-inputs "source"))
          (tar (string-append (assoc-ref %build-inputs "tar") "/bin/tar"))
          (pigz (string-append (assoc-ref %build-inputs "pigz") "/bin/pigz")))
          (mkdir-p out)
          (invoke tar "-xvf" source "-C" out "-I" pigz)
          (rename-file
            (string-append out "/docker")
            (string-append out "/bin"))))))
    (native-inputs (list
      pigz
      tar))
    (home-page "https://www.docker.com/")
    (synopsis "Docker: Accelerated Container Application Development")
    (description "Includes the containerd, containerd-shim-runc-v2, ctr, docker, dockerd, docker-init, docker-proxy and runc binaries inside /bin.")
    (license license:asl2.0)))

