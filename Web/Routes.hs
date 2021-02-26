module Web.Routes where
import IHP.RouterPrelude
import Generated.Types
import Web.Types

-- Generator Marker
instance AutoRoute StaticController
instance AutoRoute UsersController

instance AutoRoute AdminController
instance AutoRoute SessionsController

