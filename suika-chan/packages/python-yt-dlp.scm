(define-module (suika-chan packages python-yt-dlp)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system pyproject))
(define-public python-yt-dlp
  (package
    (name "python-yt-dlp")
    (version "2026.3.17")
    (source (origin
      (method url-fetch)
      (uri (pypi-uri "yt_dlp" version))
      (sha256 (base32 "1jfjaz0dxndpb2v6pp4q2fzz13yasyb1ahhfwz7zq7rzacfs6yms"))))
    (build-system pyproject-build-system)
    (arguments (list #:tests? #f))
    (native-inputs (list
      python-autopep8
      python-hatchling
      python-pytest
      python-pytest-rerunfailures))
    (home-page #f)
    (synopsis "A feature-rich command-line audio/video downloader")
    (description "This package provides a feature-rich command-line audio/video downloader.")
    (license #f)))

