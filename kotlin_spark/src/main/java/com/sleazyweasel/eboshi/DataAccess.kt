package com.sleazyweasel.eboshi

import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.core.simple.SimpleJdbcInsert
import javax.inject.Inject

//note: open declaration & var declarations here are not desired, but required for Mockito to work correctly, as kotlin makes everything final by default.
open class ClientDataAccess constructor(private val jdbcTemplate: JdbcTemplate, private val insertClient: SimpleJdbcInsert) {

    @Inject constructor(jdbcTemplate: JdbcTemplate) :
    this(jdbcTemplate, SimpleJdbcInsert(jdbcTemplate).withTableName("clients").usingGeneratedKeyColumns("id"))

    var allClients = { jdbcTemplate.queryForList("select * from clients").map { Client(it) } }

    var insert: (Client) -> Client = { client: Client ->
        val key = insertClient.executeAndReturnKey(client.data).toInt()
        Client(client.data.plus("id" to key))
    }

    var delete: (Int) -> Unit = {
        jdbcTemplate.update("delete from clients where id = ?", it)
    }
}

