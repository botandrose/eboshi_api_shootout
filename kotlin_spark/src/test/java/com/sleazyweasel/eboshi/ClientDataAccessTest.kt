package com.sleazyweasel.eboshi

import org.junit.Assert.assertEquals
import org.junit.Test
import org.mockito.Mockito.`when`
import org.springframework.jdbc.core.JdbcTemplate

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
}