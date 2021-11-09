package com.example.footballdb.feature_footballplayer.presentation.add_edit_player

import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Save
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.example.footballdb.feature_footballplayer.presentation.add_edit_player.components.TransparentHintTextField
import kotlinx.coroutines.flow.collectLatest

@Composable
fun AddEditPlayerScreen(
    navController: NavController,
    viewModel: AddEditPlayerViewModel = hiltViewModel()
){
    val nameState = viewModel.playerName.value
    val teamState = viewModel.playerTeam.value
    val positionState = viewModel.playerPosition.value
    val marketValueState = viewModel.playerMV.value
    val ageState = viewModel.playerAge.value

    val scaffoldState = rememberScaffoldState()
    
    LaunchedEffect(key1 = true){
        viewModel.eventFlow.collectLatest { event ->
            when(event){
                is AddEditPlayerViewModel.UiEvent.ShowSnackbar -> {
                    scaffoldState.snackbarHostState.showSnackbar(
                        message = event.message
                    )
                }
                is AddEditPlayerViewModel.UiEvent.SaveNote -> {
                    navController.navigateUp()
                }
            }
        }
    }

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(onClick = {
                viewModel.onEvent(AddEditPlayerEvent.SavePlayer)
            },
                backgroundColor = MaterialTheme.colors.primary
            ) {
                Icon(imageVector = Icons.Default.Save, contentDescription = "Save player")
            }
        },
        scaffoldState = scaffoldState
    ){
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp)
        ) {
            TransparentHintTextField(
                text = nameState.text,
                hint = nameState.hint,
                onValueChange = {
                    viewModel.onEvent(AddEditPlayerEvent.EnteredName(it))
                },
                onFocusChange = {
                    viewModel.onEvent(AddEditPlayerEvent.ChangeNameFocus(it))
                },
                isHintVisible = nameState.isHintVisible,
                singleLine = true,
                textStyle = MaterialTheme.typography.h5
            )
            Spacer(modifier = Modifier.height(16.dp))
            TransparentHintTextField(
                text = teamState.text,
                hint = teamState.hint,
                onValueChange = {
                    viewModel.onEvent(AddEditPlayerEvent.EnteredTeam(it))
                },
                onFocusChange = {
                    viewModel.onEvent(AddEditPlayerEvent.ChangeTeamFocus(it))
                },
                isHintVisible = teamState.isHintVisible,
                singleLine = true,
                textStyle = MaterialTheme.typography.body1
            )
            Spacer(modifier = Modifier.height(16.dp))
            TransparentHintTextField(
                text = positionState.text,
                hint = positionState.hint,
                onValueChange = {
                    viewModel.onEvent(AddEditPlayerEvent.EnteredPosition(it))
                },
                onFocusChange = {
                    viewModel.onEvent(AddEditPlayerEvent.ChangePositionFocus(it))
                },
                isHintVisible = positionState.isHintVisible,
                singleLine = true,
                textStyle = MaterialTheme.typography.body1
            )
            Spacer(modifier = Modifier.height(16.dp))
            TransparentHintTextField(
                text = marketValueState.text,
                hint = marketValueState.hint,
                onValueChange = {
                    viewModel.onEvent(AddEditPlayerEvent.EnteredMarketValue(it))
                },
                onFocusChange = {
                    viewModel.onEvent(AddEditPlayerEvent.ChangeMarketValueFocus(it))
                },
                isHintVisible = marketValueState.isHintVisible,
                singleLine = true,
                textStyle = MaterialTheme.typography.body1
            )
            Spacer(modifier = Modifier.height(16.dp))
            TransparentHintTextField(
                text = ageState.text,
                hint = ageState.hint,
                onValueChange = {
                    viewModel.onEvent(AddEditPlayerEvent.EnteredAge(it))
                },
                onFocusChange = {
                    viewModel.onEvent(AddEditPlayerEvent.ChangeAgeFocus(it))
                },
                isHintVisible = ageState.isHintVisible,
                singleLine = true,
                textStyle = MaterialTheme.typography.body1
            )
        }
    }
}