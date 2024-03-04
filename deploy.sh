#!/bin/bash
remote_user_dev=ubuntu
remote_host_dev=192.168.3.5
remote_password_dev=imip@1234
remote_user_staging=ubuntu
remote_host_staging=192.168.3.11
remote_password_staging=imip@1234
remote_user_prod=ubuntu
remote_host_prod=192.168.3.14
remote_password_prod=imip@1234
ORIGIN_DIRECTORY="project-soc"
GIT_URI="https://github.com/chaubv/project-soc.git"

# Answer choose environment
echo
echo -n "Do you want to build and deploy on dev,staging or prod environment?. (dev/staging/prod) "
read -r answer

if [ "$answer" = "dev" ] ; then
    echo
    echo "dev environment"
    ENVIRONMENT="dev"
    sshpass -p "$remote_password_dev" ssh -T -o StrictHostKeyChecking=no "$remote_user_dev"@"$remote_host_dev" << EOF
    rm -rf $ORIGIN_DIRECTORY
    git clone $GIT_URI --branch dev
EOF
# Deploy to dev environment
    echo -n "Do you want to continue for deploy to dev environment? (y/n)?"
    read -r answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
       echo "Yes! you start deploy"
       sshpass -p "$remote_password_dev" ssh -T -o StrictHostKeyChecking=no "$remote_user_dev"@"$remote_host_dev" "cd $ORIGIN_DIRECTORY && docker-compose up -d --build"
    else
      echo "Stop deployment"
      exit
    fi
    
elif [ "$answer" = "staging" ] ; then
    echo
    echo "staging environment"
    ENVIRONMENT="staging"
    sshpass -p "$remote_password_staging" ssh -T -o StrictHostKeyChecking=no "$remote_user_staging"@"$remote_host_staging" << EOF
    rm -rf $ORIGIN_DIRECTORY
    git clone $GIT_URI --branch staging
EOF
# Deploy to staging environment
    echo -n "Do you want to continue for deploy to staging environment? (y/n)?"
    read -r answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
       echo "Yes! You start deploy"
       sshpass -p "$remote_password_staging" ssh -T -o StrictHostKeyChecking=no "$remote_user_staging"@"$remote_host_staging" "cd $ORIGIN_DIRECTORY && docker-compose up -d --build"
    else
      echo "Stop deployment"
      ls -la
      exit
    fi

elif [ "$answer" = "prod" ] ; then
    echo
    echo "prod environment"
    ENVIRONMENT="prod"
    sshpass -p "$remote_password_prod" ssh -T -o StrictHostKeyChecking=no "$remote_user_prod"@"$remote_host_prod" << EOF
    rm -rf $ORIGIN_DIRECTORY
    git clone $GIT_URI --branch main
EOF
# Deploy to prod environment
    echo -n "Do you want to continue for deploy to prod environment? (y/n)?"
    read -r answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
       echo "Yes! you start deploy"
       sshpass -p "$remote_password_prod" ssh -T -o StrictHostKeyChecking=no "$remote_user_prod"@"$remote_host_prod" "cd $ORIGIN_DIRECTORY && docker-compose up -d --build"
    else
      echo "Stop deployment"
      exit
    fi

else
    echo
    echo "Bad selection"
    exit
fi
