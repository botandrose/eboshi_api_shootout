package com.sleazyweasel.eboshi

import com.google.gson.Gson
import com.google.inject.Guice
import spark.Spark.*
import kotlin.reflect.KClass

fun main(args: Array<String>) {
    val injector = Guice.createInjector(EboshiModule())
    fun <T : Any> instance(kotlinClass: KClass<T>): T = injector.getInstance(kotlinClass.java)
    val gson = instance(Gson::class)
    val gsonTransformer: (Any) -> String = { gson.toJson(it) }

    port(6969)
    before({ request, response -> response.type("application/vnd.api+json") })
    get("/api/test", { request, response -> "Hello world" })
    get("/api/clients", instance(ClientRoutes::class).getAll, gsonTransformer)
}

