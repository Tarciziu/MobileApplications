package com.example.footballdb.feature_footballplayer.presentation.util

sealed class Screen(
    val route: String
){
    object PlayersScreen: Screen("players_screen")
    object AddEditPlayerScreen: Screen("add_edit_player_screen")
}
