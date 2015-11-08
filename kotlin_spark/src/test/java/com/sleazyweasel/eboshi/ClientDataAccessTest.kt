package com.sleazyweasel.eboshi

import org.junit.Assert.assertEquals
import org.junit.Test
import org.mockito.Mockito.`when`
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.core.simple.SimpleJdbcInsert

class ClientDataAccessTest {
    val jdbcTemplate = mock(JdbcTemplate::class)

    @Test
    fun testAllClients() {
        val clientMap = mapOf("id" to 1, "name" to "John")
        `when`(jdbcTemplate.queryForList("select * from clients")).thenReturn(listOf(clientMap))

        val testClass = ClientDataAccess(jdbcTemplate)

        val results = testClass.allClients()
        assertEquals(listOf(Client(clientMap)), results)
    }

    @Test
    fun testInsert() {
        val clientMap = linkedMapOf("name" to "John", "address" to "1121 NE Glisan")
        val client = Client(clientMap)
        val jdbcInsert = mock(SimpleJdbcInsert::class)
        val testClass = ClientDataAccess(jdbcTemplate, jdbcInsert)

        `when`(jdbcInsert.executeAndReturnKey(clientMap)).thenReturn(4)
        val result = testClass.insert(client)
        assertEquals(Client(clientMap.plus("id" to 4)), result)
    }
}