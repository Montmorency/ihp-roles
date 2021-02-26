module Application.Helper.View where

import IHP.ViewPrelude

import Application.Helper.Controller (
                                      Role (..)
                                    , RoleFamily
                                    , makeRole
                                    , getRoleOrNothing
                                    )
import qualified Data.TMap as TypeMap
import Generated.Types

-- Here you can add functions which are available in all your views

--currentRoleOrNothing :: forall a.(?context :: ControllerContext) => Maybe (Role a)
--currentRoleOrNothing = getRoleOrNothing (Proxy Admin :: Admin)
                        
roleDependentView :: Maybe (Role a) -> Html
roleDependentView (Just (UserRole user))  =  [hsx| Hello, User:  {get #name user} |]
roleDependentView (Just (AdminRole admin))  = [hsx| Hello, Admin:  {get #name admin} |]
roleDependentView Nothing = [hsx| No Role Is Logged In. |]

