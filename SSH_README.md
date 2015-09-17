# SSH_README

_... set up your dev env so you can spin up a cluster, or communicate with an existing one._

# FIRST TIME ONLY

        # ... create new ed25519 key
        ssh-keygen -t ed25519

        # Now give your ~/.ssh/id_ed25519.pub key to a Coco Admin.

        # ... [OPTIONAL] FIRST TIME ONLY: create an rsa key to talk to FT private stash
        #     - not needed once everything is gloriously open source in github 
        ssh-keygen -t rsa

# SSH SETUP FOR FLEETCTL

    # ... create an ssh keyring so that our fleet entry host can pass on creds
    #     to other 'hosts'
    eval $(ssh-agent)
    ssh-add ~/.ssh/id_ed25519
    ssh-add -l # verify your key has been added to the key-ring


