#!/bin/bash

__create_user() {
  # Create a user to SSH into as.
  useradd sshuser
  SSH_USERPASS=newpass
  echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin sshuser)
  echo ssh sshuser password: $SSH_USERPASS
}

# Call all functions
__create_user

