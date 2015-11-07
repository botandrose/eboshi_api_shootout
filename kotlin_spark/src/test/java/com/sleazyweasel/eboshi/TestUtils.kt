package com.sleazyweasel.eboshi

import org.mockito.Mockito
import kotlin.reflect.KClass

fun <T : Any> mock(kclass: KClass<T>) = Mockito.mock(kclass.java)
fun <T : Any> mockDeep(kclass: KClass<T>) = Mockito.mock(kclass.java, Mockito.RETURNS_DEEP_STUBS)


