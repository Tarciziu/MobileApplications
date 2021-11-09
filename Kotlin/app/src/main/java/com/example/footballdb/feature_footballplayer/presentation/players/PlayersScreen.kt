package com.example.footballdb.feature_footballplayer.presentation.players

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.example.footballdb.feature_footballplayer.presentation.players.components.PlayerItem
import com.example.footballdb.feature_footballplayer.presentation.util.Screen
import kotlinx.coroutines.launch

@Composable
fun PlayersScreen(
    navController: NavController,
    viewModel: PlayersViewModel = hiltViewModel()
){
    val state = viewModel.state.value
    val scaffoldState = rememberScaffoldState()
    val scope = rememberCoroutineScope()

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(
                onClick = {
                    navController.navigate(Screen.AddEditPlayerScreen.route)
                },
                backgroundColor = MaterialTheme.colors.primary
            ) {
                Icon(imageVector = Icons.Default.Add, contentDescription = "Add player")
            }
        },
        scaffoldState = scaffoldState
    ){
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Players",
                    style = MaterialTheme.typography.h4
                )
            }
            Spacer(modifier = Modifier.height(16.dp))
            LazyColumn(modifier = Modifier.fillMaxSize()) {
                items(state.players) { player ->
                    PlayerItem(
                        player = player,
                        modifier = Modifier.fillMaxWidth()
                            .clickable {
                                navController.navigate(
                                    Screen.AddEditPlayerScreen.route +
                                            "?playerId=${player.id}"
                                )
                            },
                        onDeleteClick = {
                                viewModel.onEvent(PlayersEvent.DeletePlayer(player))
                                scope.launch {
                                    scaffoldState.snackbarHostState.showSnackbar(
                                        message = "Player deleted"
                                    )
                                }
                        }
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                }
            }
        }
    }
}