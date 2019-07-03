# Gluster POC on GCP
Setup 4 nodes on GCP to try glusterfs
Nodes have additional disk attached and formated as xfs
This node is used as a brick for glusterfs

### GCP project
1. You need to install [gcloud sdk](https://cloud.google.com/sdk/install)
2. Go to Google cloud console and create a new project called `gluster-poc`
3. Go to **IAM & admin**, then **Service Accounts** and create a service account with **Project owner** role.
4. Create a json key associate to this service account and rename it to `gluster-poc.json` (we will use this key to do everything related to this GCP project)
5. Put this key inside `~/.gcloud/gluster-poc.json` and setup your project with this bunch of gcloud commands:
```
gcloud config configurations create gluster-poc --no-activate
export CLOUDSDK_ACTIVE_CONFIG_NAME=gluster-poc
gcloud --configuration gluster-poc config set project gluster-poc
gcloud auth activate-service-account --key-file ~/.gcloud/gluster-poc.json
```
6. Source `env.sh` to export some important environment variables and you should be ready to use **gcloud**
```
source env.sh
```

### GCP backend
```
gsutil mb -p ${GCE_PROJECT} gs://${GCE_PROJECT}
```

Enable versioning:
```
gsutil versioning set on gs://${GCE_PROJECT}
```

### Terraform
```
terraform init
terraform apply
```

### Some explanations
This POC is designed to setup a gluster cluster where all nodes have all the data. Typically, this could be useful for old app used to use NFS shared or more generally shared fylesystem.
In [startup.sh](scripts/startup.sh) you have everything to setup a 4 nodes cluster. This script is launched everytime a node is booted.
If you loose one or more node this is where we use `ansible` to replace the failing node. One node is selected as donor, typically, this is the node we run ansible against. The replacing node is setup in a variable named `gluster_new_node`.
You can find an example of a playbook to replace `gluster-3` using `gluster-0` as a donor [here](playbook.yml)
Procedure to replace a gluster node with same hostname could be done [here](https://access.redhat.com/documentation/en-us/red_hat_gluster_storage/3/html/administration_guide/sect-replacing_hosts#Replacing_a_Host_Machine_with_the_Same_Hostname)

### Loosing one node

- Try to delete `gluster-3` from GCP dashboard. Delete disk also if you want.
- Run `terraform apply` to create gluster-3 again
- To join again gluster-3 in cluster you need to run ansible like this:

```
ansible-playbook -u admin -i scripts/gce.py -l gluster-0 playbook.yml
```

This will use gluster-0 as reference node
