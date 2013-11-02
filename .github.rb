GITHUB_USERNAME = "USERNAME"
GITHUB_PASSWORD = "PASSWORD"

if GITHUB_USERNAME == "USERNAME" or GITHUB_PASSWORD == "PASSWORD"
  raise "Github credentials are not configured, please check #{__FILE__}"
end
