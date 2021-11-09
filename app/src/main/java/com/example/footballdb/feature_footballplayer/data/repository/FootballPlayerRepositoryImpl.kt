package com.example.footballdb.feature_footballplayer.data.repository

import com.example.footballdb.feature_footballplayer.data.data_source.FootballPlayerDao
import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer
import com.example.footballdb.feature_footballplayer.domain.repository.FootballPlayerRepository
import kotlinx.coroutines.flow.Flow

class FootballPlayerRepositoryImpl(
    private val dao: FootballPlayerDao
) : FootballPlayerRepository {

    override fun getPlayers(): Flow<List<FootballPlayer>> {
        return dao.getPlayers()
    }

    override suspend fun getPlayerById(id: Int): FootballPlayer? {
        return dao.getPlayerById(id)
    }

    override suspend fun insertPlayer(player: FootballPlayer) {
        dao.insertPlayer(player)
    }

    override suspend fun deletePlayer(player: FootballPlayer) {
        dao.deletePlayer(player)
    }
}