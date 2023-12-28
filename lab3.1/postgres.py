import psycopg
import os
from script import generate_finds, generate_archs, generate_arch_report, generate_reports

from tqdm import tqdm

USER = os.getenv('POSTGRES_USER')
PASSWORD = os.getenv('POSTGRES_PASSWORD')

data_logs = {   
                'dbname': 'bigArch',
                'user': USER,
                'password': PASSWORD,
                'host': 'localhost'
            }

def insert_query(query, file_path):

    with psycopg.connect(**data_logs) as conn:
        with conn.cursor() as cursor:
            with cursor.copy(query) as copy:
                with open(file_path, 'r') as file:

                    for line in tqdm(file):
                        copy.write(line)


if __name__ == '__main__':

    print("=== Generating archeology.archs")
    # generate_archs(1000000)

    print("=== Copying archeology.archs")
    query = "COPY archeology.archs (last_name, first_name, father_name, special, country_name, lic_card, lic_begin, lic_end) FROM STDIN (format TEXT, delimiter '|')"
    file_path = './data_tables/archs.txt'
    insert_query(query, file_path)

    print("== Finished archeology.archs\n")

    print("=== Generating archeology.reports")
    # generate_reports(1000000)

    print("=== Copying archeology.reports")
    query = "COPY archeology.reports (report_link, report_date) FROM STDIN (format TEXT, delimiter '|')"
    file_path = './data_tables/reports.txt'
    insert_query(query, file_path)

    print("=== Finished archeology.reports\n")

    print("=== Generating archeology.arch_report")
    # generate_arch_report(5000000)

    print("=== Copying archeology.arch_report")

    query = "COPY archeology.arch_report (report_id, arch_id) FROM STDIN (format TEXT, delimiter '|')"
    file_path = './data_tables/arch_report.txt'
    insert_query(query, file_path)
    print("=== Finished archeology.arch_report\n")

    print("=== Generating archeology.finds")
    generate_finds(100000000)

    print("=== Copying archeology.finds")
    query = "COPY archeology.finds (find_coords, find_date, find_info, museum_name, rent_begin, rent_end, report_id) FROM STDIN (format TEXT, delimiter '|')"
    file_path = './data_tables/finds.txt'
    insert_query(query, file_path)

    print("=== Finished archeology.finds\n")
