package com.example.footballdb.feature_footballplayer.domain.use_case

data class PlayerUseCases(
    val getPlayersUseCase: GetPlayersUseCase,
    val deletePlayer: DeletePlayer,
    val addPlayer: AddPlayer,
    val getPlayer: GetPlayer
)
