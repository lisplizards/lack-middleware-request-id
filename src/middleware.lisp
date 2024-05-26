;; Copyright (c) 2024 John Newton
;; SPDX-License-Identifier: Apache-2.0

(in-package #:lack/middleware/request-id)

(defparameter *lack-middleware-request-id*
  (lambda (app)
    (declare (type function app))
    (lambda (env)
      (declare (optimize (speed 3) (safety 0) (debug 0))
               (type list env))
      (let* ((request-headers (getf env :headers))
             (request-id (or (gethash "x-request-id" request-headers)
                             (fuuid:to-string (fuuid:make-v4)))))
        (declare (type hash-table request-headers)
                 (type string request-id))
        (setf (getf env :request-id) request-id)
        (let ((response (funcall app env)))
          (declare (type list response))
          (setf (second response)
                (nconc (second response) `(:x-request-id ,request-id)))
          response))))
  "Lack middleware to add REQUEST-ID to the Clack environment and an X-Request-Id response
header, for purposes of request correlation and distributed tracing; checks whether header
X-Request-ID already exists, as would occur in typical cases when a server in front of the
Clack application adds the header, or else if not found in the request headers, generates
a request-ID.")
