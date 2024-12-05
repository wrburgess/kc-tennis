# Asset Pipeline Setup

## Context

* Timeline: December 2024
* Version: Rails 8.0

## Approach

* Uses `yarn 4+` for package management
* Uses the following gems:
  - `cssbundling-rails`
  - `hotwire`
  - `jsbundling-rails`
  - `propshaft`
  - `stimulus-rails`
  - `turbo-rails`
* Uses the following packages:
  - `@hotwired/stimulus`
  - `@hotwired/turbo-rails`
  - `boostrap-icons`
  - `boostrap`
  - `esbuild`
  - `sass`
* Creates a single javascript file and a single css file for the admin part of the site
* Creates a single javascript file and a single css file for the public part of the site
* Uses separate stimulus controllers for admin and public sites

## Yarn Config

Add to `.yarnrc.yml` at root:

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

Add to `esbuild.config.js` at root:

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

Update `config/initializers/assets.rb` to include your new bundles:

```ruby
Rails.application.config.assets.paths << Rails.root.join("node_modules")
```

## JavaScript Config

Folder structure for `app/javascript` directory:

```
--app
  --javascript
    --admin
      --controllers
        - hello_controller.js
        - index.js
      - index.js
    --controllers
      - application.js
    --public
      --controllers
        - yo_controller.js
        - index.js
      - index.js
```

## CSS Config

File structure:

```
--app
  --assets
    --stylesheets
      - admin.scss
      - public.scss
```

Add to `admin.scss` and `public.scss` files:

```css
@use "bootstrap/scss/bootstrap";
@use "bootstrap-icons/font/bootstrap-icons";

// Your admin-specific styles here
```

## View Config

For admin layout `app/views/layouts/admin.html.erb`:

```erb
<%= javascript_include_tag "admin", defer: true %>
<%= stylesheet_link_tag "admin" %>
```

For public layout `app/views/layouts/application.html.erb`:

```erb
<%= javascript_include_tag "public", defer: true %>
<%= stylesheet_link_tag "public" %>
```

## Node Scripts

Add to `package.json` at root:

```json
  "scripts": {
    "build": "node esbuild.config.js",
    "build:css": "node node_modules/sass/sass.js ./app/assets/stylesheets/admin.scss:./app/assets/builds/admin.css ./app/assets/stylesheets/public.scss:./app/assets/builds/public.css --no-source-map --load-path=node_modules --style=compressed",
    "watch": "node esbuild.config.js --watch",
    "watch:css": "sass --watch ./app/assets/stylesheets/admin.scss:./app/assets/builds/admin.css ./app/assets/stylesheets/public.scss:./app/assets/builds/public.css --no-source-map --load-path=node_modules"
  },
  ```

## Foreman Config

Add to `Procfile.dev.frontend` at root:

```bash
js: yarn build --watch
css: yarn build:css --watch
```

## CI Config

Add to `.github/workflows/ci.yml`:

```yaml
  - name: Setup database
    run: bin/rails db:create db:schema:load

  - name: Build assets
    run: |
      yarn build
      yarn build:css
```
