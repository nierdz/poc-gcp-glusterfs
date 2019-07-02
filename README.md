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
