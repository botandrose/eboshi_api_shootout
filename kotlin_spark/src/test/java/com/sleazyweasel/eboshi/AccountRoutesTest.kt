package com.sleazyweasel.eboshi

import org.jose4j.jwt.consumer.InvalidJwtException
import org.junit.Assert.assertEquals
import org.junit.Test
import org.mockito.Mockito.`when`
import org.mockito.Mockito.verify
import spark.Request
import spark.Response

class AccountRoutesTest {
    private val accountDataAccess = mock(AccountDataAccess::class)
    private val auth = mock(Auth::class)

    @Test
    fun testCreate() {
        val request = JsonApiRequest(JsonApiObject(null, "accounts", mapOf("name" to "Joe Bob", "email" to "john@watson.com", "password" to "myPassword")))
        val initializedAccount = Account(mapOf("name" to "Joe Bob", "email" to "john@watson.com", "crypted_password" to "hash", "password_salt" to "salt"))
        val expectedAccount = Account(mapOf("name" to "Joe Bob", "email" to "john@watson.com", "id" to 555))
        val response = mock(Response::class)

        auth.encrypt = { password ->
            assertEquals("myPassword", password)
            Encrypted("hash", "salt")
        }
        accountDataAccess.insert = { account ->
            assertEquals(initializedAccount, account)
            Account(account.data.plus("id" to 555))
        }

        val testClass = AccountRoutes(accountDataAccess, auth)

        val result = testClass.create(request, response)
        assertEquals(mapOf("data" to expectedAccount.toJsonApiObject()), result)
        verify(response).status(201)
    }

    @Test
    fun testAuth() {
        val request = JsonApiRequest(JsonApiObject(null, "auth", mapOf("email" to "emailAddress", "password" to "plainText")))
        val response = mock(Response::class)
        val account = Account(mapOf("crypted_password" to "hash"))

        accountDataAccess.getByEmail = { email ->
            assertEquals("emailAddress", email)
            account
        }
        auth.verify = { clearText, hashed ->
            assertEquals("plainText", clearText)
            assertEquals("hash", hashed)
            true
        }
        auth.generateToken = { inputAccount ->
            assertEquals(account, inputAccount)
            "Token"
        }
        val testClass = AccountRoutes(accountDataAccess, auth)

        val result = testClass.auth(request, response)
        assertEquals(mapOf("data" to JsonApiObject(null, "auth", mapOf("email" to "emailAddress", "token" to "Token"))), result)
    }

    @Test
    fun testAuth_badPassword() {
        val request = JsonApiRequest(JsonApiObject(null, "auth", mapOf("email" to "emailAddress", "password" to "plainText")))
        val response = mock(Response::class)
        val account = Account(mapOf("crypted_password" to "hash"))

        accountDataAccess.getByEmail = { email ->
            assertEquals("emailAddress", email)
            account
        }
        auth.verify = { clearText, hashed -> false }
        val testClass = AccountRoutes(accountDataAccess, auth)

        val result = testClass.auth(request, response)
        assertEquals(mapOf("errors" to listOf(JsonApiError("Invalid authentication credentials"))), result)
        verify(response).status(401)
    }

    @Test
    fun testGet() {
        val request = mock(Request::class)
        val response = mock(Response::class)
        val account = Account(mapOf("name" to "John", "id" to 556))

        `when`(request.headers("Authorization")).thenReturn("Bearer of good tidings")
        auth.validateToken = { token ->
            assertEquals("of good tidings", token)
            "emailAddress"
        }
        accountDataAccess.getByEmail = { email ->
            assertEquals("emailAddress", email)
            account
        }

        val testClass = AccountRoutes(accountDataAccess, auth)
        val result = testClass.get(request, response)
        assertEquals(mapOf("data" to JsonApiObject("556", "accounts", mapOf("name" to "John"))), result)
    }

    @Test
    fun testGet_noAuth() {
        val request = mock(Request::class)
        val response = mock(Response::class)

        `when`(request.headers("Authorization")).thenReturn("Bearer of good tidings")
        auth.validateToken = { token -> throw InvalidJwtException("you fail!") }

        val testClass = AccountRoutes(accountDataAccess, auth)

        val result = testClass.get(request, response)

        assertEquals(mapOf("errors" to listOf(JsonApiError("Invalid authentication token"))), result)
        verify(response).status(401)
    }


}