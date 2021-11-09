package com.example.footballdb.feature_footballplayer.presentation.players

import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer

sealed class PlayersEvent{
    data class DeletePlayer(val player: FootballPlayer): PlayersEvent()

}
