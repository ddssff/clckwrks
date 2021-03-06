{-# LANGUAGE RecordWildCards #-}
module Clckwrks.ProfileData.Route where

import Clckwrks
import Clckwrks.ProfileData.Acid
import Clckwrks.ProfileData.EditProfileData (editProfileDataPage)
import Clckwrks.ProfileData.EditNewProfileData (editNewProfileDataPage)
import Clckwrks.ProfileData.EditProfileDataFor (editProfileDataForPage)
import Clckwrks.ProfileData.URL   (ProfileDataURL(..))
import Clckwrks.ProfileData.Types
import Control.Monad.State (get)
import Data.Set (singleton)
import Data.Text (Text)

routeProfileData :: ProfileDataURL -> Clck ProfileDataURL Response
routeProfileData url =
    case url of
      CreateNewProfileData ->
          do mUserId <- getUserId
             case mUserId of
               Nothing -> internalServerError $ toResponse $ "not logged in."
               (Just userId) ->
                   do let profileData = emptyProfileData { dataFor = userId
                                                         , roles   = singleton Visitor
                                                         }
                      (_, new) <- update (NewProfileData profileData)
                      if new
                         then seeOtherURL EditNewProfileData
                         else do mRedirect <- query GetLoginRedirect
                                 case mRedirect of
                                   (Just url) -> seeOther url (toResponse ())
                                   Nothing    -> do
                                     mRedirectCookie <- getRedirectCookie
                                     case mRedirectCookie of
                                       (Just u) -> seeOther u (toResponse ())
                                       Nothing  -> seeOtherURL EditProfileData
      EditProfileData ->
             do editProfileDataPage url
      EditNewProfileData ->
             do editNewProfileDataPage url
      EditProfileDataFor u ->
             do editProfileDataForPage url u

