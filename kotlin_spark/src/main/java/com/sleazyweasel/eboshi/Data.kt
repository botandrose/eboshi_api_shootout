package com.sleazyweasel.eboshi

import kotlin.properties.getValue

data class Client(val data: Map<String, Any?>) {
    val id: Int? by data
}

data class Account(val data: Map<String, Any?>) {
    val id: Int? by data
    val password: String? by data
    val crypted_password: String? by data
}

data class AuthData(val data: Map<String, Any?>) {
    val email: String? by data
    val password: String? by data
}

data class JsonApiError(val title: String)
data class JsonApiObject(val id: String?, val type: String, val attributes: Map<String, Any?>)
data class JsonApiResponse(val data: List<JsonApiObject>)
data class JsonApiRequest(val data: JsonApiObject)
