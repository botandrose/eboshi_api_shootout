(ns clojure-liberator.core
  ;(:gen-class)
  (:require [liberator.core :refer [resource defresource]]
            [ring.middleware.params :refer [wrap-params]]
            [compojure.core :refer [defroutes GET]]
            [ring.adapter.jetty :as jetty]
            [clojure-liberator.data-access :as data-access]
            [clojure.data.json :as json]
            [clj-time.format :as fmt])
  (:import (org.joda.time DateTime)))

(def ^:private formatter (fmt/formatters :date-time-no-ms))

(extend-type DateTime
  json/JSONWriter
  (-write [date out]
    (json/-write (fmt/unparse formatter date) out)))

(defn- make-json-api-item [type-name value]
  {:id         (str (:id value))
   :type       type-name
   :attributes (dissoc value :id)})

(defresource hello-world
             :available-media-types ["text/plain"]
             :handle-ok "Hello world")

(defresource all-clients
             :available-media-types ["application/json"]
             :handle-ok (let [client-transform (partial make-json-api-item "clients")
                              all-clients (data-access/all-clients)
                              json-api-clients (map client-transform all-clients)]
                          {:data json-api-clients}))

(defroutes app
           (GET "/api/test" [] hello-world)
           (GET "/api/clients" [] all-clients))

; note: not needed quite yet, but middleware that takes query parameters and makes them available to the route as a map.
(def handler
  (-> app wrap-params))

(defn -main []
  (jetty/run-jetty handler {:port 6969}))