import click

from main import etl_process
from sql_queries import queries


@click.command()
@click.option(
    '--name',
    '-n',
    multiple=True,
    prompt='Names of dashboard table(s) to ETL',
    help='The dashboard tables to ETL.'
)
def main(name):
    global queries
    table = [query for query in queries if query.target_table in name]
    etl_process(table)

if __name__ == '__main__':
    main()