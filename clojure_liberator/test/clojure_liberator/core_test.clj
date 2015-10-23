(ns clojure-liberator.core-test
  (:require [clojure.test :refer :all]
            [clojure-liberator.core :refer :all]))

(deftest hello-world-test
  (testing "Hello world resource works"
    (is (= {:status 200 :headers {"Content-Type" "text/plain;charset=UTF-8" "Vary" "Accept"} :body "Hello world"}
           (hello-world {:request-method :get :headers {"Accept" "text/plain"}})
           ))))

(deftest make-json-api-item-test
  (testing "Creates the json.api item from a general map of data with an :id"
    (is (let [data {:id 1234 :foo "foo" :bar "bar"}
              expected {:id "1234" :type "bananas" :attributes {:foo "foo" :bar "bar"}}]
          (= expected, (@#'clojure-liberator.core/make-json-api-item "bananas" data)))))
  )