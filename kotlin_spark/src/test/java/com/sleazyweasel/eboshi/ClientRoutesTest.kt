package com.sleazyweasel.eboshi

import org.junit.Assert.assertEquals
import org.junit.Test
import spark.Request
import spark.Response
import java.util.*

class ClientRoutesTest {
    private val clientDataAccess = mockDeep(ClientDataAccess::class)

    @Test
    fun testGetAll() {
        val createdDate = Date()
        val expected = JsonApiResponse(listOf(JsonApiObject("5", "clients", mapOf("name" to "John", "created_at" to createdDate))))

        clientDataAccess.allClients = { listOf(Client(mapOf("id" to 5, "name" to "John", "created_at" to createdDate))) }

        val testClass = ClientRoutes(clientDataAccess)
        val result = testClass.getAll(mock(Request::class), mock(Response::class))

        assertEquals(expected, result)
    }
}