// Creating Database
CREATE OR REPLACE DATABASE IOT_DB;


// Creating Schema for File formats and add csv fileformat.
CREATE OR REPLACE SCHEMA IOT_DB.file_formats;
CREATE OR REPLACE file format IOT_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE;

CREATE OR REPLACE SCHEMA IOT_DB.external_stages;

CREATE OR REPLACE STAGE IOT_DB.external_stages.aws_stage
    url='s3://<BUCKET_NAME>'
    credentials=(aws_key_id='<YOUR_AWS_KEY>' aws_secret_key='<YOUR_AWS_SECRET_KEY>');
    
 // Create Storage Integration to S3    
create or replace storage integration s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = '<AWS_ROLE_ARN'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<BUCKET_NAME>/<folder-name>')

DESC integration s3_int;  
  

 // Create stage object with integration object & file format object
CREATE OR REPLACE stage IOT_DB.external_stages.csv_folder
    URL = 's3://<BUCKET_NAME>/<folder-name>/<sub-folder-name>'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = IOT_DB.file_formats.csv_fileformat;