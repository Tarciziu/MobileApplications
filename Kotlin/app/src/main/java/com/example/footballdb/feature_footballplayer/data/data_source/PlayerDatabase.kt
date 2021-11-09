package com.example.footballdb.feature_footballplayer.data.data_source

import androidx.room.Database
import androidx.room.RoomDatabase
import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer

@Database(
    entities = [FootballPlayer::class],
    version = 1
)
abstract class PlayerDatabase : RoomDatabase() {

    abstract val playerDao: FootballPlayerDao

    companion object {
        const val DATABASE_NAME = "players_db"
    }
}