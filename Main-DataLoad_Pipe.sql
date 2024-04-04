CREATE OR REPLACE TABLE IOT_DB.PUBLIC.energy_usage_data (
  Day_ INT,
  hour_ INT,
  House_overall_kW FLOAT,
  Dishwasher_kW FLOAT,
  Furnace_kW FLOAT,
  Home_office_kW FLOAT,
  Fridge_kW FLOAT,
  Garage_door_kW FLOAT,
  Kitchen_kW FLOAT,
  Microwave_kW FLOAT,
  Living_room_kW FLOAT,
  Solar_kW  FLOAT,
  temperature FLOAT,
  humidity FLOAT,
  visibility FLOAT,
  pressure FLOAT,
  windSpeed FLOAT
  );


LIST @IOT_DB.external_stages.csv_folder

// Creating Pipe Schema
CREATE OR REPLACE SCHEMA IOT_DB.pipes 

// Define pipe
CREATE OR REPLACE pipe IOT_DB.pipes.iot_data_pipe
auto_ingest = TRUE
AS
COPY INTO IOT_DB.PUBLIC.ENERGY_USAGE_DATA
FROM @IOT_DB.external_stages.csv_folder;

DESC pipe iot_db.pipes.iot_data_pipe;

SELECT COUNT(*) from iot_db.public.energy_usage_data;


SELECT SYSTEM$PIPE_STATUS('iot_data_pipe');

SELECT * 
FROM table(Information_schema.copy_history(table_name =>'iot_db.public.energy_usage_data', 
                                        start_time => dateadd(hours, -1, current_timestamp())));
                                        
SELECT * FROM TABLE(VALIDATE_PIPE_LOAD(
    PIPE_NAME => 'IOT_DB.pipes.iot_data_pipe',
    START_TIME => DATEADD(HOUR,-2,CURRENT_TIMESTAMP())));


