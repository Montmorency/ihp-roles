module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

-- Controller Imports
import Web.Controller.Static
import IHP.LoginSupport.Middleware
import Web.Controller.Sessions
import Web.Controller.Admin
import Web.Controller.Users


instance FrontController WebApplication where
    controllers = 
        [ startPage WelcomeAction
        , parseRoute @SessionsController -- <--------------- add this
        , parseRoute @UsersController
        , parseRoute @AdminController
        -- Generator Marker
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAuthentication @User
        initAuthentication @Admin
        initRoleAuthentication @User --Need to chain these together lambda on a list of types or TypeReps?
        initRoleAuthentication @Admin
        initAutoRefresh
