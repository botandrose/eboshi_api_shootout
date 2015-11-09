package com.sleazyweasel.eboshi

import org.jose4j.jwk.RsaJsonWebKey
import org.jose4j.jwk.RsaJwkGenerator
import org.jose4j.jws.AlgorithmIdentifiers
import org.jose4j.jws.JsonWebSignature
import org.jose4j.jwt.JwtClaims
import org.jose4j.jwt.consumer.JwtConsumerBuilder
import org.mindrot.jbcrypt.BCrypt

class Auth {
    private val rsaWebKey: RsaJsonWebKey;

    constructor() {
        rsaWebKey = RsaJwkGenerator.generateJwk(2048)!!
        rsaWebKey.keyId = "eboshiKey"
    }

    val encrypt = { password: String ->
        val salt = BCrypt.gensalt()
        val hashedPassword = BCrypt.hashpw(password, salt)
        Encrypted(hashedPassword, salt)
    }

    val verify = { plainText: String?, hashedPassword: String? ->
        BCrypt.checkpw(plainText, hashedPassword)
    }

    val generateToken = { account: Account ->
        val claims = JwtClaims()
        claims.issuer = "Kotlin Eboshi API"
        claims.audience = listOf("eboshi user")
        claims.setExpirationTimeMinutesInTheFuture(10f)
        claims.setGeneratedJwtId()
        claims.setIssuedAtToNow();
        claims.setNotBeforeMinutesInThePast(2f)
        claims.setClaim("email", account.email)

        val jws = JsonWebSignature()
        jws.payload = claims.toJson()
        jws.key = rsaWebKey.rsaPrivateKey
        jws.keyIdHeaderValue = rsaWebKey.keyId
        jws.algorithmHeaderValue = AlgorithmIdentifiers.RSA_USING_SHA256
        jws.compactSerialization
    }

    /**
     * Returns the account email if the token is valid. Otherwise, will throw an InvalidJwtException
     */
    val validateToken = { token: String ->
        val jwtConsumer = JwtConsumerBuilder()
                .setRequireExpirationTime()
                .setAllowedClockSkewInSeconds(30)
                .setExpectedIssuer("Kotlin Eboshi API")
                .setExpectedAudience("eboshi user")
                .setVerificationKey(rsaWebKey.key)
                .build();
        val claims = jwtConsumer.processToClaims(token)
        claims.getClaimValue("email").toString()
    }
}

data class Encrypted(val hashedPassword: String, val salt: String)

