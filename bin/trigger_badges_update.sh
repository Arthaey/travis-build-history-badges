# Add this to the .travis.yml of the OTHER project:
#
# after_script:
#   - curl -o trigger.sh https://raw.githubusercontent.com/Arthaey/travis-build-history-badges/master/bin/trigger_badges_updates.sh
#   - sh trigger.sh

body='{
"request": {
"branch":"master"
}}'

curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token $TRAVIS_ACCESS_TOKEN" \
   -d "$body" \
   https://api.travis-ci.org/repo/Arthaey%2Ftravis-build-history-badges/requests
