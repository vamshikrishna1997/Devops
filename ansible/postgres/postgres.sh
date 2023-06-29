#!/bin/bash

source postgres.conf

postgresql_install(){  

    # Update system packages
    echo "Updating system packages
    \n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    sudo yum update -y
    sudo yum upgrade -y

    #User and Group creation
    echo "Creating User and Group \n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    groupadd $PG_GROUP
    useradd $PG_USER -m -s $PG_SHELLTYPE -g $PG_GROUP
    passwd $PG_USER
    # sudo sh -c "echo '$PG_USER ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"

    # Install dependencies
    echo "Installing dependencies \n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    sudo yum install -y build-essential zlib1g-dev libreadline-dev libssl-dev libxml2-dev libxslt-dev

    # Download PostgreSQL source code
    echo "Downloading PostgreSQL\n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    wget https://ftp.postgresql.org/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.gz
    tar xzf postgresql-${PG_VERSION}.tar.gz

    # Configure and install PostgreSQL
    echo "Configuring PostgreSQL \n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    ./postgresql-${PG_VERSION}/configure --without-readline
    echo "Make PostgreSQL\n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    make
    echo "PostGreSQL installation Started.\n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    sudo make install


    # Create PostgreSQL data directory
    echo "Creating PostgreSQL data Directory \n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    sudo mkdir -p ${PG_DATA_DIR}
    sudo chown -R ${PG_USER}:${PG_GROUP} ${PG_DATA_DIR}

    # Initialize PostgreSQL database
    echo "Initializing dependencies \n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    sudo su - ${PG_USER} -c "${PG_BIN_DIR}/initdb -D ${PG_DATA_DIR}"

    # Start PostgreSQL server
    echo "Starting PostgreSQL \n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    sudo su - ${PG_USER} -c "${PG_BIN_DIR}/pg_ctl -D ${PG_DATA_DIR}/data -l logfile start"


    # Add PostgreSQL to system PATH
    echo "Setting a PATH \n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    sudo su - ${PG_USER} -c 'echo 'export PATH="${PG_BIN_DIR}:$PATH"' >> ~/.bashrc'
    sudo su - ${PG_USER} -c 'source ~/.bashrc'
    
    sudo su - ${PG_USER} -c 'export PGDATA=${PG_DATA_DIR}'

    echo "PostgreSQL installation completed!\n=====================================================================================================\n=====================================================================================================\n====================================================================================================="
    # Print installation completed message
    echo "PostgreSQL installation completed!"

}

createdb_user(){
    echo $'Create PostgreSQL user account \n=====================================================================================================\n=====================================================================================================\n====================================================================================================='
    sudo su - ${PG_USER} -c "createuser ${PG_USER}"
}
create_database(){
    echo $'Create PostgreSQL database \n=====================================================================================================\n=====================================================================================================\n====================================================================================================='
    sudo su - ${PG_USER} -c "createdb ${PG_DBNAME}"
}
create_tbspace(){
    echo "tbs"
}
setsuper_userpassword(){
    echo super user password
}


# Get the distribution ID
distro=$(awk -F= '/^ID=/{print $2}' /etc/os-release)
ram = $(free -h | awk '/^Mem:/ {print $2}')
store_size = df -h / | awk '/\//''{print $2}'

# Check if the distribution ID is "rhel"
# supported_CPUs = x86, x86_64, IA64, PowerPC, PowerPC 64, S/390, S/390x, Sparc, Sparc 64, ARM, MIPS, MIPSEL,PA-RISC
# supported_OS = Linux (all recent distributions), Windows (XP and later), FreeBSD, OpenBSD, NetBSD, macOS, AIX, HP/UX, and Solaris
# supported_RAM = 2Gi
# supported_STORAGE = 10G
if $distro -eq '"rhel"' ; then
    if $ram >= '"2.0Gi"' && $store_size >= "10G" 
    then
        if 
        postgresql_install
    else
        echo "Requirements not supported!"
    fi

else
    echo "The operating system is not Red Hat."
fi
