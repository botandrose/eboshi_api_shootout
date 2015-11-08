package com.sleazyweasel.eboshi

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.inject.AbstractModule
import com.google.inject.Provides
import com.google.inject.Singleton
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.datasource.SingleConnectionDataSource
import java.text.SimpleDateFormat
import java.time.format.DateTimeFormatter
import javax.sql.DataSource

private val isoPattern = "yyyy-MM-dd'T'HH:mm:ssX"
val isoDateFormat = SimpleDateFormat(isoPattern)
val dtf = DateTimeFormatter.ofPattern(isoPattern)

class EboshiModule : AbstractModule() {
    override fun configure() {
    }

    @Provides @Singleton
    fun jdbcTemplate(): JdbcTemplate {
        return JdbcTemplate(dataSource())
    }

    private fun dataSource(): DataSource =
            //note: not really a robust datasource. good enough for the api shootout, though.
            SingleConnectionDataSource("jdbc:mysql://localhost:3306/eboshi_test", "root", "", true)

    @Provides @Singleton
    fun gson(): Gson = GsonBuilder()
            .setDateFormat(isoPattern)
            .create()
}

