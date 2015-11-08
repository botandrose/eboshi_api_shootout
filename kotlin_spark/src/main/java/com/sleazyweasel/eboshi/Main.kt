package com.sleazyweasel.eboshi

import com.google.inject.Guice

fun main(args: Array<String>) {
    val injector = Guice.createInjector(EboshiModule())

    val spark = injector.instance(SparkGson::class)
    val clientRoutes = injector.instance(ClientRoutes::class)

    spark.port(6969)
    spark.get("/api/test") { request, response -> "Hello world" }
    spark.get("/api/clients", clientRoutes.getAll)
    spark.post("/api/clients", JsonApiRequest::class, clientRoutes.create)
    spark.delete("/api/clients/:id", clientRoutes.delete)
}


