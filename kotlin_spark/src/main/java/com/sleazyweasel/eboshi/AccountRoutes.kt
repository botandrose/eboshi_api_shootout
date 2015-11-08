package com.sleazyweasel.eboshi

import org.eclipse.jetty.http.HttpStatus
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
        if (!auth.verify(authData.password, account.crypted_password)) {
            response.status(401)
            mapOf("errors" to listOf(JsonApiError("Invalid authentication credentials")))
        } else {
            //todo: actually generate a real jwt token!
            val token = "asdlkj.asldfkj.adlfjk"
            mapOf("data" to AuthData(mapOf("email" to authData.email, "token" to token)).toJsonApiObject())
        }
    }

}

