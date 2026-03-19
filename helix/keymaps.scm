(require "helix/keymaps.scm")

(define window-ctl '())
(define sub-word-motion-ctl
  '("A-W" "move_next_sub_word_start"
    "A-B" "move_prev_sub_word_start"
    "A-E" "move_next_sub_word_end"))

(add-global-keybinding (hash "normal" (apply hash window-ctl)
                             "select" (apply hash window-ctl)))
(add-global-keybinding (hash "normal" (apply hash sub-word-motion-ctl)
                             "select" (apply hash sub-word-motion-ctl)))

(keymap (global)
        (normal ("[" (b "goto_previous_buffer"))
                ("]" (b "goto_next_buffer"))))
