(define-module (suika-chan packages guix-infra)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:))
(define-public guix-infra
  (package
    (name "guix-infra")
    (version "0.0.2")
    (source (origin
      (method git-fetch)
      (uri (git-reference
        (url "https://github.com/SecondCosmicV/guix-infra.git")
        (commit version)))
      (sha256 (base32 "1qc4fm6m3v97ixz559hdl1zyg35zcykmrc1m3rlb774hhbdgnk9h"))))
    (build-system trivial-build-system)
    (arguments (list
      #:modules '((guix build utils))
      #:builder #~(begin
        (use-modules (guix build utils))
        (let* (
          (source (assoc-ref %build-inputs "source"))
          (out (assoc-ref %outputs "out"))
          (src (string-append source "/src"))
          (bin (string-append out "/bin")))
          (copy-recursively src bin)))))
    (home-page "https://github.com/SecondCosmicV/guix-infra")
    (synopsis "Guix-infra")
    (description "CI/CD Guix scripts.")
    (license license:agpl3)))

