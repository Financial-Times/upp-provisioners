#!/bin/bash

__kube_ps1()
{
    # Get current context if KUBECONFIG is set
    if [ -n "$KUBECONFIG" ] ; then
        CONTEXT=$(kubectl config current-context)
        
        if [ -n "$CONTEXT" ] ; then
            echo "${CONTEXT}"
        fi
    fi
}

echo -e "
~~~

\e[31mKubernetes Instructions\e[39m

To show available clusters:
list-clusters

To connect to a cluster:
source cluster-login.sh upp-delivery-prod-eu
"

export PS1='[\u (k8s: $(__kube_ps1)) \W]\$ '
