;; Copyright (c) 2024 John Newton
;; SPDX-License-Identifier: Apache-2.0

(defsystem "foo.lisp.lack-middleware-request-id"
  :version "0.0.1"
  :author "John Newton"
  :license "Apache-2.0"
  :homepage "https://github.com/lisplizards/lack-middleware-request-id"
  :bug-tracker "https://github.com/lisplizards/lack-middleware-request-id/issues"
  :source-control (:git "https://github.com/lisplizards/lack-middleware-request-id.git")
  :depends-on ("frugal-uuid")
  :components ((:module "src"
                :components
                ((:file "middleware" :depends-on ("package"))
                 (:file "package"))))
  :description "Lack middleware for adding a request identifier to the Clack application environment"
  :in-order-to ((test-op (test-op "foo.lisp.lack-middleware-request-id/tests"))))

(defsystem "foo.lisp.lack-middleware-request-id/tests"
  :author "John Newton"
  :license "Apache-2.0"
  :depends-on ("foo.lisp.lack-middleware-request-id"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "middleware" :depends-on ("package"))
                 (:file "package"))))
  :description "Test system for foo.lisp.lack-middleware-request-id"
  :perform (test-op (op c) (symbol-call :rove :run c)))
