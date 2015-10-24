(ns clojure-liberator.core
  ;(:gen-class)
  (:require [liberator.core :refer [resource defresource]]
            [ring.middleware.params :refer [wrap-params]]
            [compojure.core :refer [defroutes GET defroutes POST]]
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

(defn- update-vals [map vals f]
  (reduce #(update-in %1 [%2] f) map vals))

(defn- parse-date [value]
  (fmt/parse formatter value))

(defn- replace-dates [input date-fields]
  (update-vals input (filter #(input %) date-fields) #(parse-date %)))

(defn- from-json-api-item [input date-fields]
  (replace-dates ((input :data) :attributes) date-fields))

(defn- extract-request-body [context] (slurp (get-in context [:request :body])))

(defresource hello-world
             :available-media-types ["text/plain"]
             :handle-ok "Hello world")

(defresource all-clients
             :available-media-types ["application/json"]
             :handle-ok (let [client-transform (partial make-json-api-item "clients")
                              all-clients (data-access/all-clients)
                              json-api-clients (map client-transform all-clients)]
                          {:data json-api-clients}))

(defresource create-client
             :available-media-types ["application/json"]
             :allowed-methods [:post]
             :handle-created (fn [context]
                               (let [body (extract-request-body context)
                                     json-api-data (json/read-json body)
                                     client (from-json-api-item json-api-data [:created_at :updated_at])
                                     saved-client (data-access/create-client client)]
                                 (clojure.pprint/pprint json-api-data)
                                 (clojure.pprint/pprint client)
                                 {:data (make-json-api-item "clients" saved-client)})))

(defroutes app
           (GET "/api/test" [] hello-world)
           (GET "/api/clients" [] all-clients)
           (POST "/api/clients" [] create-client))

; note: not needed quite yet, but middleware that takes query parameters and makes them available to the route as a map.
(def handler
  (-> app
      wrap-params))

(defn -main []
  (jetty/run-jetty handler {:port 6969}))