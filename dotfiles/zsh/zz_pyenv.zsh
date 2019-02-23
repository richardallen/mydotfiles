if ! [ -x "$(command -v pyenv)" ]; then
  echo 'ERROR: pyenv is not installed!' >&2
  return 1
fi

if ! [ -x "$(command -v pyenv-virtualenv-init)" ]; then
  echo 'ERROR: pyenv-virtualenv-init is not installed!' >&2
  return 1
fi

eval "$(pyenv init -)";
eval "$(pyenv virtualenv-init -)";

