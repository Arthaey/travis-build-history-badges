# THIS SHOULD BE CALLED BY YOUR OTHER PROJECT WHOSE BADGE NEEDS UPDATING.
#
# Add the following to the .travis.yml of the OTHER project:
#
# after_script:
#   - curl -o trigger.sh https://raw.githubusercontent.com/Arthaey/travis-build-history-badges/master/bin/trigger_badges_updates.sh
#   - sh trigger.sh
#
# Be sure to define the $TRAVIS_ACCESS_TOKEN env var for the OTHER build.

body='{
"request": {
  "branch":"master",
  "message":"Triggered by commit to $TRAVIS_REPO_SLUG.",
  "config": {
    "env": {
      "RUN_TESTS": 0,
      "UPDATE_BADGES": 1
    }
  }
}}'

curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token $TRAVIS_ACCESS_TOKEN" \
   -d "$body" \
   https://api.travis-ci.org/repo/Arthaey%2Ftravis-build-history-badges/requests
