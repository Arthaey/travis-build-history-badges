[![Bugs](https://img.shields.io/github/issues/Arthaey/travis-build-history-badges/bug.svg)](https://github.com/Arthaey/travis-build-history-badges/issues?q=is:open+is:issue+label:bug)
[![Maintainability](https://api.codeclimate.com/v1/badges/f8759e9e312fb6d83d18/maintainability)](https://codeclimate.com/github/Arthaey/travis-build-history-badges/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/Arthaey/travis-build-history-badges/badge.svg?branch=master)](https://coveralls.io/github/Arthaey/travis-build-history-badges?branch=master)
[![Build Status](https://travis-ci.org/Arthaey/travis-build-history-badges.svg?branch=master)](https://travis-ci.org/Arthaey/travis-build-history-badges)
[![Build History](http://www.arthaey.com/images/travis-build-badges/Arthaey-travis-build-history-badges.png)](https://travis-ci.org/Arthaey/travis-build-history-badges/builds)

Generates badges for Travis build histories. For example, the little red and/or green bar chart above this text. :)

# Setup for your own Github project

## Prerequisites

1. a public **Github repo**
1. **Travis CI** set up with your Github repo

(If the two types of tokens are confusing, read
[Travis's blog post](https://blog.travis-ci.com/2013-01-28-token-token-token)
about them.)

## Travis/Github Authentication

Say your Github repo is at `https://github.com/MyUsername/my-repo`.

1. Generate a **Github personal access token**:
    - go to https://github.com/settings/tokens
    - click "Generate new token" button with "public_repo" permissions
    - note the token — you will only get to see it once!

1. Install the **Travis command-line tool**:
    - `gem install travis` _(Ruby is a prereq, obviously)_

1. Generate a **Travis token** from your Github token:
    - `travis login --github-token &lt;personal-access-token&gt;`
    - `travis token`
    - note the token — you will only get to see it once!

## Travis Build Settings

Say your Travis build is at `https://travis-ci.org/MyUsername/my-repo`.

1. Go to your Travis build's settings at `https://travis-ci.org/MyUsername/my-repo/settings`.

1. Scroll down to the "Environment Variables" section.

1. Add a new `TRAVIS_ACCESS_TOKEN` variable, with the Travis token you generated
   at the end of the authentication instructions above.

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
