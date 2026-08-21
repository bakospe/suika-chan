(define-module (suika-chan packages devcontainer-up)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system trivial))
(define-public devcontainer-up
  (package
    (name "devcontainer-up")
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
          (dest (string-append target "/devcontainer-up")))
          (mkdir-p target)
          (call-with-output-file dest
            (lambda (port)
              (display
                "#!/usr/bin/env bash
set -xe
mkdir -p .vscode-server
if [ ! -e ~/.gitconfig ]; then
    touch ~/.gitconfig
fi
if [ ! -e ~/.git-credentials ]; then
    touch ~/.git-credentials
fi
exec sudo $(guix system container \
    --network \
    --expose=/etc/ssh/ssh_host_ed25519_key \
    --expose=$HOME/.gitconfig=/home/app/.gitconfig \
    --expose=$HOME/.git-credentials=/home/app/.git-credentials \
    --share=$(pwd)/.vscode-server=/home/app/.vscode-server \
    --share=$(pwd)=/home/app/stuff/dev/$(basename $(pwd)) \
    \"$@\")
"
                port)))
          (chmod dest #o555)))))
    (home-page #f)
    (synopsis "DevContainer Up")
    (description "Start devcontainers without boilerplate.")
    (license #f)))

