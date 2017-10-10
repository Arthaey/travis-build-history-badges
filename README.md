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
