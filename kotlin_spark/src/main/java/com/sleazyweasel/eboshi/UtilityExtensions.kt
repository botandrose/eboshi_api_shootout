package com.sleazyweasel.eboshi

import com.google.gson.Gson
import com.google.inject.Injector
import kotlin.reflect.KClass

fun <T : Any> Injector.instance(kotlinClass: KClass<T>) = getInstance(kotlinClass.java)
fun <T : Any> Gson.fromJson(content: String, kClass: KClass<T>) = fromJson(content, kClass.java)
