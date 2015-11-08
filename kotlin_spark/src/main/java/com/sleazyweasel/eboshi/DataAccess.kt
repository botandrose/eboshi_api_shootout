package com.sleazyweasel.eboshi

import org.springframework.dao.support.DataAccessUtils
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.core.simple.SimpleJdbcInsert
import javax.inject.Inject

//note: open declaration & var declarations here are not desired, but required for Mockito to work correctly, as kotlin makes everything final by default.
open class ClientDataAccess constructor(private val jdbcTemplate: JdbcTemplate, private val insertClient: SimpleJdbcInsert) {

    @Inject constructor(jdbcTemplate: JdbcTemplate) :
    this(jdbcTemplate, SimpleJdbcInsert(jdbcTemplate).withTableName("clients").usingGeneratedKeyColumns("id"))

    var allClients = { jdbcTemplate.queryForList("select * from clients").map { Client(it) } }

    var insert: (Client) -> Client = { client ->
        val key = insertClient.executeAndReturnKey(client.data).toInt()
        Client(client.data.plus("id" to key))
    }

    var delete: (Int) -> Unit = {
        jdbcTemplate.update("delete from clients where id = ?", it)
    }
}

open class AccountDataAccess constructor(private val jdbcTemplate: JdbcTemplate, private val insertUser: SimpleJdbcInsert) {

    @Inject constructor(jdbcTemplate: JdbcTemplate) :
    this(jdbcTemplate, SimpleJdbcInsert(jdbcTemplate).withTableName("users").usingGeneratedKeyColumns("id"))

    var insert: (Account) -> Account = { account ->
        val key = insertUser.executeAndReturnKey(account.data).toInt()
        Account(account.data.plus("id" to key))
    }

    var get: (Int) -> Account = { id ->
        Account(DataAccessUtils.requiredSingleResult(jdbcTemplate.queryForList("select * from users where id = ?", id)))
    }

    var getByEmail: (String) -> Account = { email ->
        Account(DataAccessUtils.requiredSingleResult(jdbcTemplate.queryForList("select * from users where email = ?", email)))
    }
}

