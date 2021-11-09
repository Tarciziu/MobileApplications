package com.example.footballdb.feature_footballplayer.presentation.add_edit_player

import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.footballdb.feature_footballplayer.domain.model.FootballPlayer
import com.example.footballdb.feature_footballplayer.domain.model.InvalidFootballPlayerException
import com.example.footballdb.feature_footballplayer.domain.use_case.PlayerUseCases
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.launch
import java.time.Instant
import java.util.*
import javax.inject.Inject

@HiltViewModel
class AddEditPlayerViewModel @Inject constructor(
    private val playerUseCases: PlayerUseCases,
    savedStateHandle: SavedStateHandle
): ViewModel() {

    private val _playerName = mutableStateOf(PlayerNameFieldState(
        hint = "Enter player's name..."
    ))
    val playerName: State<PlayerNameFieldState> = _playerName

    private val _playerTeam = mutableStateOf(PlayerNameFieldState(
        hint = "Enter player's team..."
    ))
    val playerTeam: State<PlayerNameFieldState> = _playerTeam

    private val _playerPosition = mutableStateOf(PlayerNameFieldState(
        hint = "Enter player's position..."
    ))
    val playerPosition: State<PlayerNameFieldState> = _playerPosition

    private val _playerMV = mutableStateOf(PlayerNameFieldState(
        hint = "Enter player's value..."
    ))
    val playerMV: State<PlayerNameFieldState> = _playerMV

    private val _playerAge = mutableStateOf(PlayerNameFieldState(
        hint = "Enter player's age..."
    ))
    val playerAge: State<PlayerNameFieldState> = _playerAge

    private val _eventFlow = MutableSharedFlow<UiEvent>()
    val eventFlow = _eventFlow.asSharedFlow()

    private var currentPlayerId: Int? = null

    init {
        savedStateHandle.get<Int>("playerId")?.let{
            playerId -> if(playerId != -1){
                viewModelScope.launch {
                    playerUseCases.getPlayer(playerId)?.also{ player ->
                        currentPlayerId = player.id
                        _playerName.value = playerName.value.copy(
                            text = player.name,
                            isHintVisible = false
                        )
                        _playerTeam.value = playerTeam.value.copy(
                            text = player.team,
                            isHintVisible = false
                        )
                        _playerPosition.value = playerPosition.value.copy(
                            text = player.position,
                            isHintVisible = false
                        )
                        _playerMV.value = playerMV.value.copy(
                            text = player.market_value,
                            isHintVisible = false
                        )
                        _playerAge.value = playerAge.value.copy(
                            text = player.age,
                            isHintVisible = false
                        )
                    }
                }
            }
        }
    }

    fun onEvent(event: AddEditPlayerEvent){
        when(event){
            is AddEditPlayerEvent.EnteredName -> {
                _playerName.value = playerName.value.copy(
                    text = event.value
                )
            }
            is AddEditPlayerEvent.ChangeNameFocus -> {
                _playerName.value = playerName.value.copy(
                    isHintVisible = !event.focus.isFocused &&
                            playerName.value.text.isBlank()
                )
            }


            is AddEditPlayerEvent.EnteredTeam -> {
                _playerTeam.value = playerTeam.value.copy(
                    text = event.value
                )
            }
            is AddEditPlayerEvent.ChangeTeamFocus -> {
                _playerTeam.value = playerTeam.value.copy(
                    isHintVisible = !event.focus.isFocused &&
                            playerTeam.value.text.isBlank()
                )
            }


            is AddEditPlayerEvent.EnteredPosition -> {
                _playerPosition.value = playerPosition.value.copy(
                    text = event.value
                )
            }
            is AddEditPlayerEvent.ChangePositionFocus -> {
                _playerPosition.value = playerPosition.value.copy(
                    isHintVisible = !event.focus.isFocused &&
                            playerPosition.value.text.isBlank()
                )
            }


            is AddEditPlayerEvent.EnteredMarketValue -> {
                _playerMV.value = playerMV.value.copy(
                    text = event.value
                )
            }

            is AddEditPlayerEvent.ChangeMarketValueFocus -> {
                _playerMV.value = playerMV.value.copy(
                    isHintVisible = !event.focus.isFocused &&
                            playerMV.value.text.isBlank()
                )
            }

            is AddEditPlayerEvent.EnteredAge -> {
                _playerAge.value = playerAge.value.copy(
                    text = event.value
                )
            }

            is AddEditPlayerEvent.ChangeAgeFocus -> {
                _playerAge.value = playerAge.value.copy(
                    isHintVisible = !event.focus.isFocused &&
                            playerAge.value.text.isBlank()
                )
            }

            is AddEditPlayerEvent.SavePlayer -> {
                viewModelScope.launch {
                    try{
                        playerUseCases.addPlayer(
                            FootballPlayer(
                                name = playerName.value.text,
                                team = playerTeam.value.text,
                                position = playerPosition.value.text,
                                market_value = playerMV.value.text,
                                id = currentPlayerId,
                                age = playerAge.value.text
                            )
                        )
                        _eventFlow.emit(UiEvent.SaveNote)
                    }catch(e: InvalidFootballPlayerException){
                        _eventFlow.emit(
                            UiEvent.ShowSnackbar(
                                message = e.message?: " Coudln't add player"
                            )
                        )
                    }
                }
            }

        }
    }

    sealed class UiEvent{
        data class ShowSnackbar(val message: String): UiEvent()
        object SaveNote: UiEvent()
    }
}