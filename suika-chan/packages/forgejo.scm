(define-module (suika-chan packages forgejo)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:))
(define-public forgejo
  (package
    (name "forgejo")
    (version "15.0.6")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://code.forgejo.org/forgejo/forgejo/releases/download/v"
        version
        "/forgejo-"
        version
        "-linux-amd64"))
      (sha256 (base32 "0xccpnka184a4328wq20lbvqhzr76wxzcjklsbydlrxzwhybqqnk"))))
    (build-system trivial-build-system)
    (arguments (list
      #:modules '((guix build utils))
      #:builder #~(begin
        (use-modules ((guix build utils)))
        (let* (
          (bin (string-append (assoc-ref %outputs "out") "/bin"))
          (dest (string-append bin "/forgejo")))
          (mkdir-p bin)
          (copy-file (assoc-ref %build-inputs "source") dest)
          (chmod dest #o555)))))
    (home-page "https://forgejo.org")
    (synopsis "Forgejo - Beyond coding. We forge.")
    (description "Forgejo is a self-hosted lightweight software forge.")
    (license license:gpl3+)))

