package com.sleazyweasel.eboshi

import kotlin.properties.getValue

data class Client(val data: Map<String, Any?>) {
    val id: Int? by data;
}

data class JsonApiObject(val id: String?, val type: String, val attributes: Map<String, Any?>)
data class JsonApiResponse(val data: List<JsonApiObject>)

//todecide: extension function like this, or function that takes a Client parameter?
fun Client.toJsonApiObject() = JsonApiObject(id?.toString(), "clients", data.minus("id"))