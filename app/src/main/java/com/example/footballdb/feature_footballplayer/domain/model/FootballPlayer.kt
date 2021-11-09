package com.example.footballdb.feature_footballplayer.domain.model

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.*

@Entity(tableName = "players")
data class FootballPlayer(
    @PrimaryKey val id: Int? = null,
    val name: String,
    val team: String,
    val market_value: String,
    val position: String,
    val age: String
){

}

class InvalidFootballPlayerException(message: String): Exception(message)
