package com.example.footballdb.feature_footballplayer.domain.use_case

import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer
import com.example.footballdb.feature_footballplayer.domain.repository.FootballPlayerRepository

class GetPlayer(
    private val repository: FootballPlayerRepository
) {
    suspend operator fun invoke(id: Int): FootballPlayer?{
        return repository.getPlayerById(id)
    }
}