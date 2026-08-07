(define-module (suika-chan packages python-yt-dlp)
  #:use-module (gnu packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages tls)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system pyproject))
(define-public python-yt-dlp
  (package
    (name "python-yt-dlp")
    (version "2026.7.4")
    (source (origin
      (method url-fetch)
      (uri (pypi-uri "yt_dlp" version))
      (sha256 (base32 "0cj43b9b4fvvh07vw0slibyyacnz6598203g3399sypq0hs8355h"))))
    (build-system pyproject-build-system)
    (arguments (list #:tests? #f))
    (native-inputs (list
      python-autopep8
      python-hatchling
      python-pytest
      python-pytest-rerunfailures))
    (propagated-inputs (list
      nss-certs
      openssl))
    (home-page #f)
    (synopsis "A feature-rich command-line audio/video downloader")
    (description "This package provides a feature-rich command-line audio/video downloader.")
    (license #f)))

