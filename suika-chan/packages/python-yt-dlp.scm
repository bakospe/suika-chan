(define-module (suika-chan packages python-yt-dlp)
  #:use-module (gnu packages)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages video)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system pyproject))
(define-public python-yt-dlp
  (package
    (name "python-yt-dlp")
    (version "2026.8.19")
    (source (origin
      (method url-fetch)
      (uri (pypi-uri "yt_dlp" version))
      (sha256 (base32 "1w8a9rpwh3h7syva5053bwm3kxhqy41pji74g2rncp53rr43w8cy"))))
    (build-system pyproject-build-system)
    (arguments (list #:tests? #f))
    (native-inputs (list
      python-hatchling))
    (propagated-inputs (list
      ffmpeg
      nss-certs
      openssl))
    (home-page #f)
    (synopsis "A feature-rich command-line audio/video downloader")
    (description "This package provides a feature-rich command-line audio/video downloader.")
    (license #f)))

