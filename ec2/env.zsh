if [[ $(uname) == 'Darwin' && -d "$HOME/.ec2" ]]; then
  # Copied from `brew info ec2-api-tools` and `brew info ec2-ami-tools`
  export JAVA_HOME="$(/usr/libexec/java_home)"
  export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
  export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
  export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
  export EC2_AMITOOL_HOME="/usr/local/Library/LinkedKegs/ec2-ami-tools/jars"
fi
