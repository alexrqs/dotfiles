#!/bin/bash

echo "Enable fig"
read useFig

echo "Use bun"
read useBun

echo "User folder"
read userPath

# clear .temp file
> .preflight

# start with bash's shebang

echo "#!/bin/bash" >> .preflight
echo >> .preflight

if test "$useFig" = "true"; then
  echo "export useFig=\"${useFig}\"" >> .preflight
  echo >> .preflight
fi

if test "$useBun" = "true"; then
  echo "export useBun=\"${useBun}\"" >> .preflight
  echo >> .preflight
fi

echo "export userPath=\"${userPath}\"" >> .preflight
echo >> .preflight

echo ".preflight file created!"

# echo "function work() {" >> .temp
# echo "  git config user.email \"${workEmail}\"" >> .temp
# echo "  git config user.name \"${workUser}\"" >> .temp
# echo '  echo "local email $(git config user.email)"' >> .temp
# echo '  echo "local user $(git config user.name)"' >> .temp
# echo "}" >> .temp
# echo >> .temp

