# Suika-chan
Guix channel providing extra programs.

## How to use this channel

Add the following snippet to your `~/.config/guix/channels.scm`:

```scheme
(channel
  (name 'suika-chan)
  (url "https://github.com/bakospe/suika-chan")
  (introduction (make-channel-introduction
    "4fcf5db3febed45b8b293ac889e58883b7a91a7f"
    (openpgp-fingerprint "E533 7D23 B733 322A 564B  F230 5205 A230 36D0 8959"))))
```

