module Web.Controller.Sessions where

import Web.Controller.Prelude
import Web.View.Sessions.New
import Web.View.Sessions.NewAdmin

import qualified IHP.AuthSupport.Controller.Sessions as Sessions

instance Controller SessionsController where
    action NewSessionAction = Sessions.newSessionAction @User
    action CreateSessionAction = Sessions.createSessionAction @User
    action DeleteSessionAction = Sessions.deleteSessionAction @User

    action NewAdminSessionAction = Sessions.newSessionAction @Admin
    action CreateAdminSessionAction = Sessions.createSessionAction @Admin
    action DeleteAdminSessionAction = Sessions.deleteSessionAction @Admin

instance Sessions.SessionsControllerConfig User

instance Sessions.SessionsControllerConfig Admin 

