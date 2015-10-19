(ns clojure-liberator.core
  (:gen-class)
  (:require [liberator.core :refer [resource defresource]]
            [ring.middleware.params :refer [wrap-params]]
            [compojure.core :refer [defroutes ANY]]
            [ring.adapter.jetty :as jetty]))

(defresource hello-world
             :available-media-types ["text/plain"]
             :handle-ok "Hello world")

(defroutes app
           (ANY "/api/test" [] hello-world))

(def handler
  (-> app wrap-params))

(defn -main []
  (.addShutdownHook (Runtime/getRuntime) (Thread. #(println "shutdown")))
  (jetty/run-jetty handler {:port 6969 :join? true :daemon? true}))