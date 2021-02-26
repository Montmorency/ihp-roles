module Web.View.Admin.Edit where
import Web.View.Prelude

data EditView = EditView { admin :: Admin }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={AdminsAction}>Admins</a></li>
                <li class="breadcrumb-item active">Edit Admin</li>
            </ol>
        </nav>
        <h1>Edit Admin</h1>
        {renderForm admin}
    |]

renderForm :: Admin -> Html
renderForm admin = formFor admin [hsx|
    {textField #name}
    {textField #email}
    {dateTimeField #lockedAt}
    {textField #failedLoginAttempts}
    {submitButton}
|]


--separate form for pw so we don't reset it every time.
renderPasswordForm :: Admin -> Html
renderPasswordForm admin = formFor admin [hsx|
    {passwordField #passwordHash}
    {submitButton}
|]

