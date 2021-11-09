package com.example.footballdb.feature_footballplayer.domain.use_case

import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer
import com.example.footballdb.feature_footballplayer.domain.repository.FootballPlayerRepository

class DeletePlayer(
    private val repository: FootballPlayerRepository
) {

    suspend operator fun invoke(player: FootballPlayer){
        repository.deletePlayer(player)
    }
}