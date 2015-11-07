package com.sleazyweasel.eboshi

import org.junit.Assert.assertEquals
import org.junit.Test
import org.mockito.Mockito.`when`
import spark.Request
import spark.Response
import java.util.*

class ClientRoutesTest {
    private val clientDataAccess = mock(ClientDataAccess::class)

    @Test
    fun testGetAll() {
        val createdDate = Date()
        `when`(clientDataAccess.allClients()).thenReturn(listOf(Client(mapOf("id" to 5, "name" to "John", "created_at" to createdDate))))
        val expected = JsonApiResponse(listOf(JsonApiObject("5", "clients", mapOf("name" to "John", "created_at" to createdDate))))

        val testClass = ClientRoutes(clientDataAccess)
        val result = testClass.getAll(mock(Request::class), mock(Response::class))

        assertEquals(expected, result)
    }
}