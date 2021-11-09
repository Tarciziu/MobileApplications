package com.example.footballdb.feature_footballplayer.domain.repository

import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer
import kotlinx.coroutines.flow.Flow

interface FootballPlayerRepository {

    fun getPlayers(): Flow<List<FootballPlayer>>

    suspend fun getPlayerById(id: Int): FootballPlayer?

    suspend fun insertPlayer(player: FootballPlayer)

    suspend fun deletePlayer(player: FootballPlayer)
}