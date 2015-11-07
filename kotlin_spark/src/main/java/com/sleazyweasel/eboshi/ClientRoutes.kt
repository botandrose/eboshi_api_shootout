package com.sleazyweasel.eboshi

import spark.Request
import spark.Response
import javax.inject.Inject

class ClientRoutes @Inject constructor(private val clientDataAccess: ClientDataAccess) {
    val getAll = { request: Request, response: Response ->
        val clients = clientDataAccess.allClients()
        JsonApiResponse(clients.map { it.toJsonApiObject() })
    }
}