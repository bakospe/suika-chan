(define-module (suika-chan packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:))
(define-public libayatana-ido
  (package
    (name "libayatana-ido")
    (version "0.10.4")
    (source (origin
      (method git-fetch)
      (uri (git-reference
        (url "https://github.com/AyatanaIndicators/ayatana-ido.git")
        (commit version)))
      (sha256 (base32 "1li6pzh9xvl66nlixzpwqsn8aaa0kj0azhzjan4cd65f7nnjpq99"))))
    (build-system cmake-build-system)
    (arguments (list
      #:tests? #f))
    (native-inputs (list
      gtk+
      pkg-config
      (list glib "bin")))
    (home-page "https://github.com/AyatanaIndicators/ayatana-ido")
    (synopsis "Ayatana Indicator Display Objects")
    (description "Ayatana IDO provides custom GTK menu widgets for Ayatana System Indicators.")
    (license license:gpl3)))
(define-public libayatana-indicator
  (package
    (name "libayatana-indicator")
    (version "0.9.5")
    (source (origin
      (method git-fetch)
      (uri (git-reference
        (url "https://github.com/AyatanaIndicators/libayatana-indicator.git")
        (commit version)))
      (sha256 (base32 "08n4fjnc1cbjynqb3r6vik994yl6wbgi7q6p0h19xwrxx94lixym"))))
    (build-system cmake-build-system)
    (arguments (list
      #:validate-runpath? #f
      #:tests? #f))
    (native-inputs (list
      gtk+
      libayatana-ido
      pkg-config
      (list glib "bin")))
    (home-page "https://github.com/AyatanaIndicators/libayatana-indicator")
    (synopsis "Ayatana Indicators Shared Library")
    (description "Ayatana Indicators Shared Library")
    (license license:gpl3)))
(define-public libayatana-appindicator
  (package
    (name "libayatana-appindicator")
    (version "0.6.0")
    (source (origin
      (method git-fetch)
      (uri (git-reference
        (url "https://github.com/AyatanaIndicators/libayatana-appindicator.git")
        (commit version)))
      (sha256 (base32 "0j28gl3hkl3iparp2dai819cspgqx6apshb7w897kmbwnyzy7akh"))))
    (build-system cmake-build-system)
    (arguments (list
      #:configure-flags #~(list
        "-DENABLE_BINDINGS_MONO=OFF")
      #:tests? #f))
    (native-inputs (list
      gobject-introspection
      gtk+
      libayatana-ido
      libayatana-indicator
      libdbusmenu
      pkg-config
      vala
      (list glib "bin")))
    (home-page "https://github.com/AyatanaIndicators/libayatana-appindicator")
    (synopsis "Ayatana Application Indicator (Shared Library)")
    (description "A library to allow applications to export a menu into the an Application Indicators aware menu bar.")
    (license license:lgpl3)))
(define-public xdg-open-hack
  (package
    (name "xdg-open-hack")
    (version "0.0.1")
    (source #f)
    (build-system trivial-build-system)
    (arguments (list
      #:modules '((guix build utils))
      #:builder #~(begin
        (use-modules (guix build utils))
        (let* (
          (out (assoc-ref %outputs "out"))
          (target (string-append out "/bin"))
          (dest (string-append target "/xdg-open")))
          (mkdir-p target)
          (call-with-output-file dest
            (lambda (port)
              (display
                "#!/bin/sh
echo \"$1\"
echo \"$1\" >&2
echo \"$1\" >> /tmp/link.txt
"
                port)))
          (chmod dest #o555)
          (symlink dest (string-append target "/firefox"))
          (symlink dest (string-append target "/chromium"))))))
    (home-page #f)
    (synopsis "XDG Open Hack")
    (description "Adding this package into guix shell will result in links programs wish to open in a browser being logged to /tmp/link.txt (which then in turn can be shared with the host).")
    (license #f)))

