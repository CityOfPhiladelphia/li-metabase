import sys
import datetime

import petl as etl

from li_dbs import (
    ECLIPSE_PROD, LIDB, GISLNI, DataBridge, GISLICLD
)
from sql_queries import queries


class CursorProxy(object):
    def __init__(self, cursor):
        self._cursor = cursor
    def executemany(self, statement, parameters, **kwargs):
        # convert parameters to a list
        parameters = list(parameters)
        # pass through to proxied cursor
        return self._cursor.executemany(statement, parameters, **kwargs)
    def __getattr__(self, item):
        return getattr(self._cursor, item)

def get_cursor(conn):
    return CursorProxy(conn.cursor())

def get_logger():
    import logging
    
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)

    # Create a file handler
    handler = logging.FileHandler('log.txt')
    handler.setLevel(logging.INFO)

    # Create a logging format
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    
    logger.addHandler(handler)

    return logger

def send_email():
    from email.mime.text import MIMEText
    from phila_mail import server

    recipientslist = ['peter.dannemann@Phila.gov', 
                      'dani.interrante@phila.gov', 
                      'philip.ribbens@phila.gov',
                      'shannon.holm@phila.gov']
    sender = 'peter.dannemann@phila.gov'
    commaspace = ', '
    email = 'LI Dashboards ETL failed. Please read the log file and troubleshoot this issue.'
    text = f'AUTOMATIC EMAIL: \n {email}'
    msg = MIMEText(text)
    msg['To'] = commaspace.join(recipientslist)
    msg['From'] = sender
    msg['X-Priority'] = '2'
    msg['Subject'] = 'Important Email'
    server.server.sendmail(sender, recipientslist, msg.as_string())
    server.server.quit()

def get_source_db(query):
    if query.source_db == 'ECLIPSE_PROD':
        return ECLIPSE_PROD.ECLIPSE_PROD
    elif query.source_db == 'LIDB':
        return LIDB.LIDB
    elif query.source_db == 'GISLNI':
        return GISLNI.GISLNI
    elif query.source_db == 'DataBridge':
        return DataBridge.DataBridge
    elif query.source_db == 'GISLICLD':
        return GISLICLD.GISLICLD

def get_extract_query(query):
    with open(query.extract_query_file) as sql:
        return sql.read()

def etl_(query, target):
    source_db = get_source_db(query)
    extract_query = get_extract_query(query)
    target_table = query.target_table

    with source_db() as source:
        etl.fromdb(source, extract_query) \
           .todb(get_cursor(target), target_table.upper())

def etl_process(queries):
    logger = get_logger()
    logger.info('---------------------------------')
    logger.info('ETL process initialized: ' + str(datetime.datetime.now()))
    
    with GISLICLD.GISLICLD() as target:
        for query in queries:
            try:
                etl_(query, target)
                logger.info(f'{query.target_table} successfully updated.')
            except:
                logger.error(f'ETL Process into GISLICLD.{query.target_table} failed.', exc_info=True)

    logger.info('ETL process ended: ' + str(datetime.datetime.now()))


def main():
    global queries
    etl_process(queries)

if __name__ == '__main__':
    try:
        main()
    except:
        send_email()