(define-module (suika-chan packages spotify)
  #:use-module (gnu packages)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (nonguix build-system chromium-binary)
  #:use-module (suika-chan packages libayatana))
(define-public spotify
  (package
    (name "spotify")
    (version "1.3.4.258.gc60b10b0946a")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_"
        version
        "_amd64.deb"))
      (sha256 (base32 "1r0qnyn4kh3n23s1bnh5csv1wqzgj34rxdk55v405chi3m22gwr0"))))
    (supported-systems '("x86_64-linux"))
    (build-system chromium-binary-build-system)
    (arguments (list
      #:phases #~(modify-phases %standard-phases
        (add-after 'install 'symlink-binary-file
          (lambda _
            (symlink
              (string-append #$output "/usr/bin")
              (string-append #$output "/bin")))))))
    (propagated-inputs (list
      adwaita-icon-theme
      font-dejavu
      font-google-noto
      font-google-noto-emoji
      font-google-noto-sans-cjk
      font-google-noto-sans-hebrew
      gdk-pixbuf
      libayatana-appindicator
      libayatana-ido
      libayatana-indicator
      libdbusmenu))
    (home-page "https://spotify.com/")
    (synopsis "Spotify: Music and Podcasts")
    (description "Spotify for Linux is a labor of love from our engineers that wanted to listen to Spotify on their Linux development machines.")
    (license #f)))

