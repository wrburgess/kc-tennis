# kc.tennis

* [GitHub](https://github.com/wrburgess/kc-tennis.git)
* [Github Actions/CI](https://github.com/wrburgess/kc-tennis/actions/new)
* [Production Site](https://www.kc.tennis)

## Useful Commands

* Lock Bundle: `bundle lock --add-platform x86_64-linux`

## Tools Versions

### Install asdf

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

### Setup Yarn 3+

* Install Yarn 4 Plugin outdated: `yarn plugin import https://go.mskelton.dev/yarn-outdated/v4`

### Production

* [ruby](https://www.ruby-lang.org/en/)
* [node](https://nodejs.org/en/)
* [rails](https://rubyonrails.org/)
* [yarn](https://yarnpkg.com/)
* [postgres](https://www.postgresql.org/)
* [bootstrap](https://getbootstrap.com/)

## Encrypted Credentials

* run `rails credentials:edit`
* Your editor will need to run with --wait due to decryption speed
* example: `export EDITOR="code -w"`
* Retrieve keys with `Rails.application.credentials[:key_name]`

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
* run `hakiri system:steps`
* run `hakiri manifest:generate` > `hakiri system:scan`
* run `hakiri gemfile:scan`

## Security References

* [How Do Ruby/Rails Developers Keep Updated on Security Alerts?](http://gavinmiller.io/2015/staying-up-to-date-with-security-alerts/)
* [Ruby Security Mailing List](https://groups.google.com/forum/#!forum/ruby-security-ann)
* [Rails Security Mailing List](https://groups.google.com/forum/?fromgroups#!forum/rubyonrails-security)
* [CVE Details](https://www.cvedetails.com/)
* [Hakiri service (fee-based)](https://hakiri.io/)
* [AppCanary service (fee-based)](https://appcanary.com/)
