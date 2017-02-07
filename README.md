## README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Install Ruby

* Get Rails 4.2.6

* Clone repo

* Installing dependencies

  `Bundle install`

* Database yml credentials

* Database setup

  `rake db:create db:migrate`

* Create admin

  `Admin.create(email: 'a@b.com', password: '12345678')`

* Create user/voter

  `Voter.create(email: 'c@c.com', password: '1234567890')`

* Services

  `bundle exec sidekiq`

# Endpoints

## Auth

| path | method | purpose |
|:-----|:-------|:--------|
| /api/v1/auth    | POST   | Email registration. Requires **`email`**, **`password`**, and **`password_confirmation`** params. A verification email will be sent to the email address provided. Accepted params can be customized using the [`devise_parameter_sanitizer`](https://github.com/plataformatec/devise#strong-parameters) system. |
| /api/v1/auth | DELETE | Account deletion. This route will destroy users identified by their **`uid`**, **`access_token`** and **`client`** headers. |
| /api/v1/auth | PUT | Account updates. This route will update an existing user's account settings. The default accepted params are **`password`** and **`password_confirmation`**, but this can be customized using the [`devise_parameter_sanitizer`](https://github.com/plataformatec/devise#strong-parameters) system. If **`config.check_current_password_before_update`** is set to `:attributes` the **`current_password`** param is checked before any update, if it is set to `:password` the **`current_password`** param is checked only if the request updates user password. |
| /api/v1/auth/sign_in | POST | Email authentication. Requires **`email`** and **`password`** as params. This route will return a JSON representation of the `User` model on successful login along with the `access-token` and `client` in the header of the response. |
| /api/v1/auth/sign_out | DELETE | Use this route to end the user's current session. This route will invalidate the user's authentication token. You must pass in **`uid`**, **`client`**, and **`access-token`** in the request headers. |
| /api/v1/auth/:provider | GET | Set this route as the destination for client authentication. Ideally this will happen in an external window or popup. |
| /api/v1/auth/:provider/callback | GET/POST | Destination for the oauth2 provider's callback uri. `postMessage` events containing the authenticated user's data will be sent back to the main client window from this page. |
| /api/v1/auth/validate_token | GET | Use this route to validate tokens on return visits to the client. Requires **`uid`**, **`client`**, and **`access-token`** as params. These values should correspond to the columns in your `User` table of the same names. |
| /api/v1/auth/password | POST | Use this route to send a password reset confirmation email to users that registered by email. Accepts **`email`** and **`redirect_url`** as params. The user matching the `email` param will be sent instructions on how to reset their password. `redirect_url` is the url to which the user will be redirected after visiting the link contained in the email. |
| /api/v1/auth/password | PUT | Use this route to change users' passwords. Requires **`password`** and **`password_confirmation`** as params. This route is only valid for users that registered by email (OAuth2 users will receive an error). It also checks **`current_password`** if **`config.check_current_password_before_update`** is not set `false` (disabled by default). |
| /api/v1/auth/password/edit | GET | Verify user by password reset token. This route is the destination URL for password reset confirmation. This route must contain **`reset_password_token`** and **`redirect_url`** params. These values will be set automatically by the confirmation email that is generated by the password reset request. |

read more --> [devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth)
