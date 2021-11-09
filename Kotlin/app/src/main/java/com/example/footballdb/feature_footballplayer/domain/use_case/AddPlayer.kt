package com.example.footballdb.feature_footballplayer.domain.use_case

import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer
import com.example.footballdb.feature_footballplayer.domain.model.InvalidFootballPlayerException
import com.example.footballdb.feature_footballplayer.domain.repository.FootballPlayerRepository

class AddPlayer (
    private val repository: FootballPlayerRepository
) {

    @Throws(InvalidFootballPlayerException::class)
    suspend operator fun invoke(player: FootballPlayer){
        if(player.name.isBlank()){
            throw InvalidFootballPlayerException("The name of the player can't be empty.")
        }
        if(player.position.isBlank()){
            throw InvalidFootballPlayerException("The position of the player can't be empty.")
        }
        if(player.team.isBlank()){
            throw InvalidFootballPlayerException("The team of the player can't be empty.")
        }
        /*if(player.market_value<0){
            throw InvalidFootballPlayerException("The market value of the player can't be negative.")
        }*/
        repository.insertPlayer(player)
    }
}