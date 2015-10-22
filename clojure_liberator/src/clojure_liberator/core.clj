(ns clojure-liberator.core
  ;(:gen-class)
  (:require [liberator.core :refer [resource defresource]]
            [ring.middleware.params :refer [wrap-params]]
            [compojure.core :refer [defroutes ANY]]
            [ring.adapter.jetty :as jetty]
            [clojure-liberator.data-access :as data-access]
            [clojure.data.json :as json]
            [clj-time.format :as fmt]
            [clj-time.core :as t]
            clj-time.jdbc
            )
  (:import (org.joda.time DateTime)))

(def formatter (fmt/formatters :date-time-no-ms))

(extend-type DateTime
  json/JSONWriter
  (-write [date out]
    (json/-write (fmt/unparse formatter date) out)))

(defn transform-type [type-name value]
  {:id (str (:id value)) :type type-name :attributes (dissoc value :id)})

(def client-transform (partial transform-type "clients"))

(defresource hello-world
             :available-media-types ["text/plain"]
             :handle-ok "Hello world")

(defresource all-clients
             :available-media-types ["application/json"]
             :handle-ok {:data (map client-transform (data-access/all_clients))})

(defroutes app
           (ANY "/api/test" [] hello-world)
           (ANY "/api/clients" [] all-clients))

(def handler
  (-> app wrap-params))

(defn -main []
  (jetty/run-jetty handler {:port 6969 :join? true :daemon? true}))