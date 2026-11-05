(define-module (suika-chan packages rpc)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix packages)
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
    (native-inputs (list
      python-setuptools))
    (propagated-inputs (list
      python-h2
      python-multidict
      python-protobuf))
    (home-page "https://github.com/vmagamedov/grpclib")
    (synopsis "Pure-Python gRPC implementation for asyncio")
    (description "Pure-Python @code{gRPC} implementation for asyncio.")
    (license #f)))

