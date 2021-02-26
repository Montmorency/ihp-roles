module Web.Controller.Admin where

import Web.Controller.Prelude
import Web.View.Admin.Index
import Web.View.Admin.New
import Web.View.Admin.Edit
import Web.View.Admin.Show

instance Controller AdminController where
    action AdminsAction = do
        admin <- query @Admin |> fetch
        render IndexView { .. }

    action NewAdminAction = do
        let admin = newRecord
        render NewView { .. }

    action ShowAdminAction { adminId } = do
        admin <- fetch adminId
        render ShowView { .. }

    action EditAdminAction { adminId } = do
        admin <- fetch adminId
        render EditView { .. }

    action UpdateAdminAction { adminId } = do
        admin <- fetch adminId
        admin
            |> buildAdmin
            |> ifValid \case
                Left admin -> render EditView { .. }
                Right admin -> do
                    hashed <- hashPassword (get #passwordHash admin)
                    admin <- admin 
                                |> updateRecord
                    setSuccessMessage "Admin updated"
                    redirectTo EditAdminAction { .. }

    action CreateAdminAction = do
        let admin = newRecord @Admin
        admin
            |> buildAdmin
            |> ifValid \case
                Left admin -> render NewView { .. } 
                Right admin -> do
                    hashed <- hashPassword (get #passwordHash admin)
                    admin <- admin 
                            |> set #passwordHash hashed
                            |> createRecord
                    setSuccessMessage "Admin created"
                    redirectTo AdminsAction

    action DeleteAdminAction { adminId } = do
        admin <- fetch adminId
        deleteRecord admin
        setSuccessMessage "Admin deleted"
        redirectTo AdminsAction

buildAdmin admin = admin
    |> fill @["email","passwordHash","failedLoginAttempts","name","lockedAt"]
