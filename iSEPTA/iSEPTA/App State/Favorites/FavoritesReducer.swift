//
//  FavoritesReducer.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/3/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import ReSwift

struct FavoritesReducer {

    static func main(action: Action, state: FavoritesState?) -> FavoritesState {
        if let state = state {
            guard let action = action as? FavoritesAction else { return state }
            return reduceFavoritesAction(action: action, state: state)
        } else {
            return FavoritesState()
        }
    }

    static func reduceFavoritesAction(action: FavoritesAction, state: FavoritesState) -> FavoritesState {
        var favoritesState = state
        switch action {
        case let action as LoadFavorites:
            favoritesState = reduceLoadFavorites(action: action, state: state)
        case let action as AddFavorite:
            favoritesState = reduceAddFavorite(action: action, state: state)
        case let action as EditFavorite:
            favoritesState = reduceEditFavorite(action: action, state: state)
        case let action as SaveFavorite:
            favoritesState = reduceSaveFavorite(action: action, state: state)
        case let action as CancelFavoriteEdit:
            favoritesState = reduceCancelFavoriteEdit(action: action, state: state)
        case let action as RemoveFavorite:
            favoritesState = reduceRemoveFavorite(action: action, state: state)
        case let action as UpdateFavorite:
            favoritesState = reduceUpdateFavorite(action: action, state: state)
        case let action as CreateNextToArriveFavorite:
            favoritesState = reduceCreateNextToArriveFavorite(action: action, state: state)
        default:
            break
        }

        return favoritesState
    }

    static func reduceLoadFavorites(action: LoadFavorites, state: FavoritesState) -> FavoritesState {
        var newState = FavoritesState(favorites: action.favorites)
        newState.favoriteToEdit = state.favoriteToEdit

        return newState
    }

    static func reduceAddFavorite(action: AddFavorite, state: FavoritesState) -> FavoritesState {
        var newState = state
        newState.favoriteToEdit = action.favorite
        return newState
    }

    static func reduceEditFavorite(action: EditFavorite, state: FavoritesState) -> FavoritesState {
        var favoriteState = state
        favoriteState.favoriteToEdit = action.favorite
        return favoriteState
    }

    static func reduceSaveFavorite(action: SaveFavorite, state: FavoritesState) -> FavoritesState {
        var favorites = state.favorites.filter { $0.favoriteId != action.favorite.favoriteId }
        favorites.append(action.favorite)
        var favoriteState = FavoritesState(favorites: favorites)
        favoriteState.favoriteToEdit = nil
        favoriteState.nextToArriveFavoriteId = state.nextToArriveFavoriteId
        return favoriteState
    }

    static func reduceCancelFavoriteEdit(action _: CancelFavoriteEdit, state: FavoritesState) -> FavoritesState {
        var favoriteState = FavoritesState(favorites: state.favorites)
        favoriteState.favoriteToEdit = nil
        favoriteState.nextToArriveFavoriteId = state.nextToArriveFavoriteId
        return favoriteState
    }

    static func reduceRemoveFavorite(action: RemoveFavorite, state: FavoritesState) -> FavoritesState {
        let favorites = state.favorites.filter { $0 != action.favorite }
        var favoriteState = FavoritesState(favorites: favorites)
        favoriteState.favoriteToEdit = nil
        favoriteState.nextToArriveFavoriteId = nil
        return favoriteState
    }

    static func reduceUpdateFavorite(action: UpdateFavorite, state: FavoritesState) -> FavoritesState {
        guard var matchingFavorite = state.favorites.filter({ $0.favoriteId == action.favorite.favoriteId }).first else { return state }
        matchingFavorite.nextToArriveTrips = action.favorite.nextToArriveTrips
        matchingFavorite.nextToArriveUpdateStatus = action.favorite.nextToArriveUpdateStatus
        matchingFavorite.refreshDataRequested = action.favorite.refreshDataRequested

        var otherFavorites = state.favorites.filter { $0.favoriteId != matchingFavorite.favoriteId }
        otherFavorites.append(matchingFavorite)
        var favoriteState = FavoritesState(favorites: otherFavorites)
        favoriteState.nextToArriveFavoriteId = state.nextToArriveFavoriteId
        favoriteState.favoriteToEdit = state.favoriteToEdit
        return favoriteState
    }

    static func reduceCreateNextToArriveFavorite(action: CreateNextToArriveFavorite, state: FavoritesState) -> FavoritesState {
        var newState = state
        newState.nextToArriveFavoriteId = action.favorite.favoriteId
        return newState
    }
}
