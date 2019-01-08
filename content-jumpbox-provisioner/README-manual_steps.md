## Manual Steps 

To be able to login to the UPP k8s clusters, please do the following:

1. Login as root to the instance created.
1. `cd /etc/skel`
1. Add the following to the `.bashrc` file
    ```
    export KUBECONFIG=${HOME}/content-k8s-auth-setup/kubeconfig
    ```
1. Create a file `.kubectl-login.json` in the same directory. Copy the contents of the last pass note `kubectl-login for Ops` to the file.
