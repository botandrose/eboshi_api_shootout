(ns clojure-liberator.data-access
  (:require [korma.db :as db]
            [korma.core :as k]
            clj-time.jdbc))

(db/defdb eboshi (db/mysql {:db       "eboshi_test"
                            :user     "root"
                            :password ""}))

(declare clients)

(k/defentity clients)

(defn all-clients []
  (k/select clients))