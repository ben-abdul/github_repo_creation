gh-create() {
  repo_name=$1

  dir_name=`basename $(pwd)`
  invalid_credentials=0

  if [ "$repo_name" = "" ]; then
    echo "  Repo name (hit enter to use '$dir_name')?"
    read repo_name
  fi

  if [ "$repo_name" = "" ]; then
    repo_name=$dir_name
  fi

  username=`git config github.user`
  if [ "$username" = "" ]; then
    echo "  Could not find username, run 'git config --global github.user <username>'"
    invalid_credentials=1
  fi

  token='!Lightarmada1'
  #token=`git config github.token`
  if [ "$token" = "" ]; then
    echo "  Could not find token, run 'git config --global github.token <token>'"
    invalid_credentials=1
  fi

  type=`git config github.tokentype`
  if [ "$type" = "ssh" ]; then
    conn_string="git@github.com:$username/$repo_name.git"
  elif [ "$type" = "http" ]; then
    conn_string="https://github.com/$username/$repo_name.git"
  else
    echo "  Either token type was not enterred correctly or is empty.\n  It must be one of 'ssh' or 'http'.\n  Run git config --global github.tokentype <ssh|http>"
    invalid_credentials=1
  fi

  if [ "$invalid_credentials" -eq "1" ]; then
    return 1
  fi

  echo -n "  Creating Github repository '$repo_name' ..."
  curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'", "private":"true", "has_wiki":"true"}' > /dev/null 2>&1
  echo " done."

}