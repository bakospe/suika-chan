(define-module (suika-chan packages evsieve)
  #:use-module (gnu packages)
  #:use-module (gnu packages xorg)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module ((guix licenses) #:prefix license:))
(define-public evsieve
  (package
    (name "evsieve")
    (version "v1.4.0")
    (source (origin
      (method git-fetch)
      (uri (git-reference
        (url "https://github.com/KarsMulder/evsieve.git")
        (commit version)))
      (sha256 (base32 "1n4p9lbc6jkqksb9ylrd6vz59y3n8b82809szja41dl577q6cpji"))))
    (build-system cargo-build-system)
    (arguments (list
      #:tests? #f))
    (inputs (cons*
      libevdev
      (cargo-inputs 'evsieve #:module '(suika-chan packages rust-crates))))
    (home-page "https://github.com/KarsMulder/evsieve")
    (synopsis "evsieve: A utility for mapping events from Linux event devices")
    (description "Evsieve (from \"event sieve\") is a low-level utility that can read events from Linux event devices (evdev) and write them to virtual event devices (uinput), performing simple manipulations on the events along the way.")
    (license license:gpl2)))

