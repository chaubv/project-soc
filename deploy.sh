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
env_dev=dev
env_staging=staging
env_prod=prod
echo "environment: $1"
echo "version: $2"
# Answer choose environment
echo
if [ "$env_dev" = "$1" ] ; then
    echo
    echo "dev environment"
    ENVIRONMENT="dev"
    ssh $remote_user_dev@$remote_host_dev << EOF
    rm -rf $ORIGIN_DIRECTORY
    git clone $GIT_URI --branch dev
    cd $ORIGIN_DIRECTORY && sed -i s/tag/$2/g docker-compose.yaml && docker build -t project-soc:$2 .
EOF
# Deploy to dev environment
    echo -n "Do you want to continue for deploy to dev environment? (y/n)?"
    read -r answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
       echo "Yes! you start deploy"
 #      sshpass -p "$remote_password_dev" ssh -T -o StrictHostKeyChecking=no "$remote_user_dev"@"$remote_host_dev" "cd $ORIGIN_DIRECTORY && docker-compose up -d --build"
       ssh $remote_user_dev@$remote_host_dev << EOF
       cd $ORIGIN_DIRECTORY && docker-compose up -d --build
EOF
   else
      echo "Stop deployment"
      exit
    fi
    
elif [ "$env_staging" = "$1" ] ; then
    echo
    echo "staging environment"
    ENVIRONMENT="staging"
    ssh $remote_user_staging@$remote_host_staging << EOF
    rm -rf $ORIGIN_DIRECTORY
    git clone $GIT_URI --branch staging
    cd $ORIGIN_DIRECTORY && sed -i s/tag/$2/g docker-compose.yaml && docker build -t project-soc:$2 .
EOF
# Deploy to staging environment
    echo -n "Do you want to continue for deploy to staging environment? (y/n)?"
    read -r answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
       echo "Yes! You start deploy"
       ssh $remote_user_staging@$remote_host_staging << EOF
       cd $ORIGIN_DIRECTORY && docker-compose up -d --build
EOF
    else
      echo "Stop deployment"
      ls -la
      exit
    fi

elif [ "$env_prod" = "$1" ] ; then
    echo
    echo "prod environment"
    ENVIRONMENT="prod"
    ssh "$remote_user_prod"@"$remote_host_prod" << EOF
    rm -rf $ORIGIN_DIRECTORY
    git clone $GIT_URI --branch main
    cd $ORIGIN_DIRECTORY && sed -i s/tag/$2/g docker-compose.yaml && docker build -t project-soc:$2 .
EOF
# Deploy to prod environment
    echo -n "Do you want to continue for deploy to prod environment? (y/n)?"
    read -r answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
       echo "Yes! you start deploy"
       ssh $remote_user_prod@$remote_host_prod << EOF
       cd $ORIGIN_DIRECTORY && docker-compose up -d --build
EOF
    else
      echo "Stop deployment"
      exit
    fi

else
    echo
    echo "Bad selection"
    exit
fi
