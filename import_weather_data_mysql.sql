drop table if exists local_weather;

create table local_weather (
	id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	zip5 INT(11) NOT NULL,
	dateStr VARCHAR(20) NOT NULL DEFAULT '0000-00-00 00:00:00',
	TemperatureF    FLOAT(5,2) NULL DEFAULT NULL,
	DewpointF       FLOAT(5,2) NULL DEFAULT NULL,
	Pressure        FLOAT(5,2) NULL DEFAULT NULL,
	WindSpeed       FLOAT(5,2) NULL DEFAULT NULL,
	Humidity        FLOAT(5,2) NULL DEFAULT NULL,
	Clouds          VARCHAR(10) NULL DEFAULT NULL,
	HourlyPrecip    FLOAT(5,2) NULL DEFAULT NULL,
	SolarRadiation  FLOAT(6,2) NULL DEFAULT NULL
);

LOAD DATA LOCAL INFILE 'your/path/to/weather_data_export.csv' 
	INTO TABLE local_weather 
	FIELDS TERMINATED BY ','  
	LINES TERMINATED BY '\n'
  IGNORE 1 LINES
	(dateStr, TemperatureF, DewpointF, Pressure, WindSpeed, Humidity, HourlyPrecip, zip5);

ALTER TABLE local_weather ADD COLUMN `date` DATETIME;
UPDATE local_weather SET `date` = STR_TO_DATE(dateStr, '%Y-%m-%d %H:%i:%s');
--ALTER TABLE local_weather ADD CONSTRAINT zip_date PRIMARY KEY(zip5, `date`);

create index zip5_date_idx on local_weather(zip5,date);
create index zip5_idx on local_weather(zip5);
create index date_idx on local_weather(date);

ALTER TABLE local_weather DROP COLUMN `dateStr`;

