(defun insert-mods-name ()
  "Insert <name></name> at cursor point"
  (interactive)
  (insert "<"))

(fset 'grab-name
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([23 19 60 47 116 105 116 108 101 73 110 102 111 62 return return 60 110 97 109 101 32 116 121 112 101 61 34 112 101 114 115 111 110 97 108 34 3 2 60 100 105 115 112 108 97 121 70 111 114 109 3 9 25 5 return 60 114 111 108 101 3 2 60 114 111 108 101 84 101 114 109 32 116 121 112 101 61 34 99 111 100 101 34 32 97 117 116 104 111 114 105 116 121 61 34 109 97 114 99 114 101 108 97 116 111 114 34 3 9 99 114 101] 0 "%d")) arg)))

