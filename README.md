[![Bugs](https://img.shields.io/github/issues/Arthaey/travis-build-history-badges/bug.svg)](https://github.com/Arthaey/travis-build-history-badges/issues?q=is:open+is:issue+label:bug)
[![Maintainability](https://api.codeclimate.com/v1/badges/f8759e9e312fb6d83d18/maintainability)](https://codeclimate.com/github/Arthaey/travis-build-history-badges/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/Arthaey/travis-build-history-badges/badge.svg?branch=master)](https://coveralls.io/github/Arthaey/travis-build-history-badges?branch=master)
[![Build Status](https://travis-ci.org/Arthaey/travis-build-history-badges.svg?branch=master)](https://travis-ci.org/Arthaey/travis-build-history-badges)
[![Build History](http://www.arthaey.com/images/travis-build-badges/Arthaey-travis-build-history-badges.png)](https://travis-ci.org/Arthaey/travis-build-history-badges/builds)

Generates badges for Travis build histories. For example, the little red and/or green bar chart above this text. :)

# Example

Set the following environment variables:

- `TRAVIS_ACCESS_TOKEN`
  (obtained via command-line `travis login && travis token`)
- `SCP_PASSWORD`

Create a `config.yml` file:

```
travis:
  owner: MyGithubUsername

upload:
  host: my-image-host-server.example.com
  dir: images/public/travis-build-badges
  username: MyScpUsername
```

Then run the script to generate images for all your active builds:

```
ruby travis-build-history-badges.rb
```

You can restrict which builds to generate images for by specifying
a whitelist of repo names:

```
travis:
  owner: MyGithubUsername
  repos:
     - foo
     - bar
```

# Available environment variables:

- `TRAVIS_ACCESS_TOKEN`
- `SCP_USERNAME`
- `SCP_PASSWORD`
- `SCP_HOST`
- `SCP_DIR`
