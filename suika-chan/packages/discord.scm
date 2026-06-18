(define-module (suika-chan packages discord)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (nonguix build-system chromium-binary))
(define-public discord
  (package
    (name "discord")
    (version "1.0.143")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://stable.dl2.discordapp.net/apps/linux/"
        version
        "/discord-"
        version
        ".deb"))
      (sha256 (base32 "1fpm2l5np808q4cr1z8flkfwpibzc0d08xp3vv36civjvaxl6r26"))))
    (supported-systems '("x86_64-linux"))
    (build-system chromium-binary-build-system)
    (arguments (list
      #:phases #~(modify-phases %standard-phases
        (add-after 'install 'symlink-binary-file
          (lambda _
            (symlink
              (string-append #$output "/usr/share/discord/updater_bootstrap")
              (string-append #$output "/usr/bin/updater_bootstrap"))
            (symlink
              (string-append #$output "/usr/bin")
              (string-append #$output "/bin")))))))
    (home-page "https://discord.com/")
    (synopsis "Discord - Talk, Play, Hang Out")
    (description "Discord is designed for gaming and great for just chilling with friends or building a community.")
    (license #f)))

