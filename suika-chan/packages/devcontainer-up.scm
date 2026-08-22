(define-module (suika-chan packages devcontainer-up)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system trivial))
(define-public devcontainer-up
  (package
    (name "devcontainer-up")
    (version "0.0.2")
    (source #f)
    (build-system trivial-build-system)
    (arguments (list
      #:modules '((guix build utils))
      #:builder #~(begin
        (use-modules (guix build utils))
        (let* (
          (out (assoc-ref %outputs "out"))
          (target (string-append out "/bin"))
          (misc-target (string-append out "/usr/share/devcontainer-up"))
          (dest (string-append target "/devcontainer-up"))
          (quick-dest (string-append misc-target "/devcontainer-quick.scm")))
          (mkdir-p target)
          (mkdir-p misc-target)
          (call-with-output-file quick-dest
            (lambda (port)
              (display
                "(use-modules
  (gnu)
  (gnu packages python)
  (suika-chan systems devcontainer))
(operating-system
  (inherit devcontainer-operating-system)
  (packages (cons
    python
    (operating-system-packages devcontainer-operating-system))))
"
                port)))
          (chmod quick-dest #o444)
          (call-with-output-file dest
            (lambda (port)
              (display
                (string-append
                  "#!/usr/bin/env bash
set -xe
export DEVCONTAINER_SSH_PORT=$PORT
if [ $# -gt 0 ]; then
    QUICK_MODE=0
else
    QUICK_MODE=1
fi
if [ $QUICK_MODE -eq 0 ]; then
    VSCODE_SERVER_DIR_PATH=$(pwd)/.vscode-server
    WORKSPACE_DIR_HOST_PATH=$(pwd)
    WORKSPACE_DIR_GUEST_PATH=/home/app/stuff/dev/$(basename $WORKSPACE_DIR_HOST_PATH)
else
    VSCODE_SERVER_DIR_PATH=$HOME/.vscode-server
    WORKSPACE_DIR_HOST_PATH=$HOME/stuff/dev
    WORKSPACE_DIR_GUEST_PATH=/home/app/stuff/dev
fi
mkdir -p $VSCODE_SERVER_DIR_PATH
mkdir -p $WORKSPACE_DIR_HOST_PATH
if [ ! -e ~/.gitconfig ]; then
    touch ~/.gitconfig
fi
if [ ! -e ~/.git-credentials ]; then
    touch ~/.git-credentials
fi
exec sudo $(guix system container \\
    --network \\
    --expose=/etc/ssh/ssh_host_ed25519_key \\
    --expose=$HOME/.gitconfig=/home/app/.gitconfig \\
    --expose=$HOME/.git-credentials=/home/app/.git-credentials \\
    --share=$VSCODE_SERVER_DIR_PATH=/home/app/.vscode-server \\
    --share=$WORKSPACE_DIR_HOST_PATH=$WORKSPACE_DIR_GUEST_PATH \\
    \"$@\" \\
    $(if [ $QUICK_MODE -eq 1 ]; then echo " quick-dest "; fi))
")
                port)))
          (chmod dest #o555)))))
    (home-page #f)
    (synopsis "DevContainer Up")
    (description "Start devcontainers without boilerplate.")
    (license #f)))

