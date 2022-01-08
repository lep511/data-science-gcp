sudo pip3 install virtualenv
virtualenv -p python3 venv
source venv/bin/activate
pip install apache-beam[gcp]==2.35.0

python ingest.py \
--project=$PROJECT \
--region=us-central1 \
--runner=DataflowRunner \
--staging_location=gs://$PROJECT/test \
--temp_location gs://$PROJECT/test \
--input gs://$PROJECT/data_files/breast.csv \
--save_main_session