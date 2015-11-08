package com.sleazyweasel.eboshi

import org.mockito.Mockito
import kotlin.reflect.KClass

fun <T : Any> mock(kclass: KClass<T>) = Mockito.mock(kclass.java)


