# Example PRs in Matt's Voice

These are real PR titles and descriptions that Matt wrote.

---

## Example 1

> **Title:** Set the Durian API Heroku app's Postmark config vars via OpenTofu
>
> The Durian API is going to send sign-in emails through Postmark and needs
> `POSTMARK_SERVER_TOKEN` and `EMAIL_FROM_ADDRESS` set. This PR introduces
> managing Heroku App environment variables through Tofu and adds only those
> two variables via Gitops. Existing Heroku App environment variables are left
> untouched and can continue to be maintained in Heroku Dashboard.

---

## Example 2

> **Title:** Point durian.page and api.durian.page DNS at Heroku
>
> I bought `durian.page` domain so that we have a domain to send sign in emails from
> without needing to use a tinyprint.dev subdomain. Since we now have a domain, we can
> start using the domain for providing access to our web app. This PR adds durian.page
> and api.durian.page DNS records to point to the apps in Heroku.

---

## Example 3

> **Title:** Consolidate tinyprint.dev resources into a per-domain file
>
> When we originally brought the tinyprint.dev zone and DNS records under OpenTofu
> management, we were only thinking about managing one domain and split the
> management into `zones.tf` and `dns.tf` files. We have since realized that we
> are going to want to manage multiple domains and that the existing
> organization is going to be awkward. This PR moves all of tinyprint.dev's zone
> and DNS configuration into one file.

---

## Example 4

> **Title:** Add email-code sign-in round-trip
>
> We are developing authentication for the Durian API across multiple PRs that
> are independently deployable and manually testable. This PR introduces a full
> email-code sign-in round-trip with two API endpoints:
>  - `/auth/email/start`, which emails a 6-digit login code to the provided email address
>  - `/auth/email/verify`, which validates the provided 6-digit login code against the email address and creates the user if one with the email address does not yet exist
>
> The verify endpoint logs the verified identity but does not yet implement
> session functionality. Session creation will come in a future PR.
>
> ## Dependencies
>
> This PR relies on new `POSTMARK_SERVER_TOKEN` and `EMAIL_FROM_ADDRESS`
> environment variables being set. These variables have been set up on production
> in the durian-api Heroku app via OpenTofu in `tinyprint/infra#13`.
>
> ## Verification
>
> I tested that the send and verify functionalities work by:
>
> 1. Running the following command:
>    `curl -X POST http://localhost:16080/auth/email/start -H 'Content-Type: application/json' -d '{"email":"matt@tinyprint.dev"}'`
> 2. Checking my email for the 6-digit code
> 3. Running the following command with `NNNNNN` replaced by the 6-digit code from my email:
>    `curl -X POST http://localhost:16080/auth/email/verify -H 'Content-Type: application/json' -d '{"email":"matt@tinyprint.dev","code":"NNNNNN"}'`
> 4. Checking server logs for `info: email sign-in completed: user_id=N email=...`
> 5. Running the following query to verify it returns a user record:
>    `psql -c "SELECT user_id, email FROM users WHERE LOWER(email) = LOWER('matt@tinyprint.dev');"` returns the row

---

## Example 5

> **Title:** Migrate test suite to testify and mockery
>
> Our test suite has been using the stdlib and relying on conditionals + `t.Fatal*` to
> make assertions. Plus, we started hand-rolling fakes/mocks. Rather than continuing
> down that road, we are introducing `testify` and `mockery` to slim down some of the
> boilerplate. This MR moves all assertions over to testify and replaces manually written
> mocks with mockery-generated mocks.
>
> We intentionally left the manually written `fakeIDValidator` and `fakeExchanger`
> mocks in `auth_google_test.go`. Their interfaces are defined in the same
> `api` package as their tests, which would force the generated mocks to appear
> in the `api` package rather than a `mocks` package to avoid an
> `api -> api/mocks -> api` cycle. We could move around the interfaces to avoid
> this import cycle, but these mocks are going to go away once we finish
> implementing email-code authentication, sessions, etc.
>
> ## Verification
>
> We do not yet have the tests running in CI, so I verified the tests still run
> on my local by running:
>
> 1. `docker compose up -d postgres`
> 2. `DATABASE_URL=postgres://postgres:postgres@localhost:16432/durian go test ./...`
> 3. `go tool mockery` should be a no-op (mocks are committed and up to date)
