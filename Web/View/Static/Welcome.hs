module Web.View.Static.Welcome where
import Web.View.Prelude
import Application.Helper.Controller (getRoleOrNothing)

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
                  <h2>
                      Role Call
                  </h2>
                  <p>
                     Can log in as Admin email: jerry@gd.com pw: jerry
                     Can log in as User email: bob@gd.com pw: bob
                  </p>
                  <p> 
                     This is a small POC of two things for handling Roles:
                     <li>
                     We can push GADTs into (?context) TypeMap and retrieve them. 
                     This is nice because we can pattern match
                     on the GADT so you get nice type signature functions for 
                     modifying View depending on what role is logged in.
                     ensureIs functions can also be switched to pattern match against any Role GADT constructor. </li>

                    <li> MakeRole type class can efficient push and pull Role from context for an arbitrary Role Type.
                    User, Admin, Provider, GoldClubMember, etc. Also could contain method for serializing/deserializing
                    Session info to prevent round trip to DB on Authentication. </li>
                  </p>
                  <p> If you want a Role in the IHP trusted code base a data family Role a  could be used and then 
                      let the developers define `data instance Role User = UserRole user`. This is nice but might 
                      mean we need to use type classes for all Role related functions rather than just pattern matching
                      on the constructor. Have to check this. 
                  </p>
                  <p>
                    <a href={NewSessionAction}> User Login</a> <br/>
                    <a  class="js-delete" href={DeleteSessionAction}>User Logout</a>
                  </p>
                  <p>
                    <a href={NewAdminSessionAction}> Admin Login</a> <br/>
                    <a  class="js-delete" href={DeleteAdminSessionAction}> Admin Logout</a>
                  </p>
                  <p style="margin-top: 1rem; font-size: 1.75rem; font-weight: 600; color:hsla(196, 13%, 80%, 1)">
                    { renderUser currentUserOrNothing }
                  </p>
                  <p style="margin-top: 1rem; font-size: 1.75rem; font-weight: 600; color:hsla(196, 13%, 80%, 1)">
                    { roleDependentView (getRoleOrNothing (Proxy :: Proxy User)) }
                  </p>
                  <p style="margin-top: 1rem; font-size: 1.75rem; font-weight: 600; color:hsla(196, 13%, 80%, 1)">
                    { roleDependentView (getRoleOrNothing (Proxy :: Proxy Admin)) }
                  </p>
                 |]

renderUser :: Maybe User -> Html
renderUser (Just user) = [hsx| Hello, User without a Role. |]
renderUser Nothing = [hsx| No User is Logged in. |]
