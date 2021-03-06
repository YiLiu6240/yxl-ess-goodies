(require 'ess-site)
(require 'ivy)

;; TODO:
;; add optional arguments
(defvar yxl-ess-useful-funcs
  '(("sessionInfo() -- info on loaded pacakges" . "sessionInfo()")
    ("yxlRutils::qq() - quick quit" . "yxlRutils::qq()")
    ("yxlRutils::lsdf() -- list current dataframes" . "yxlRutils::lsdf()")
    ("yxlRutils::lsos() -- list object by size" . "yxlRutils::lsos()"))
  "list of useful R functions to execute")

(defvar yxl-ess-useful-atpoint-funcs
  '(("print()" . "print")
    ("dplyr::glimpse()" . "dplyr::glimpse")
    ("str()" . "str")
    ("summary()" . "summary")
    ("dim()" . "dim")
    ("dimnames()" . "dimnames")
    ("head()" . "head")
    ("tail()" . "tail")
    ("Hmisc::describe()" . "Hmisc::describe")
    ("DT::datatable() -- view dataframe in browser" . "DT::datatable")
    ("listviewer::jsonedit() -- view list in browser" . "listviewer::jsonedit"))
  "list of useful R functions to execute to the current object atpoint.")

(defun yxl-ess-call-atpoint-func (r-func)
  (let ((objname (current-word)))
    (if objname
        (progn
          (ess-execute (concat r-func "(" objname ")"))))))

(defun yxl-ess-call-atpoint-str ()
  (interactive)
  (yxl-ess-call-atpoint-func "str"))

(defun yxl-ess-call-atpoint-generic (r-func)
  (interactive "sR function to execute: ")
  (yxl-ess-call-atpoint-func r-func))

(defun yxl-ess-call-useful-funcs ()
  (interactive)
  (ivy-read "Call useful funcs:"
            yxl-ess-useful-funcs
            :action (lambda (x) (ess-execute (cdr x)))
            :caller 'yxl-ess-call-useful-funcs))

(defun yxl-ess-atpoint ()
  (interactive)
  (ivy-read "Call useful funcs:"
            yxl-ess-useful-atpoint-funcs
            :action (lambda (x) (yxl-ess-call-atpoint-func (cdr x)))
            :caller 'yxl-ess-atpoint))

(defun yxl-ess-atpoint-pop ()
  (interactive)
  (ivy-read "Call useful funcs:"
            yxl-ess-useful-atpoint-funcs
            :action (lambda (x)
                      (let ((ess-execute-in-process-buffer nil))
                        (yxl-ess-call-atpoint-func (cdr x))))
            :caller 'yxl-ess-atpoint-pop))

(defun yxl-ess-rdired-str ()
  (interactive)
  (let ((objname (ess-rdired-object)))
    (ess-execute (concat "str(" objname ")\n"))))

(defun yxl-ess-rdired-atpoint ()
  (interactive)
  (ivy-read "Call useful funcs:"
            yxl-ess-useful-atpoint-funcs
            :action (lambda (x)
                      (let ((objname (ess-rdired-object)))
                        (ess-execute (concat (cdr x) "(" objname ")\n"))))
            :caller 'yxl-ess-rdired-atpoint))

(defun yxl-ess-rdired-atpoint-pop ()
  (interactive)
  (ivy-read "Call useful funcs:"
            yxl-ess-useful-atpoint-funcs
            :action (lambda (x)
                      (let ((objname (ess-rdired-object))
                            (ess-execute-in-process-buffer nil))
                        (ess-execute (concat (cdr x) "(" objname ")\n"))))
            :caller 'yxl-ess-rdired-atpoint-pop))

(defun yxl-ess-open-rstudio ()
  (interactive)
  ;; https://support.rstudio.com/hc/en-us/articles/200711843-Working-Directories-and-Workspaces
  (let ((path (if (and (eq major-mode 'ess-mode)
                       buffer-file-name)
                  buffer-file-name
                default-directory)))
    (cond
     ((string-equal system-type "windows-nt")
      (message "not implemented"))
     ((string-equal system-type "darwin")
      (shell-command (format "open -a Rstudio %s & disown" path)))
     ((string-equal system-type "gnu/linux")
      (shell-command (format "rstudio %s & disown" path))))))

(provide 'yxl-ess)
