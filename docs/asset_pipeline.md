# Asset Pipeline Setup

* Timeline: December 2024
* Version: Rails 8.0

## Approach

* Uses `yarn` for package management
* Uses the `jsbundling-rails` gem
* Uses the `cssbundling-rails` gem
* Uses the `esbuild` bundler package
* Uses the `propshaft` gem
* Uses the `boostrap` and `boostrap-icons` packages
* Uses the `@hotwired/stimulus` package
* Uses `turbo-rails`, `hotwire`, and `stimulus-rails` gems
* Uses the `sass` library
* Creates a single javascript file and a single css file for the admin part of the site
* Creates a single javascript file and a single css file for the public part of the site
* Uses stimulus separate controllers for admin and public sites

## Yarn Config

Add to `.yarnrc.yml` at root

```yml
nodeLinker: node-modules
yarnPath: .yarn/releases/yarn-4.5.3.cjs
```

## Install Gems

```ruby
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "propshaft"
gem "stimulus-rails"
gem "turbo-rails"
```

## Install Node Packages

```bash
yarn add @hotwired/stimulus @hotwired/turbo-rails bootstrap bootstrap-icons esbuild sass
```

## Add esbuild Config

Add to `esbuild.config.js` at root

```javascript
const path = require('path')
const esbuild = require('esbuild')

// Admin bundle
esbuild.build({
  entryPoints: ['app/javascript/admin/index.js'],
  bundle: true,
  outfile: 'app/assets/builds/admin.js',
  plugins: [],
  watch: process.argv.includes("--watch")
}).catch(() => process.exit(1))

// Public bundle
esbuild.build({
  entryPoints: ['app/javascript/public/index.js'],
  bundle: true,
  outfile: 'app/assets/builds/public.js',
  plugins: [],
  watch: process.argv.includes("--watch")
}).catch(() => process.exit(1))
```

## Rails App Config

Update `config/initializers/assets.rb` to include your new bundles

```ruby
Rails.application.config.assets.paths << Rails.root.join("node_modules")
```

## JavaScript Config



## Stimulus Config

## CSS Config

## View Config

For admin layout `app/views/layouts/admin.html.erb`

```erb
<%= javascript_include_tag "admin", defer: true %>
<%= stylesheet_link_tag "admin" %>
```

For public layout `app/views/layouts/application.html.erb`

```erb
<%= javascript_include_tag "public", defer: true %>
<%= stylesheet_link_tag "public" %>
```

## Node Scripts

Add to `packkage.json` at root

```json
  "scripts": {
    "build": "node esbuild.config.js",
    "build:css": "node node_modules/sass/sass.js ./app/assets/stylesheets/admin.scss:./app/assets/builds/admin.css ./app/assets/stylesheets/public.scss:./app/assets/builds/public.css --no-source-map --load-path=node_modules --style=compressed",
    "watch": "node esbuild.config.js --watch",
    "watch:css": "sass --watch ./app/assets/stylesheets/admin.scss:./app/assets/builds/admin.css ./app/assets/stylesheets/public.scss:./app/assets/builds/public.css --no-source-map --load-path=node_modules"
  },
  ```

## Foreman Config

Add to `Procfile.dev.frontend` at root

```bash
js: yarn build --watch
css: yarn build:css --watch
```

## CI Config

Add to `.github/workflows/ci.yml`

```yml
js: yarn build --watch
css: yarn build:css --watch
```
