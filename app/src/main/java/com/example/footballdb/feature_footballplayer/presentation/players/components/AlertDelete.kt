package com.example.footballdb.feature_footballplayer.presentation.players.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.material.AlertDialog
import androidx.compose.material.Button
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.example.footballdb.feature_footballplayer.presentation.players.PlayersViewModel

@Composable
fun alert(
    viewModel: PlayersViewModel = hiltViewModel()
) {
    AlertDialog(
        title = {
            Text(text = "Delete player")
        },
        text = {
            Text(text = "Are you sure that you want to delete this")
        },
        onDismissRequest = {
            viewModel.showDialog.value = false
        },
        buttons = {
            Row(
                modifier = Modifier.padding(all = 8.dp),
                horizontalArrangement = Arrangement.Center
            ) {
                Button(onClick = {
                    viewModel.showDialog.value = false
                    viewModel.deleteState.value = false
                }) {
                    Text("No")
                }
                Button(onClick = {
                    viewModel.showDialog.value = false
                    viewModel.deleteState.value = false
                }) {
                    Text("Yes")
                }
            }

        }

    )
}