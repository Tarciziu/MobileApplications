package com.example.footballdb.feature_footballplayer.presentation.players

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.material.AlertDialog
import androidx.compose.material.Button
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.footballdb.feature_footballplayer.domain.use_case.PlayerUseCases
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class PlayersViewModel @Inject constructor(
    private val playerUseCases: PlayerUseCases
) : ViewModel(){

    val showDialog = mutableStateOf(false)
    val deleteState = mutableStateOf(false)

    private val _state = mutableStateOf(PlayersState())
    val state: State<PlayersState> = _state

    private var getPlayersJob: Job? = null

    init {
        getPlayers()
    }

    fun onEvent(event: PlayersEvent){
        when(event){
            is PlayersEvent.DeletePlayer -> {
                viewModelScope.launch {
                    playerUseCases.deletePlayer(event.player)
                }
            }
        }
    }

    private fun getPlayers(){
        getPlayersJob?.cancel()
        getPlayersJob = playerUseCases.getPlayersUseCase()
            .onEach { players ->
                _state.value = state.value.copy(
                    players = players
                )
            }
            .launchIn(viewModelScope)
    }
}