(defparameter *alphabet*
  "aaaaaaaaaa@@łłµµæſðæðđŋſđħ€¶ŧł←ŧþ€¶đðøħðđ«„↓ſð„↓ſð↓ŋſ↓ðaabbbbbbbbbbbbccccccccccccdddddddddabcabcabababcdabab")

(defparameter *such* "abcd")


(if (third *posix-argv*)
  (setf *alphabet* (make-string-input-stream (third *posix-argv*)))
  (setf *alphabet* *standard-input*))

(if (second *posix-argv*)
  (setf *such* (second *posix-argv*)))


(defmacro timing (&body forms)
  (let ((real1 (gensym))
        (real2 (gensym))
        (run1 (gensym))
        (run2 (gensym))
        (result (gensym)))
    `(let* ((,real1 (get-internal-real-time))
            (,run1 (get-internal-run-time))
            (,result (progn ,@forms))
            (,run2 (get-internal-run-time))
            (,real2 (get-internal-real-time)))
       (format *debug-io* ";;; Computation took:~%")
       (format *debug-io* ";;;  ~f seconds of real time~%"
               (/ (- ,real2 ,real1) internal-time-units-per-second))
       (format t ";;;  ~f seconds of run time~%~%"
               (/ (- ,run2 ,run1) internal-time-units-per-second))
       ,result)))

(let ((anzahl 0))

  (defun get-anzahl ()
    (let ((anz anzahl))
      (setf anzahl 0)
      anz))

  (defun file-access (f-stream pos &optional (seek 0)  &key (do-count t))
    (let ((ret nil))
      (file-position f-stream (+ pos seek))
      (if (listen f-stream)
        (progn 
          (incf anzahl)
          (setf ret (read-char f-stream))))
      ret)
    )
  )


(defun file-access-peek (f-stream pos)
  (file-position f-stream pos)
  (listen f-stream)
  )


(defun file-reset (f-stream)
  (if (streamp f-stream)
    (file-position f-stream 0)))

(defun get_map (gesamt
                 such
                 &key
                 (next-i (lambda (I J) (+ i 1)))
                 (next-j (lambda (I J) 0)))
  (let* ((m (length such))
         (ret 
           (loop
             with i = 0
             while (file-access-peek gesamt i)
             with j = 0
             do
             (loop
               while (< j m)
               while (eq (aref such j) (file-access gesamt i j))
               do (incf j)
               )
             when (= j m) collect i
             do (setf i (funcall next-i i j))
             do (setf j (funcall next-j i j))
             ;do (format t "i= ~A j= ~A~%" i j)
             )
           ))
    (file-reset gesamt)
    ret
    ))
