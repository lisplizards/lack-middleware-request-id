;; Copyright (c) 2024 John Newton
;; SPDX-License-Identifier: Apache-2.0

(in-package #:lack/middleware/request-id/tests)

(deftest middleware-passthrough-request-id
    (testing
     "when the X-Request-Id request header is already present, adds the found REQUEST-ID to the application environment and adds the found X-Request-Id to the response"
     (flet ((app (env)
              `(200
                (:content-type "text/plain")
                (,(format nil "~A" (getf env :request-id))))))
       (let ((app (funcall lack/middleware/request-id:*lack-middleware-request-id*
                           #'app)))
         (let* ((response (funcall app `(:headers ,(let ((headers (make-hash-table :test #'equal)))
                                                     (setf (gethash "x-request-id" headers)
                                                           "F99325C2-E32F-4B1A-B1C4-C21D0FB2BD87")
                                                     headers))))
                (response-headers (second response))
                (response-body (third response)))
           (ok (stringp (getf response-headers :x-request-id)))
           (ok (equal "F99325C2-E32F-4B1A-B1C4-C21D0FB2BD87" (getf response-headers :x-request-id)))
           (ok (not (null response-body)))
           (ok (stringp (first response-body)))
           (ok (equal "F99325C2-E32F-4B1A-B1C4-C21D0FB2BD87" (first response-body))))))))

(deftest middleware-add-request-id
    (testing
     "when the X-Request-Id request header is not present, generates a request-id, adds REQUEST-ID to the application environment, and adds X-Request-Id to the response headers"
     (flet ((app (env)
              `(200
                (:content-type "text/plain")
                (,(format nil "~A" (getf env :request-id))))))
       (let ((app (funcall lack/middleware/request-id:*lack-middleware-request-id*
                           #'app)))
         (let* ((response (funcall app `(:headers ,(let ((headers (make-hash-table :test #'equal)))
                                                     (setf (gethash "content-type" headers)
                                                           "text/plain"
                                                           (gethash "x-foo" headers)
                                                           "bar")
                                                     headers))))
                (response-headers (second response))
                (response-body (third response)))
           (ok (stringp (getf response-headers :x-request-id)))
           (ok (= 36 (length (getf response-headers :x-request-id))))
           (ok (not (null response-body)))
           (ok (stringp (first response-body)))
           (format t "RESPONSE HEADERS: ~A~%" response-headers)
           (ok (= 36 (length (first response-body)))))))))
