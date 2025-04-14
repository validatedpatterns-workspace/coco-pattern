set -e 

echo "Run from the root directory of the project"
echo "\n"
echo "Ensuring azure environment is installed"

if [ ! -n "${GUID}" ]; then
   echo "RHDP GUID environmental variable does not exist"
   exit 1
fi
if [ ! -n "${CLIENT_ID}" ]; then
   echo "RHDP AZURE 'CLIENT_ID' environmental variable does not exist"
   exit 1
fi
if [ ! -n "${PASSWORD}" ]; then
   echo "RHDP AZURE 'PASSWORD' environmental variable aka client secret does not exist"
   exit 1
fi
if [ ! -n "${TENANT}" ]; then
   echo "RHDP AZURE 'TENANT' environmental variable does not exist"
   exit 1
fi
if [ ! -n "${SUBSCRIPTION}" ]; then
   echo "RHDP AZURE 'SUBSCRIPTION' environmental variable does not exist"
   exit 1
fi
if [ ! -n "${RESOURCEGROUP}" ]; then
   echo "RHDP AZURE 'RESOURCEGROUP' environmental variable does not exist"
   exit 1
fi


sleep 10
echo "---------------------"
echo "Installing python dependencies"
echo "---------------------"
pip3 install -r rhdp/requirements.txt
echo "---------------------"
echo "requirements installed"
echo "---------------------"
sleep 5

if [ ! -f "${HOME}/pull-secret.json" ]; then
   echo "A OpenShift pull secret is required at ~/pull-secret.json"
   exit 1
fi

if [ ! -f "${HOME}/.ssh/id_rsa" ]; then
   echo "An rsa ssh key is required at ~/.ssh/id_rsa"
   exit 1
fi


echo "---------------------"
echo "defining cluster"
echo "---------------------"
python3 rhdp/rhdp-cluster-define.py
echo "---------------------"
echo "cluster defined"
echo "---------------------"
sleep 10
echo "---------------------"
echo "openshift-install"
echo "---------------------"
openshift-install create cluster --dir=./openshift-install
echo "openshift-install done"
echo "---------------------"
echo "setting up secrets"

bash ./scripts/gen-secrets.sh


sleep 60
echo "---------------------"
echo "pattern install"
echo "---------------------"
export KUBECONFIG=`pwd`/openshift-install/auth/kubeconfig


./pattern.sh make install
echo "---------------------"
echo "pattern install done"
echo "---------------------"

