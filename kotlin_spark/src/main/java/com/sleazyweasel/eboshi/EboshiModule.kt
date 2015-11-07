package com.sleazyweasel.eboshi

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.inject.AbstractModule
import com.google.inject.Provides
import com.google.inject.Singleton
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.datasource.SingleConnectionDataSource
import javax.sql.DataSource

class EboshiModule : AbstractModule() {
    override fun configure() {
    }

    @Provides
    fun jdbcTemplate(): JdbcTemplate = JdbcTemplate(dataSource())

    private fun dataSource(): DataSource =
            //note: not really a robust datasource. good enough for the api shootout, though.
            SingleConnectionDataSource("jdbc:mysql://localhost:3306/eboshi_test", "root", "", true)

    @Provides @Singleton
    fun gson(): Gson = GsonBuilder()
            .setDateFormat("yyyy-MM-dd'T'HH:mm:ssX")
            .create()
}

