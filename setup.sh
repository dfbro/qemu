#!/bin/bash

echo "Installing uDocker..."
wget https://github.com/indigo-dc/udocker/releases/download/1.3.17/udocker-1.3.17.tar.gz
tar zxvf udocker-1.3.17.tar.gz
export PATH=`pwd`/udocker-1.3.17/udocker:$PATH
sed -i '1s|#!/usr/bin/env python|#!/usr/bin/env python3|' `pwd`/udocker-1.3.17/udocker/udocker
udocker install
# Setting execmode to runc
export UDOCKER_DEFAULT_EXECUTION_MODE=F1
# Fix runc execution issue
export XDG_RUNTIME_DIR=$HOME
echo "Installing the fedora container..."
wget https://github.com/dfbro/qemu/raw/refs/heads/main/qemu.tar
udocker import --clone --tocontainer --name=qemu qemu.tar
udocker setup --execmode=F1 qemu

# Create the script to be executed inside the container
rm qemu.tar

cat > start_container.sh << EOF

#!/bin/sh
export XDG_RUNTIME_DIR=$HOME
export PATH=`pwd`/udocker-1.3.17/udocker:$PATH
udocker setup --execmode=F1 qemu
udocker run qemu /bin/bash /start.sh
EOF
chmod +x start_container.sh
echo "Setup complete. You can now run the container with: ./start_container.sh"
echo "Script will auto destroy."
rm "$0"
