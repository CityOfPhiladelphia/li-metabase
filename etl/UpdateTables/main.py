import sys
import datetime
import os

import petl as etl

from li_dbs import (
    ECLIPSE_REPORTS, LIDB, GISLNI, DataBridge, GISLICLD, GISLNIDB, GISLNIDBX
)
from li_utils import li_utils
from sql_queries import queries


class CursorProxy(object):
    '''Required to use petl with cx_Oracle https://petl.readthedocs.io/en/stable/io.html#databases'''
    def __init__(self, cursor):
        self._cursor = cursor
    def executemany(self, statement, parameters, **kwargs):
        parameters = list(parameters)
        return self._cursor.executemany(statement, parameters, **kwargs)
    def __getattr__(self, item):
        return getattr(self._cursor, item)


def get_cursor(conn):
    return CursorProxy(conn.cursor())


def get_source_db(query):
    if query.source_db == 'ECLIPSE_REPORTS':
        return ECLIPSE_REPORTS.ECLIPSE_REPORTS
    elif query.source_db == 'LIDB':
        return LIDB.LIDB
    elif query.source_db == 'GISLNI':
        return GISLNI.GISLNI
    elif query.source_db == 'DataBridge':
        return DataBridge.DataBridge
    elif query.source_db == 'GISLICLD':
        return GISLICLD.GISLICLD
    elif query.source_db == 'GISLNIDB':
        return GISLNIDB.GISLNIDB
    elif query.source_db == 'GISLNIDBX':
        return GISLNIDBX.GISLNIDBX


def get_extract_query(query):
    with open(query.extract_query_file) as sql:
        return sql.read()


def etl_(query):
    source_db = get_source_db(query)
    extract_query = get_extract_query(query)

    with source_db() as source:
        etl.fromdb(source, extract_query) \
           .topickle(f'temp/{query.target_table}.p')

    with GISLNIDBX.GISLNIDBX() as target:
        etl.frompickle(f'temp/{query.target_table}.p') \
           .todb(get_cursor(target), query.target_table.upper())


def etl_process(queries):
    logger = li_utils.get_logger(log_file_path='log.txt')
    logger.info('---------------------------------')
    logger.info('ETL process initialized: ' + str(datetime.datetime.now()))
    
    failed = []

    for query in queries:
        try:
            etl_(query)
            logger.info(f'{query.target_table} successfully updated.')
        except:
            logger.error(f'ETL Process into GISLNIDBX.{query.target_table} failed.', exc_info=True)
            failed.append(query.target_table)

    logger.info('ETL process ended: ' + str(datetime.datetime.now()))

    if len(failed) > 0:
        subject = 'Dashboards ETL Failure'
        body = 'AUTOMATIC EMAIL: \n' + '\n\nThe following tables failed to update:\n\n' + ', \n'.join(failed)
        li_utils.send_email(subject=subject, body=body, priority=2)


def main():
    global queries
    etl_process(queries)


if __name__ == '__main__':
    main()