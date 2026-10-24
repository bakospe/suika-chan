
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
    (source
     (origin
       (method url-fetch)
       (uri
        (string-append
         "https://repository-origin.spotify.com/pool/non-free/s/"
         "spotify-client/spotify-client_"
         version
         "_amd64.deb"))
       (sha256
        (base32
         "1r0qnyn4kh3n23s1bnh5csv1wqzgj34rxdk55v405chi3m22gwr0"))))
    (supported-systems '("x86_64-linux"))
    (build-system chromium-binary-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases

          ;; Preserve the original binary symlink.
          (add-after 'install 'symlink-binary-file
            (lambda _
              (symlink
               (string-append #$output "/usr/bin")
               (string-append #$output "/bin"))))

          ;; Install the desktop entry and icons in standard locations.
          (add-after 'symlink-binary-file 'install-desktop-entry
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (source
                      (string-append
                       out "/usr/share/spotify/spotify.desktop"))
                     (directory
                      (string-append out "/share/applications"))
                     (desktop
                      (string-append directory "/spotify.desktop"))
                     (icons
                      (string-append
                       out "/usr/share/spotify/icons")))

                (unless (file-exists? source)
                  (error "Spotify desktop entry not found:" source))

                (mkdir-p directory)
                (copy-file source desktop)

                ;; Ensure paths and line endings are correct.
                (substitute* desktop
                  (("^Exec=.*")
                   (string-append
                    "Exec=" out "/bin/spotify --uri=%u\n"))
                  (("^TryExec=.*")
                   (string-append
                    "TryExec=" out "/bin/spotify\n"))
                  (("^Icon=.*")
                   "Icon=spotify\n"))

                ;; Install icons into the hicolor icon theme.
                (for-each
                 (lambda (size)
                   (let ((icon-source
                          (string-append
                           icons "/spotify-linux-" size ".png"))
                         (icon-directory
                          (string-append
                           out "/share/icons/hicolor/"
                           size "x" size "/apps")))
                     (unless (file-exists? icon-source)
                       (error "Spotify icon not found:" icon-source))
                     (mkdir-p icon-directory)
                     (copy-file
                      icon-source
                      (string-append icon-directory "/spotify.png"))))
                 '("22" "24" "32" "48" "64" "128" "256" "512"))

                #t)))

          ;; Point Spotify at the dynamic loader provided by Guix.
          (add-after 'install-desktop-entry 'patch-spotify-interpreter
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (binary
                      (string-append out "/usr/share/spotify/spotify"))
                     (libc (assoc-ref inputs "libc"))
                     (loaders
                      (find-files libc "ld-linux.*\\.so")))
                (unless (file-exists? binary)
                  (error "Spotify binary not found:" binary))
                (unless (pair? loaders)
                  (error "Could not find Guix dynamic loader in libc"))
                (make-file-writable binary)
                (invoke "patchelf"
                        "--set-interpreter"
                        (car loaders)
                        binary)
                (format #t "Patched Spotify interpreter: ~a~%"
                        (car loaders))
                #t))))))

    (propagated-inputs
     (list
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
    (description
     "Spotify for Linux is a labor of love from our engineers that wanted
to listen to Spotify on their Linux development machines.")
    (license #f)))

