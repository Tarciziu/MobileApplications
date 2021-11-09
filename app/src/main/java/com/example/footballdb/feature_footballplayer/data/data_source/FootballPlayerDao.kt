package com.example.footballdb.feature_footballplayer.data.data_source

import androidx.room.*
import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer
import kotlinx.coroutines.flow.Flow

@Dao
interface FootballPlayerDao {

    @Query("SELECT * FROM players")
    fun getPlayers(): Flow<List<FootballPlayer>>

    @Query("SELECT * FROM players WHERE id = :id")
    suspend fun getPlayerById(id: Int): FootballPlayer?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertPlayer(player: FootballPlayer)

    @Delete
    suspend fun deletePlayer(player: FootballPlayer)
}