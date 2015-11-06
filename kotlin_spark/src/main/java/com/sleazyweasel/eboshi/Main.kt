package com.sleazyweasel.eboshi

import spark.Spark.port
import spark.Spark.get

fun main(args: Array<String>) {
    port(6969)
    get("/api/test") { request, response ->
        response.type("text/plain")
        "Hello world"
    }
}

