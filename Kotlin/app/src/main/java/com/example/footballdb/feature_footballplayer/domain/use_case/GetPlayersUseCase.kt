package com.example.footballdb.feature_footballplayer.domain.use_case

import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer
import com.example.footballdb.feature_footballplayer.domain.repository.FootballPlayerRepository
import kotlinx.coroutines.flow.Flow

class GetPlayersUseCase(
    private val repository: FootballPlayerRepository
) {

    operator fun invoke(): Flow<List<FootballPlayer>>{
        return repository.getPlayers()
    }
}