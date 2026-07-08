package com.example

import java.time.LocalDate
import java.time.Period
import java.time.temporal.ChronoUnit
import java.time.format.TextStyle
import java.util.Locale

data class AgeResult(
    val years: Int,
    val months: Int,
    val days: Int,
    val totalDays: Long,
    val totalWeeks: Long,
    val totalMonths: Long,
    val dayOfWeek: String, // e.g. "Wednesday"
    val daysToNextBirthday: Long,
    val monthsToNextBirthday: Int,
    val remainingDaysToNextBirthday: Int,
    val nextBirthdayDayOfWeek: String, // Day of week of next birthday
    val isBirthdayToday: Boolean
)

object AgeCalculator {
    fun calculate(birthDate: LocalDate, today: LocalDate = LocalDate.now()): AgeResult? {
        if (birthDate.isAfter(today)) return null

        val period = Period.between(birthDate, today)
        val years = period.years
        val months = period.months
        val days = period.days

        val totalDays = ChronoUnit.DAYS.between(birthDate, today)
        val totalWeeks = totalDays / 7
        val totalMonths = ChronoUnit.MONTHS.between(birthDate, today)

        val dayOfWeek = birthDate.dayOfWeek.getDisplayName(TextStyle.FULL, Locale.getDefault())

        // Calculate next birthday
        var nextBirthday = birthDate.withYear(today.year)
        val isBirthdayToday = birthDate.month == today.month && birthDate.dayOfMonth == today.dayOfMonth

        if (nextBirthday.isBefore(today) || nextBirthday.isEqual(today)) {
            nextBirthday = nextBirthday.plusYears(1)
        }

        val daysToNextBirthday = ChronoUnit.DAYS.between(today, nextBirthday)

        val nextBirthdayPeriod = Period.between(today, nextBirthday)
        val monthsToNextBirthday = nextBirthdayPeriod.months
        val remainingDaysToNextBirthday = nextBirthdayPeriod.days

        val nextBirthdayDayOfWeek = nextBirthday.dayOfWeek.getDisplayName(TextStyle.FULL, Locale.getDefault())

        return AgeResult(
            years = years,
            months = months,
            days = days,
            totalDays = totalDays,
            totalWeeks = totalWeeks,
            totalMonths = totalMonths,
            dayOfWeek = dayOfWeek,
            daysToNextBirthday = daysToNextBirthday,
            monthsToNextBirthday = monthsToNextBirthday,
            remainingDaysToNextBirthday = remainingDaysToNextBirthday,
            nextBirthdayDayOfWeek = nextBirthdayDayOfWeek,
            isBirthdayToday = isBirthdayToday
        )
    }
}
