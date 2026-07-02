(define-module (suika-chan packages cursor)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (nonguix build-system chromium-binary))
(define-public cursor
  (package
    (name "cursor")
    (version "3.9.16")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://downloads.cursor.com/production/"
        "042b3c1a4c53f2c3808067f519fbfc67b72cad8b"
        "/linux/x64/deb/amd64/deb/cursor_"
        version
        "_amd64.deb"))
      (sha256 (base32 "17rmans6z0rclzs57vp2xbqy80dw97y7ksfv0i4xplr75nnvhpj6"))))
    (supported-systems '("x86_64-linux"))
    (build-system chromium-binary-build-system)
    (arguments (list
      #:validate-runpath? #f
      #:phases #~(modify-phases %standard-phases
        (add-after 'install 'symlink-binary-file
          (lambda _
            (mkdir-p (string-append #$output "/bin"))
            (symlink
              (string-append #$output "/usr/share/cursor/cursor")
              (string-append #$output "/bin/cursor")))))))
    (home-page "https://cursor.com/")
    (synopsis "Cursor: The best coding agent")
    (description "Built to make you extraordinarily productive, Cursor is the best coding agent.")
    (license #f)))

