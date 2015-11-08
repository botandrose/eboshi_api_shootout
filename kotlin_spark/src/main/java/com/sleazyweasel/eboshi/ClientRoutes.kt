package com.sleazyweasel.eboshi

import org.eclipse.jetty.http.HttpStatus
import spark.Request
import spark.Response
import javax.inject.Inject

class ClientRoutes @Inject constructor(private val clientDataAccess: ClientDataAccess) {

    val getAll = {
        val clients = clientDataAccess.allClients()
        JsonApiResponse(clients.map { it.toJsonApiObject() })
    }

    val create = { input: JsonApiRequest, response: Response ->
        val client = Client(input.data.attributes)
        val insertedClient = clientDataAccess.insert(client.convertDateFields())

        response.status(HttpStatus.CREATED_201)
        mapOf("data" to insertedClient.toJsonApiObject())
    }

    val delete = { request: Request, response: Response ->
        val id = request.params(":id").toInt()
        clientDataAccess.delete(id)
        response.status(HttpStatus.NO_CONTENT_204)
    }
}