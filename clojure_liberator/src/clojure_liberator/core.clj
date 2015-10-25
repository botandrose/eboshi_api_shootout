(ns clojure-liberator.core
  ;(:gen-class)
  (:require [liberator.core :refer [resource defresource]]
            [ring.middleware.params :refer [wrap-params]]
            [compojure.core :refer [defroutes GET POST DELETE]]
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

(defn- update-vals [map fields transformation]
  (reduce #(update-in %1 [%2] transformation) map fields))

(defn- parse-date [value]
  (fmt/parse formatter value))

(defn- replace-dates [input date-fields]
  "Takes the specified collection of date-fields and converts them from ISO format to joda DateTime instances.
  This only works at the top level of the provided input, and doesn't descend into sub-elements."
  (let [present-date-fields (filter #(input %) date-fields)]
    (update-vals input present-date-fields #(parse-date %))))

(defn- from-json-api-item [input date-fields]
  (replace-dates ((input :data) :attributes) date-fields))

(defn- to-json-api-item [type-name value]
  {:id         (str (:id value))
   :type       type-name
   :attributes (dissoc value :id)})

(defn- extract-request-body [context] (slurp (get-in context [:request :body])))

(defresource hello-world
             :available-media-types ["text/plain"]
             :handle-ok "Hello world")

(defresource all-clients
             :available-media-types ["application/json"]
             :handle-ok (let [client-transform (partial to-json-api-item "clients")
                              all-clients (data-access/all-clients)
                              json-api-clients (map client-transform all-clients)]
                          {:data json-api-clients}))

(defresource create-client
             :available-media-types ["application/json"]
             :allowed-methods [:post]
             :post! (fn [context]
                      (let [body (extract-request-body context)
                            json-api-data (json/read-json body)
                            client (from-json-api-item json-api-data [:created_at :updated_at])
                            saved-client (data-access/create-client client)]
                        {::client saved-client}))
             :handle-created (fn [context]
                               (let [client-data (to-json-api-item "clients" (::client context))]
                                 {:data client-data})))

(defresource delete-client [id]
             :available-media-types ["application/json"]
             :allowed-methods [:delete]
             :delete! (fn [_]
                        (data-access/delete-client id)))

(defroutes app
           (GET "/api/test" [] hello-world)
           (GET "/api/clients" [] all-clients)
           (POST "/api/clients" [] create-client)
           (DELETE "/api/clients/:id" [id] (delete-client id)))

(def handler
  (-> app
      wrap-params))

(defn -main []
  (jetty/run-jetty handler {:port 6969}))