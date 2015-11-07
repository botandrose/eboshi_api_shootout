package com.sleazyweasel.eboshi

import spark.Spark.get
import spark.Spark.port

fun main(args: Array<String>) {
    port(6969)
    get("/api/test") { request, response -> "Hello world" }
}

