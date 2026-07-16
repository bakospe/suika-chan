(define-module (suika-chan packages python-modal)
  #:use-module (gnu packages)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system pyproject))
(define-public python-grpclib
  (package
    (name "python-grpclib")
    (version "0.4.9")
    (source (origin
      (method git-fetch)
      (uri (git-reference
        (url "https://github.com/vmagamedov/grpclib")
        (commit (string-append "v" version))))
      (file-name (git-file-name name version))
      (sha256 (base32 "1m6n0hz14ik4l7ks5jzwv1x6ac3s15v02x8mia51zq1wplh44jgl"))))
    (build-system pyproject-build-system)
    (arguments (list #:tests? #f))
    (propagated-inputs (list
      python-h2
      python-multidict
      python-protobuf))
    (native-inputs (list
      python-setuptools))
    (home-page "https://github.com/vmagamedov/grpclib")
    (synopsis "Pure-Python gRPC implementation for asyncio")
    (description "Pure-Python @code{gRPC} implementation for asyncio.")
    (license #f)))
(define-public python-synchronicity
  (package
    (name "python-synchronicity")
    (version "0.12.5")
    (source (origin
      (method url-fetch)
      (uri (pypi-uri "synchronicity" version))
      (sha256 (base32 "1aihwbpqalzbppx7gn57wj26bbs91663nybap5b313k9hlfnpncl"))))
    (build-system pyproject-build-system)
    (arguments (list #:tests? #f))
    (propagated-inputs (list
      python-typing-extensions))
    (native-inputs (list
      python-hatchling))
    (home-page #f)
    (synopsis "Export blocking and async library versions from a single async implementation")
    (description "Export blocking and async library versions from a single async implementation.")
    (license #f)))
(define-public python-types-certifi
  (package
    (name "python-types-certifi")
    (version "2021.10.8.3")
    (source (origin
      (method url-fetch)
      (uri (pypi-uri "types-certifi" version))
      (sha256 (base32 "0ksaan5yha5r4d2nc7f288y0diwp63md23f1w5v0pg35s6c7gkvj"))))
    (build-system pyproject-build-system)
    (arguments (list #:tests? #f))
    (native-inputs (list
      python-setuptools))
    (home-page "https://github.com/python/typeshed")
    (synopsis "Typing stubs for certifi")
    (description "Typing stubs for certifi.")
    (license #f)))
(define-public python-modal
  (package
    (name "python-modal")
    (version "1.5.2")
    (source (origin
      (method url-fetch)
      (uri (pypi-uri "modal" version))
      (sha256 (base32 "12h0q19pikbl15slqdzia4vpmwvm9m00cn9qah6bib6cxj1jj3dc"))))
    (build-system pyproject-build-system)
    (arguments (list #:tests? #f))
    (propagated-inputs (list
      python-aiohttp
      python-cbor2
      python-certifi
      python-click
      python-grpclib
      python-protobuf
      python-rich
      python-synchronicity
      python-toml
      python-types-certifi
      python-types-toml
      python-typing-extensions
      python-watchfiles))
    (native-inputs (list
      python-setuptools))
    (home-page "https://modal.com")
    (synopsis "Python client library for Modal")
    (description "Python client library for Modal.")
    (license #f)))

