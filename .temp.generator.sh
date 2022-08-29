#!/bin/bash

echo "type your email"
read email

echo "type your user"
read user

echo "type your work email"
read workEmail

echo "type your work user"
read workUser

# clear .temp file
> .temp

# start with bash's shebang
echo "#!/bin/bash" >> .temp
echo >> .temp

echo "function me() {" >> .temp
echo "  git config user.email \"${email}\"" >> .temp
echo "  git config user.name \"${user}\"" >> .temp
echo '  echo "local email $(git config user.email)"' >> .temp
echo '  echo "local user $(git config user.name)"' >> .temp
echo "}" >> .temp
echo >> .temp

echo "function work() {" >> .temp
echo "  git config user.email \"${workEmail}\"" >> .temp
echo "  git config user.name \"${workUser}\"" >> .temp
echo '  echo "local email $(git config user.email)"' >> .temp
echo '  echo "local user $(git config user.name)"' >> .temp
echo "}" >> .temp
echo >> .temp

echo ".temp file created!"
