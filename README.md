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