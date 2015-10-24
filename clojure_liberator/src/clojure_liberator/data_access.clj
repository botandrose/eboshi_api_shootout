(ns clojure-liberator.data-access
  (:require [korma.db :as db]
            [korma.core :as korma]
            [clojure.java.jdbc :as jdbc]
            [clj-time.coerce :as c]
            clj-time.jdbc)
  (:import (java.sql PreparedStatement)
           (org.joda.time DateTime)))

(extend-type DateTime
  jdbc/ISQLParameter
  (set-parameter [v ^PreparedStatement stmt idx]
    (.setTimestamp stmt idx (c/to-sql-time v))))

(db/defdb eboshi (db/mysql {:db       "eboshi_test"
                            :user     "root"
                            :password ""}))

(declare clients)

(korma/defentity clients)

(defn all-clients []
  (korma/select clients))

(defn create-client [client]
  (let [response (korma/insert clients (korma/values client))
        new-id (response :generated_key)]
    (assoc client :id new-id)))