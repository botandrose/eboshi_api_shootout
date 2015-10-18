(ns clojure-liberator.core-test
  (:require [clojure.test :refer :all]
            [clojure-liberator.core :refer :all]))

(deftest hello-world-test
  (testing "Hello world resource works"
    (is (= {:status 200 :headers {"Content-Type" "text/plain;charset=UTF-8" "Vary" "Accept"} :body "Hello world"}
           (hello-world {:request-method :get :headers {"Accept" "text/plain"}})
           ))))