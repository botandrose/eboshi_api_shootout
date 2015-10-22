(ns clojure-liberator.data-access)
(use 'korma.db)
(use 'korma.core)
(require '[clojure.string :as str])

(defdb eboshi (mysql {:db "eboshi_test"
                       :user "root"
                       :password ""
                       ;; optional keys
                       }))

(declare clients users)

(defentity clients)

(defentity users)

(defn all-users []
  (select users))

(defn all-clients []
  (select clients))