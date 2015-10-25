(ns clojure-liberator.core-test
  (:require [clojure.test :refer :all]
            [clojure-liberator.core :refer :all])
  (:import (org.joda.time DateTime)))

(deftest hello-world-test
  (testing "Hello world resource works"
    (is (= {:status 200 :headers {"Content-Type" "text/plain;charset=UTF-8" "Vary" "Accept"} :body "Hello world"}
           (hello-world {:request-method :get :headers {"Accept" "text/plain"}})
           ))))

(deftest make-json-api-item-test
  (testing "Creates the json.api item from a general map of data with an :id"
    (is (let [data {:id 1234 :foo "foo" :bar "bar"}
              expected {:id "1234" :type "bananas" :attributes {:foo "foo" :bar "bar"}}]
          (= expected, (@#'clojure-liberator.core/to-json-api-item "bananas" data))))))

(deftest replace-dates-test
  (testing "Properly handles parsing json dates"
    (is (let [data {:id 1234 :created_at "2006-06-25T00:00:00Z" :updated_at "2007-07-25T00:00:00Z"}
              result (@#'clojure-liberator.core/replace-dates data [:created_at :updated_at])
              expected {:id 1234 :created_at (DateTime. 2006 6 25 0 0 0) :updated_at (DateTime. 2007 7 25 0 0 0)}]
          (= expected result))))
  (testing "Properly handles missing field"
    (is (let [data {:id 1234 :created_at "2006-06-25T00:00:00Z"}
              result (@#'clojure-liberator.core/replace-dates data [:created_at :updated_at])
              expected {:id 1234 :created_at (DateTime. 2006 6 25 0 0 0)}]
          (= expected result))))
  (testing "Doesn't descend into lower elements (not great, but verifies the current behavior)"
    (is (let [data {:id 1234 :foo {:updated_at "2007-07-25T00:00:00Z"}}
              result (@#'clojure-liberator.core/replace-dates data [:updated_at])
              expected data]
          (= expected result)))))

