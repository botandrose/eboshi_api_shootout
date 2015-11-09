package com.sleazyweasel.eboshi

import org.springframework.dao.support.DataAccessUtils
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.core.simple.SimpleJdbcInsert
import java.util.*
import javax.inject.Inject

open class ClientDataAccess constructor(private val jdbcTemplate: JdbcTemplate, private val insertClient: SimpleJdbcInsert) {

    @Inject constructor(jdbcTemplate: JdbcTemplate) :
    this(jdbcTemplate, SimpleJdbcInsert(jdbcTemplate).withTableName("clients").usingGeneratedKeyColumns("id"))

    var allClients = { jdbcTemplate.queryForList("select * from clients").map { Client(it) } }

    var insert: (Client) -> Client = { client ->
        val initialized = client.data.plusIfAbsent(listOf("created_at" to Date(), "updated_at" to Date()))
        val key = insertClient.executeAndReturnKey(initialized).toInt()
        Client(initialized.plus("id" to key))
    }

    var delete: (Int) -> Unit = {
        jdbcTemplate.update("delete from clients where id = ?", it)
    }
}

open class AccountDataAccess constructor(private val jdbcTemplate: JdbcTemplate, private val insertUser: SimpleJdbcInsert) {

    @Inject constructor(jdbcTemplate: JdbcTemplate) :
    this(jdbcTemplate, SimpleJdbcInsert(jdbcTemplate).withTableName("users").usingGeneratedKeyColumns("id"))

    var insert: (Account) -> Account = { account ->
        val initialized = account.data.plusIfAbsent(listOf("created_at" to Date(), "updated_at" to Date()))
        val key = insertUser.executeAndReturnKey(initialized).toInt()
        Account(initialized.plus("id" to key))
    }

    var get: (Int) -> Account = { id ->
        Account(DataAccessUtils.requiredSingleResult(jdbcTemplate.queryForList("select * from users where id = ?", id)))
    }

    var getByEmail: (String) -> Account = { email ->
        Account(DataAccessUtils.requiredSingleResult(jdbcTemplate.queryForList("select * from users where email = ?", email)))
    }
}

