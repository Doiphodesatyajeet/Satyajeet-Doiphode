package com.example.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext

private val DarkColorScheme = darkColorScheme(
    primary = GeoPrimary,
    onPrimary = GeoOnPrimary,
    primaryContainer = GeoPrimaryContainer,
    onPrimaryContainer = GeoOnPrimaryContainer,
    secondary = GeoPrimary,
    onSecondary = GeoOnPrimary,
    secondaryContainer = GeoPrimaryContainer,
    onSecondaryContainer = GeoOnPrimaryContainer,
    tertiary = GeoPrimary,
    background = GeoBackground,
    onBackground = GeoOnBackground,
    surface = GeoSurface,
    onSurface = GeoOnSurface,
    surfaceVariant = GeoSurfaceVariantSolid,
    onSurfaceVariant = GeoOnSurfaceVariant,
    outline = GeoOutline
)

private val LightColorScheme = lightColorScheme(
    primary = GeoPrimaryLight,
    onPrimary = GeoOnPrimaryLight,
    primaryContainer = GeoPrimaryContainer,
    onPrimaryContainer = GeoOnPrimaryContainer,
    secondary = GeoPrimaryLight,
    onSecondary = GeoOnPrimaryLight,
    secondaryContainer = GeoPrimaryContainer,
    onSecondaryContainer = GeoOnPrimaryContainer,
    tertiary = GeoPrimaryLight,
    background = GeoBackgroundLight,
    onBackground = GeoOnBackgroundLight,
    surface = GeoSurfaceLight,
    onSurface = GeoOnSurfaceLight,
    surfaceVariant = GeoSurfaceLight,
    onSurfaceVariant = GeoOnSurfaceVariantLight,
    outline = GeoOutlineLight
)

@Composable
fun MyApplicationTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = false,
    content: @Composable () -> Unit,
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}
