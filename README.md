[![Bugs](https://img.shields.io/github/issues/Arthaey/travis-build-history-badges/bug.svg)](https://github.com/Arthaey/travis-build-history-badges/issues?q=is:open+is:issue+label:bug)
[![Build Status](https://travis-ci.org/Arthaey/travis-build-history-badges.svg?branch=master)](https://travis-ci.org/Arthaey/travis-build-history-badges)
[![Coverage Status](https://coveralls.io/repos/github/Arthaey/travis-build-history-badges/badge.svg?branch=master)](https://coveralls.io/github/Arthaey/travis-build-history-badges?branch=master)
[![Code Climate](https://codeclimate.com/github/Arthaey/travis-build-history-badges.png)](https://codeclimate.com/github/Arthaey/travis-build-history-badges)

Generates badges for Travis build histories.

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
