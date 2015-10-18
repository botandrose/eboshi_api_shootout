(defproject clojure_liberator "0.1.0-SNAPSHOT"
  :plugins [[lein-ring "0.8.11"]]
  :ring {:handler clojure-liberator.core/handler}
  :main clojure-liberator.core
  :dependencies [[org.clojure/clojure "1.7.0"]
                 [liberator "0.13"]
                 [compojure "1.3.4"]
                 [ring "1.4.0"]])
