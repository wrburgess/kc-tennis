# kc.tennis

* [GitHub](https://github.com/wrburgess/kc-tennis)
* [Github Actions/CI](https://github.com/wrburgess/kc-tennis/actions)
* [Production Site](https://www.kc.tennis)

## Useful Commands

* Lock Bundle: `bundle lock --add-platform x86_64-linux`

## Tools Versions

### Install asdf for dependency versioning

* [asdf](https://github.com/asdf-vm/asdf)
* Install with `brew install asdf`

### Install Plugins

* ruby: `asdf plugin-add ruby`
* nodejs: `asdf plugin-add nodejs`
* postgres: `asdf plugin-add postgres`

### Update Dependencies

* Update all plugins: `asdf plugin update --all`
* List available versions: `asdf list all [plugin]`
* Install latest library: `asdf install [plugin] latest`
* Set global version: `asdf global [plugin] latest`
* Set local version: `asdf local [plugin] latest`

### Setup Yarn 4+

* Install Yarn 4 Plugin outdated: `yarn plugin import https://go.mskelton.dev/yarn-outdated/v4`

### Production

#### Foundation

* [ruby](https://www.ruby-lang.org/en/)
* [node](https://nodejs.org/en/)
* [rails](https://rubyonrails.org/)
* [yarn](https://yarnpkg.com/)
* [postgres](https://www.postgresql.org/)
* [bootstrap](https://getbootstrap.com/)

#### Tools

* [good_job](https://github.com/bensheldon/good_job)
* [renovate](https://developer.mend.io/github/wrburgess/kc-tennis)

## Encrypted Credentials

* run `rails credentials:edit`
* Your editor will need to run with --wait due to decryption speed
* example: `export EDITOR="code -w"`
* Retrieve keys with `Rails.application.credentials[:key_name]`

## Database Management

### pghero

* [pghero gem](https://github.com/ankane/pghero)
* Update stats with `rake pghero:capture_query_stats`

### blazer

* [blazer gem](https://github.com/ankane/pghero)

## Running Application Locally

### Local Server Commands

* alias foreb="foreman start -f Procfile.dev.backend"
* alias foref="foreman start -f Procfile.dev.frontend"
* alias rs="rails s"

* `foreb` runs good_job worker and elasticsearch
* `foref` runs a js and css watcher for changes
* `rs` runs puma locally

## Setup Cloudflare Tunnel

### Setup References

* [Cloudflare Tunnels](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)

### Setup Steps

* Avails uses the `www.mpivid.com` domain for local tunneling with Cloudflare and the `cloudflared` ci
* Install (on Mac) with `brew install cloudflared`
* Login with `cloudflared tunnel login`
* Create name tunnel `cloudflared tunnel create <NAME>` or `cloudflared tunnel create mpivid`
* Create config file at `/User/[username]/.cloudflared/config.yaml`
* [MPI Cloudflare Tunnel Dashboard](https://one.dash.cloudflare.com/ee0a8e28862d5c84754bbed265f0f861/networks/tunnels?search=)
* Note: Config for the www.mpivid.com domain is managed on the Cloudflared Tunnel Dashboard

### Running Tunnel Commands

* Run tunnel with `cloudflared tunnel run mpivid`
* Setup alias `alias mpivid="cloudflared tunnel run mpivid"`
* Check tunnel status with `cloudflared tunnel info mpivid`

## Security Checks

* run `bundle outdated` > update gems with `bundle update` > run tests
* run `bundle-audit update`
* run `bundle-audit`
* run `brakeman`

## Security References

* [Ruby Security Discource](https://discuss.rubyonrails.org/c/security-announcements/9)
* [CVE Details](https://www.cvedetails.com/)
* [Security Alerts on GitHub](https://github.blog/news-insights/product-news/introducing-security-alerts-on-github/)

## Asset Pipeline

* propshaft
* js_bundling_rails
* css_bundling_rails
* esbuild
* bootstrap
* sass

## Hotwire

* stimulus
* turbo

## Authentication

* Devise
* Pundit
* System Permissions

## Database

* Postgres
* [pghero](https://github.com/ankane/pghero)
* blazer

## Testing

* rspec
* capybara

## Linting

* rubocop

## Async

* GoodJob

## Caching

* SolidCache

## Notifications

* Noticed
* Topics/Subs

## Views

* ViewComponent

## Assets

* AWS
* cloudfront or cloudflare

## API

* inbound_requests_controller
