(define-module (suika-chan packages spotify)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (nonguix build-system chromium-binary))
(define-public spotify
  (package
    (name "spotify")
    (version "1.2.92.147.g5b8f9367")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_"
        version
        "_amd64.deb"))
      (sha256 (base32 "01g11cg3i2gkqa5v2nrmjp01w3y4fvzha6rdwlzsz52syladw0qr"))))
    (supported-systems '("x86_64-linux"))
    (build-system chromium-binary-build-system)
    (arguments (list
      #:phases #~(modify-phases %standard-phases
        (add-after 'install 'symlink-binary-file
          (lambda _
            (symlink
              (string-append #$output "/usr/bin")
              (string-append #$output "/bin")))))))
    (home-page "https://spotify.com/")
    (synopsis "Spotify: Music and Podcasts")
    (description "Spotify for Linux is a labor of love from our engineers that wanted to listen to Spotify on their Linux development machines.")
    (license #f)))

