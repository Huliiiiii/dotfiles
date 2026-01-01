(require "helix/keymaps.scm")

(define window-ctl '("A-[" "goto_previous_buffer" "A-]" "goto_next_buffer" "A-w" ":buffer-close"))

(add-global-keybinding (hash "normal" (apply hash window-ctl) "select" (apply hash window-ctl)))
