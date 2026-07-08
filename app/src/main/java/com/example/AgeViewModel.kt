package com.example

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.time.LocalDate

class AgeViewModel : ViewModel() {
    private val _birthDate = MutableStateFlow<LocalDate?>(null)
    val birthDate: StateFlow<LocalDate?> = _birthDate.asStateFlow()

    private val _calculationDate = MutableStateFlow<LocalDate>(LocalDate.now())
    val calculationDate: StateFlow<LocalDate> = _calculationDate.asStateFlow()

    private val _ageResult = MutableStateFlow<AgeResult?>(null)
    val ageResult: StateFlow<AgeResult?> = _ageResult.asStateFlow()

    private val _isDarkTheme = MutableStateFlow<Boolean?>(null) // null means use system default
    val isDarkTheme: StateFlow<Boolean?> = _isDarkTheme.asStateFlow()

    fun setBirthDate(date: LocalDate) {
        _birthDate.value = date
        calculate()
    }

    fun setCalculationDate(date: LocalDate) {
        _calculationDate.value = date
        calculate()
    }

    fun toggleTheme(isDark: Boolean) {
        _isDarkTheme.value = isDark
    }

    fun useSystemTheme() {
        _isDarkTheme.value = null
    }

    private fun calculate() {
        val bDate = _birthDate.value
        if (bDate != null) {
            _ageResult.value = AgeCalculator.calculate(bDate, _calculationDate.value)
        } else {
            _ageResult.value = null
        }
    }
}
