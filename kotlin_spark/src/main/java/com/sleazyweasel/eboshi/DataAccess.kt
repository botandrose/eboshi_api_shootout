package com.sleazyweasel.eboshi

import org.springframework.jdbc.core.JdbcTemplate
import javax.inject.Inject

//note: open declaration & var declaration here are not desired, but required for Mockito to work correctly, as kotlin makes everything final by default.
open class ClientDataAccess @Inject constructor(private val jdbcTemplate: JdbcTemplate) {
    var allClients = { jdbcTemplate.queryForList("select * from clients").map { Client(it) } }
}

