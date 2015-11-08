package com.sleazyweasel.eboshi

import org.junit.Assert.assertEquals
import org.junit.Test
import org.mockito.Mockito.verify
import spark.Response
import java.util.*

class ClientRoutesTest {
    private val clientDataAccess = mock(ClientDataAccess::class)

    @Test
    fun testGetAll() {
        val createdDate = Date()
        val expected = JsonApiResponse(listOf(JsonApiObject("5", "clients", mapOf("name" to "John", "created_at" to createdDate))))

        clientDataAccess.allClients = { listOf(Client(mapOf("id" to 5, "name" to "John", "created_at" to createdDate))) }

        val testClass = ClientRoutes(clientDataAccess)
        val result = testClass.getAll()

        assertEquals(expected, result)
    }

    @Test
    fun testCreate() {
        val createdAtString = "1970-08-07T10:20:00Z"
        val clientAttributes = mapOf("name" to "John", "created_at" to createdAtString)
        val convertedAttributes = mapOf("name" to "John", "created_at" to isoDateFormat.parse(createdAtString))

        val request = JsonApiRequest(JsonApiObject(null, "clients", clientAttributes))
        val expected = mapOf("data" to JsonApiObject("555", "clients", convertedAttributes))

        clientDataAccess.insert = { client: Client ->
            assertEquals(Client(convertedAttributes), client);
            Client(convertedAttributes.plus("id" to 555))
        }
        val response = mock(Response::class)

        val testClass = ClientRoutes(clientDataAccess)

        val result = testClass.create(request, response)
        assertEquals(expected, result)
        verify(response).status(201)
    }
}