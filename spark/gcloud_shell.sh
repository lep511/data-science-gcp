export PROJECT=$(gcloud info --format='value(config.project)')
gcloud config set project $PROJECT
gsutil mb -c regional -l us-central1 gs://$PROJECT
bq mk lake
wget https://github.com/lep511/data-science-gcp/raw/main/spark/breast.csv
wget https://github.com/lep511/data-science-gcp/raw/main/spark/ingest.py
gsutil cp breast.csv gs://$PROJECT/data_files/