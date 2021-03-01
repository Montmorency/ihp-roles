{-# LANGUAGE GADTs #-}
{-# LANGUAGE AllowAmbiguousTypes #-}
module Application.Helper.Controller where

import IHP.ControllerPrelude
import Generated.Types

import IHP.Prelude hiding (show, cast)
import IHP.ControllerSupport
import IHP.Controller.Param
import IHP.Controller.Session
import IHP.LoginSupport.Helper.Controller
import IHP.LoginSupport.Types
import IHP.ValidationSupport.Types (ValidatorResult(..))
import IHP.FrameworkConfig ()

import IHP.Controller.Redirect (redirectToPath)
--import IHP.Fetch

import System.IO.Unsafe (unsafePerformIO)

import qualified Data.Text as T
import qualified Control.Newtype.Generics as Newtype

import Text.Regex.TDFA
import Text.Regex.TDFA.Text 

--Double DataType
import IHP.ModelSupport (PrimaryKey)
import IHP.QueryBuilder (FilterPrimaryKey)
import IHP.Controller.Context

--import Data.Typeable (cast, typeRep, typeOf)
import qualified Data.TMap as TypeMap

import Data.Data (
                   cast
                 , gcast
                 , TypeRep(..)
                 , typeRep
                 , showConstr
                 , readConstr 
                 )

-- Here you can add functions which are available in all your controllers

data Role a where
    UserRole :: User -> Role User
    AdminRole :: Admin -> Role Admin

deriving instance (Eq a) => Eq (Role a)
deriving instance (Show a) => Show (Role a)
deriving instance (Typeable a) => Typeable (Role a)


pullRole :: forall a.(?context :: ControllerContext, Typeable a) => Maybe (Role a)
pullRole =  case ?context of 
                FrozenControllerContext { customFields } -> TypeMap.lookup @(Role a) customFields 
                ControllerContext {} -> error ("maybeFromFrozenContext called on a non frozen context while trying to access Role.")

class MakeRole a where
    makeRole :: (Typeable a) => a -> Role a
    getRoleOrNothing :: (?context :: ControllerContext, Typeable a) => Proxy a -> Maybe (Role a)
--  possible methods for serializing and deserializing Role specific session data.
--    pullSessionData :: (?context :: ControllerContext, Monad m) => Role a -> m a 
--    pushSessionData :: (?context :: ControllerContext, Monad m) => Role a -> m a 

instance MakeRole User where
    makeRole a = UserRole a
    getRoleOrNothing a = pullRole @User  

instance MakeRole Admin where
    makeRole a = AdminRole  a
    getRoleOrNothing a = pullRole @Admin 

initRoleAuthentication :: forall user.(
                                        ?context :: ControllerContext
                                      , ?modelContext:: ModelContext
                                      , Typeable (NormalizeModel user)
                                      , KnownSymbol (GetTableName (NormalizeModel user))
                                      , KnownSymbol (GetModelName user)
                                      , GetTableName (NormalizeModel user) ~ GetTableName user
                                      , FromRow (NormalizeModel user)
                                      , PrimaryKey (GetTableName user) ~ UUID
                                      , FilterPrimaryKey (GetTableName user)
                                      ) => IO ()
initRoleAuthentication  = do
    role <- getSessionUUID (sessionKey @user)
            >>= pure . fmap (Newtype.pack @(Id user))
            >>= fetchOneOrNothing
    putStrLn ("InitRoles " <> sessionKey @user)
    putStrLn (case role of 
                Just user -> "user" 
                Nothing -> "Nowt."
             )
    case role of
        Just user -> do
                        case (cast user :: Maybe User) of 
                             Just user -> do 
                                            putStrLn "Found User"
                                            putContext (makeRole user) 
                             Nothing -> case (cast user :: Maybe Admin) of
                                             Just admin -> do
                                                        putStrLn "Found Admin"
                                                        putContext (makeRole admin) 
                                             Nothing -> do 
                                                      putStrLn "Found Nothing Admin Route"
                                                      pure ()  
        Nothing -> pure () 

-- Role Helper Functions
currentRoleOrNothing :: forall a.(?context :: ControllerContext, Typeable (Role a)) => (Maybe (Role a))
currentRoleOrNothing = case unsafePerformIO (maybeFromContext @(Maybe (Role a))) of
                                    Just role -> role
                                    Nothing -> error "currentRoleOrNothing: initRoleAuthentication "

currentRole :: forall a.(?context :: ControllerContext, HasNewSessionUrl a, Typeable (Role a)) => Role a
currentRole = fromMaybe (redirectToLogin (newSessionUrl (Proxy @a))) currentRoleOrNothing

redirectToLogin :: (?context :: ControllerContext) => Text -> a
redirectToLogin newSessionPath = unsafePerformIO $ do
    redirectToPath newSessionPath
    error "Unreachable"

--deriving instance Typeable (Role Admin)
--deriving instance Typeable (Role User)
--deriving instance Typeable User 
--deriving instance Typeable Admin 
--type family RoleFamily a where
--RoleFamily User  = User
--RoleFamily Admin = Admin
