(load "lib.lisp")

(defun schiebe (alphabet such)
  (get_map alphabet such))

(defun last-occ (such)
  (let ((m (length such)))
    (remove-duplicates 
      (loop
        for i from 0 to (- m 2)
        for p = (position (aref such i) such :from-end t :end (- m 1))
        collect (list (aref such i) (if (null p) m (- m p 1)))) :test #'equal)))

(defparameter *occ* (last-occ *such*))

(defun get-from-occ (occ buchstabe default-ret)
  (cond 
    ((null occ) default-ret)
    ((eq buchstabe (car (car occ))) (second (car occ)))
    (t (get-from-occ (cdr occ) buchstabe default-ret))))


(defun schiebe-last-occ (alphabet such occ)
  (let ((m (length such)))
    (get_map alphabet such
             :next-i (lambda (I J)
                       ;(format t "i= ~A j= ~A~%" I J)
                       ;(format t "buchstabe= ~A~%" (file-access alphabet (+ I (- m 1))))
                       ;(format t "schiebe um ~A~%" (get-from-occ occ (file-access alphabet (+ I (- m 1))) m))
                       (+ i (get-from-occ occ (file-access alphabet (+ I (- m 1))) m))
                       ))))

(defun border (such)
  (let* ((m (length such))
         (bord (make-array (+ 1 m) :initial-element -1)))
    (loop 
      with vart = -1
      for j from 1 to m
      do 
      (loop
        while (>= vart 0)
        while (not (eq (aref such vart) (aref such (- j 1))))
        do (setf vart (aref bord vart))
        )
      do (incf vart) 
      do (setf (aref bord j) vart)
      )
    bord
    )
  )


(defun strong-border (such)
  (let* ((m (length such))
         (bord (make-array (+ 1 m) :initial-element -1)))
    (loop 
      with vart = -1
      for j from 1 to m
      ;for vart = (aref bord (- j 1))
      do 
      (loop
        while (>= vart 0)
        while (not (eq (aref such vart) (aref such (- j 1))))
        do (setf vart (aref bord vart))
        )
      do (incf vart) 
      do (setf (aref bord j) vart)
      do (if (or (= j m) (not (eq (aref such vart) (aref such j))))
      ;do (if (and (not (= j m)) (not (eq (aref such vart) (aref such j))))
           (setf (aref bord j) vart)
           (setf (aref bord j) (aref bord vart)))
      )
    bord
    )
  )

(defparameter *border* (border *such*))
(defparameter *strong-border* (strong-border *such*))

(defun morris-pratt (alphabet such bord)
  (get_map alphabet such
           :next-i (lambda (I J)
                     (+ I (- j (aref bord J))))
           :next-j (lambda (I J)
                     (max 0 (- j (- j (aref bord j)))))
           ))
