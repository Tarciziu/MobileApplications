package com.example.footballdb.feature_footballplayer.presentation.players

import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer

data class PlayersState(
    val players: List<FootballPlayer> = emptyList()
)