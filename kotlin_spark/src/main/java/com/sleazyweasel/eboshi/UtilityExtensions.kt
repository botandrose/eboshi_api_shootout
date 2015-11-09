package com.sleazyweasel.eboshi

import com.google.gson.Gson
import com.google.inject.Injector
import kotlin.reflect.KClass

fun <T : Any> Injector.instance(kotlinClass: KClass<T>) = getInstance(kotlinClass.java)
fun <T : Any> Gson.fromJson(content: String, kClass: KClass<T>) = fromJson(content, kClass.java)

fun <K, V> Map<K, V>.plusIfAbsent(pair: Pair<K, V>) {
    if (!containsKey(pair.first)) plus(pair) else this
}

fun <K, V> Map<K, V>.plusIfAbsent(pairs: kotlin.Iterable<kotlin.Pair<K, V>>): Map<K, V> {
    return plus(pairs.filter { !containsKey(it.first) })
}

