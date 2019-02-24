function slstab {
  nvm use node
  NPM_ROOT=$(npm root -g)
  SVRLS="${NPM_ROOT}/serverless/node_modules/tabtab/.completions/serverless.zsh"
  SLS="${NPM_ROOT}/serverless/node_modules/tabtab/.completions/sls.zsh"

  [[ -f "${SVRLS}" ]] && . "${SVRLS}"
  [[ -f "${SLS}" ]] && . "${SLS}"
}

