package com.example.footballdb.di

import android.app.Application
import androidx.room.Room
import com.example.footballdb.feature_footballplayer.data.data_source.PlayerDatabase
import com.example.footballdb.feature_footballplayer.data.repository.FootballPlayerRepositoryImpl
import com.example.footballdb.feature_footballplayer.domain.repository.FootballPlayerRepository
import com.example.footballdb.feature_footballplayer.domain.use_case.*
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun providePlayersDatabase(app: Application): PlayerDatabase{
        return Room.databaseBuilder(
            app,
            PlayerDatabase::class.java,
            PlayerDatabase.DATABASE_NAME
        ).build()
    }

    @Provides
    @Singleton
    fun provideFootballPlayerRepository(db: PlayerDatabase): FootballPlayerRepository{
        return FootballPlayerRepositoryImpl(db.playerDao)
    }

    @Provides
    @Singleton
    fun providePlayerUseCases(repository: FootballPlayerRepository): PlayerUseCases{
        return PlayerUseCases(
                getPlayersUseCase = GetPlayersUseCase(repository),
                deletePlayer = DeletePlayer(repository),
                addPlayer = AddPlayer(repository),
                getPlayer = GetPlayer(repository)
            )
    }
}