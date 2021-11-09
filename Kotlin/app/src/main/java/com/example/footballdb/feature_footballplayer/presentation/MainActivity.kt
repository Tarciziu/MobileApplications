package com.example.footballdb.feature_footballplayer.presentation

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.example.footballdb.feature_footballplayer.presentation.add_edit_player.AddEditPlayerScreen
import com.example.footballdb.feature_footballplayer.presentation.players.PlayersScreen
import com.example.footballdb.feature_footballplayer.presentation.util.Screen
import com.example.footballdb.ui.theme.FootballDBTheme
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            FootballDBTheme {
                androidx.compose.material.Surface (
                    color = MaterialTheme.colors.background
                ){
                    val navController = rememberNavController()
                    NavHost(
                        navController = navController,
                        startDestination = Screen.PlayersScreen.route
                    ){
                        composable(route = Screen.PlayersScreen.route){
                            PlayersScreen(navController = navController)
                        }
                        composable(
                            route = Screen.AddEditPlayerScreen.route +
                                    "?playerId={playerId}",
                            arguments = listOf(
                                navArgument(
                                    name = "playerId"
                                ){
                                    type = NavType.IntType
                                    defaultValue = -1
                                }
                            )
                        ){
                            AddEditPlayerScreen(navController = navController)
                        }
                    }
                }
            }
        }
    }
}