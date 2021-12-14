PROJECT=$(gcloud config get-value project)
BUCKET=$PROJECT-ml

gcloud sql instances create flights \
--database-version=POSTGRES_13 --cpu=2 --memory=8GiB \
--zone=us-central1-f --root-password=n23w5k3GoAvev4mw

gcloud sql databases create bts \
--instance=flights

gcloud sql databases list \
--instance=flights

gsutil cp create_table.sql gs://$BUCKET/flights/sql/create_table.sql
