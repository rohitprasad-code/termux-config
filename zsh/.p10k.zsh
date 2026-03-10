# This is a placeholder for your Powerlevel10k configuration.
# Run `p10k configure` to generate your personalized setup.
# The `p10k configure` wizard will overwrite this file with your choices.

# Temporarily change options.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir                     # current directory
  vcs                     # git status
  prompt_char             # prompt symbol
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  # exit code of the last command
  command_execution_time  # duration of the last command
  background_jobs         # presence of background jobs
  context                 # user@hostname
  time                    # current time
)
