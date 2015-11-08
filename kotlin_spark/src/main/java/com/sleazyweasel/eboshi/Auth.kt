package com.sleazyweasel.eboshi

import org.mindrot.jbcrypt.BCrypt

class Auth {
    val encrypt = { password: String ->
        val salt = BCrypt.gensalt()
        val hashedPassword = BCrypt.hashpw(password, salt)
        Encrypted(hashedPassword, salt)
    }

    val verify = { plainText: String, hashedPassword: String ->
        BCrypt.checkpw(plainText, hashedPassword)
    }
}

data class Encrypted(val hashedPassword: String, val salt: String)

