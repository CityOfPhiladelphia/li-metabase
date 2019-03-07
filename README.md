# Metabase
This is a simple Flask Application that embeds Metabase dashboards.

This allows us to easily restrict access to individual dashboards to specific users in addition to adding the data download button only seen when dashboards are embedded.

## Installation
```bash
$ pip install -r requirements.txt
```
- Get the config.py file from me and put it in your base project directory

### Development Web Server
```bash
$ export FLASK_APP=li_metabase
$ export FLASK_ENV=development
$ flask run
```

### Production Web Server
```bash
$ export FLASK_APP=wsgi
$ flask run
```

## ETL
The ETL is structured so that data is queried from our other databases and then dumped to a temporary pickle file. This pickle file is then read and loaded into the cloud database. This setup minimizes how long database connections are open, which had caused a lot of issues previously. This also allows us to look at the data in the pickle file if something fails and understand if the issue was caused due to the data itself.

Run the etl process for all queries 
```bash
$ cd etl
$ python main.py
```
Run the etl process for one dashboard 

```bash
$ cd etl
$ python cli.py -n dashboard_table_name
``` 
Run the etl process for multiple specified dashboards 
```bash
$ cd etl
$ python cli.py -n dashboard_table_name1 -n dashboard_table_name2
``` 
