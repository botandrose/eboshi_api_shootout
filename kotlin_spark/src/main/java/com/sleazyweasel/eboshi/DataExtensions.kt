package com.sleazyweasel.eboshi

import java.util.*

//todecide: extension functions like these, or functions that take a Client parameter?
fun Client.toJsonApiObject() = JsonApiObject(id?.toString(), "clients", data.minus("id"))

fun Client.convertDateFields(): Client {
    return Client(data.plus(listOf("created_at" to convertToDate("created_at"), "updated_at" to convertToDate("updated_at"))).filterValues { it != null })
}

private fun Client.convertToDate(fieldName: String) = convertDate(data[fieldName] as String?)

//would love to be using java 8 ZonedDateTime/OffsetDateTime here, but the mysql driver doesn't like them. :(
private fun convertDate(date: String?): Date? = when (date) {
    null -> null
    else -> isoDateFormat.parse(date)
}
