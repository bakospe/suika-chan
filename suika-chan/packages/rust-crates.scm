(define-module (suika-chan packages rust-crates)
  #:use-module (gnu packages)
  #:use-module (guix build-system cargo)
  #:export (lookup-cargo-inputs))
(define rust-lazy-static-1.5.0
  (crate-source "lazy_static" "1.5.0"
                "1zk6dqqni0193xg6iijh7i3i44sryglwgvx20spdvwk3r6sbrlmv"))

(define rust-libc-0.2.169
  (crate-source "libc" "0.2.169"
                "02m253hs8gw0m1n8iyrsc4n15yzbqwhddi7w1l0ds7i92kdsiaxm"))

(define-cargo-inputs lookup-cargo-inputs
                     (evsieve =>
                              (list rust-lazy-static-1.5.0 rust-libc-0.2.169)))

