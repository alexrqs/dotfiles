#!/bin/bash

echo "type your email"

read email

# clear .temp file
> .temp

# start with bash's shebang
echo "#!/bin/bash" >> .temp
echo >> .temp

echo "function me() {" >> .temp
echo "  git config user.email \"${email}\"" >> .temp
echo '  echo "local email $(git config user.email)"' >> .temp
echo "}" >> .temp
echo >> .temp

echo "insert github token"
read github_token

echo "export GITHUB_TOKEN='${github_token}'" >> .temp

echo ".temp file created!"
