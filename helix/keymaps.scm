(require "helix/keymaps.scm")

(define window-ctl '("A-w" ":buffer-close"))
(add-global-keybinding (hash "normal" (apply hash window-ctl)
                             "select" (apply hash window-ctl)))

(keymap (global)
        (normal ("[" (b "goto_previous_buffer"))
                ("]" (b "goto_next_buffer"))))

