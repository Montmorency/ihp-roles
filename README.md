# ihp-roles
IHP Roles experiments with a few different patterns for handling authentication of different types of application role (User,Admin,Provider,etc.). 
The goes is to simplify some of the logic for authentication and rendering views to different roles. The `MakeRole`
type class is the major bit but the GADTs add some nice features as well and work well with the `?context` TypeMap.

e.g. we can allow for a number of the constraints to be dropped from type signatures:

`renderView :: Role a -> Html`

