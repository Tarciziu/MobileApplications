package com.example.footballdb.feature_footballplayer.presentation.add_edit_player

import androidx.compose.ui.focus.FocusState

sealed class AddEditPlayerEvent {
    data class EnteredName(val value: String): AddEditPlayerEvent()
    data class ChangeNameFocus(val focus: FocusState): AddEditPlayerEvent()

    data class EnteredTeam(val value: String): AddEditPlayerEvent()
    data class ChangeTeamFocus(val focus: FocusState): AddEditPlayerEvent()

    data class EnteredPosition(val value: String): AddEditPlayerEvent()
    data class ChangePositionFocus(val focus: FocusState): AddEditPlayerEvent()

    data class EnteredMarketValue(val value: String): AddEditPlayerEvent()
    data class ChangeMarketValueFocus(val focus: FocusState): AddEditPlayerEvent()

    data class EnteredAge(val value: String): AddEditPlayerEvent()
    data class ChangeAgeFocus(val focus: FocusState): AddEditPlayerEvent()

    object SavePlayer: AddEditPlayerEvent()
}
