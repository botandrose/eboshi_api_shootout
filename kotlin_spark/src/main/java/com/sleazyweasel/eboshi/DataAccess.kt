package com.sleazyweasel.eboshi

import org.springframework.jdbc.core.JdbcTemplate
import javax.inject.Inject

//note: open declarations here are not desired, but required for Mockito to work correctly, as kotlin makes everything final by default.
open class ClientDataAccess @Inject constructor(val jdbcTemplate: JdbcTemplate) {
    open fun allClients(): List<Client> = jdbcTemplate.queryForList("select * from clients").map { Client(it) }
}

