package com.sleazyweasel.eboshi

import org.eclipse.jetty.http.HttpStatus
import org.jose4j.jwt.consumer.InvalidJwtException
import spark.Request
import spark.Response
import java.util.*
import javax.inject.Inject

class AccountRoutes @Inject constructor(accountDataAccess: AccountDataAccess, auth: Auth) {
    val create = { input: JsonApiRequest, response: Response ->
        val submittedUserAttributes = input.data.attributes
        val user = Account(submittedUserAttributes)
        val (hashed, salt) = auth.encrypt(user.password!!)
        val userReadyToSave = Account(submittedUserAttributes
                .plus(listOf("crypted_password" to hashed, "password_salt" to salt, "created_at" to Date(), "updated_at" to Date()))
                .minus("password"))
        val savedUser = accountDataAccess.insert(userReadyToSave)
        response.status(HttpStatus.CREATED_201)
        mapOf("data" to Account(savedUser.data.minus(listOf("crypted_password", "password_salt"))).toJsonApiObject())
    }

    val auth = { input: JsonApiRequest, response: Response ->
        val authData = AuthData(input.data.attributes)
        val account = accountDataAccess.getByEmail(authData.email!!)
        if (auth.verify(authData.password, account.crypted_password)) {
            val token = auth.generateToken(account)
            mapOf("data" to AuthData(mapOf("email" to authData.email, "token" to token)).toJsonApiObject())
        } else {
            response.status(401)
            mapOf("errors" to listOf(JsonApiError("Invalid authentication credentials")))
        }
    }

    val get = { request: Request, response: Response ->
        val authHeader = request.headers("Authorization")
        val token = authHeader.substringAfter("Bearer ")
        val email: String
        try {
            email = auth.validateToken(token)
            val account = accountDataAccess.getByEmail(email)
            mapOf("data" to account.toJsonApiObject())
        } catch(e: InvalidJwtException) {
            response.status(401)
            mapOf("errors" to listOf(JsonApiError("Invalid authentication token")))
        }
    }

}

