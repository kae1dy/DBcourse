from names_dataset import NameDataset

import random
from tqdm import tqdm
from country_list import countries_for_language


def random_date(year_min, year_max):
    s = f"{random.randint(year_min, year_max + 1)}-{random.randint(1, 12):02}-{random.randint(1, 28):02}"
    return s


def generate_archs(num, num_names=1000):
    """
    arch_id bigserial PRIMARY KEY,
    last_name text NOT NULL,
    first_name text NOT NULL, 
    father_name text,
    special spec[],
    country_name text UNIQUE NOT NULL
    
    lic_card varchar(12) CHECK(lic_card SIMILAR TO '(P|R|A)%') UNIQUE NOT NULL,
    lic_begin DATE NOT NULL,
    lic_end DATE NOT NULL CHECK(lic_end > lic_begin)
    """
    def random_lic_card(): 
        alp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
        s = random.choice(['P', 'R', 'A'])
        for i in range(11):
            s += random.choice(alp)
        return s


    nd = NameDataset()
    names = nd.get_top_names(n=num_names // 2, country_alpha2='US')['US']
    first_names = names['M'] + names['F']
    last_names = nd.get_top_names(n=num_names, use_first_names=False, country_alpha2='US')['US']

    countries = list(dict(countries_for_language('en')).values())
    spec = ['"Field"', '"Anthropologist"', '"Ceramologist"', '"Archaeozoologist"', '"Marine"']

    with open('./data_tables/archs.txt', 'a') as file:
        for _ in tqdm(range(num)):
            file.write(
                    f'{random.choice(last_names)}|'
                    f'{random.choice(first_names)}|'
                    f'{random.choice(first_names)}|'
                    f'{{{",".join(random.sample(spec, random.randint(1, 3)))}}}|'
                    f'{random.choice(countries)}|'
                    f'{random_lic_card()}|'
                    f'{random_date(2019, 2022)}|'
                    f'{random_date(2024, 2026)}\n'
                    )


# generate_archs(int(10e6))


def generate_finds(num):
    """
    find_id bigserial PRIMARY KEY,
    find_coords point,
    find_date DATE NOT NULL,
    find_info jsonb,
    
    museum_name text NOT NULL,
    rent_begin DATE NOT NULL,
    rent_end DATE NOT NULL CHECK(rent_end > rent_begin),
    
    report_id int REFERENCES archeology.reports
    """

    museums = [line.strip() for line in open("museums.txt")]
    types = ['Jewel', 'Art', 'Houseware', 'Architecture', 'Mechanism', 'Mummy', 'Coin', 'Weapon', 'Artifact', 'Sculpture', 'Other']

    with open('./data_tables/finds.txt', 'a') as file:
        for num in tqdm(range(num)):

            condition = random.randint(0, 10)
            year = random.randint(-10000, 1000)

            file.write(
                    f"({random.uniform(-90, 90):0.6f}, {random.uniform(-180, 180):0.6f})|"
                    f"{random_date(2000, 2019)}|"
                    f'{{"type": "{random.choice(types)}", '
                    f'"condition": {condition}, '
                    f'"price": {random.uniform(50000, 1000000):0.2f}, '
                    f'"year_min": {year}, '
                    f'"year_max": {year + random.randrange(0, 500, 100)}}}|'
                    f"{random.choice(museums)}|"
                    f"{random_date(2019, 2022)}|"
                    f"{random_date(2024, 2027)}|"
                    f"{random.randint(1, 1000000)}\n"
                    )


def generate_reports(num):
    """
    report_id BIGSERIAL PRIMARY KEY,
    report_link text NOT NULL, 
    report_date DATE NOT NULL
    """

    def random_url(): 
        url = 'https://www.jstor.org/stable/'
        alp = '0123456789'
        for i in range(9):
            url += random.choice(alp)
        return url
    
    with open('./data_tables/reports.txt', 'a') as file:
        for _ in tqdm(range(num)):
            file.write(f'{random_url()}|{random_date(2018, 2022)}\n')


def generate_arch_report(num):
    """
    report_id bigint REFERENCES archeology.reports ON DELETE CASCADE,
    arch_id bigint REFERENCES archeology.archs,
    """
    with open('./data_tables/arch_report.txt', 'a') as file:
        uniq_ids = set()
        for _ in tqdm(range(num)):

            report_id = random.randint(1, 1000000)
            arch_id = random.randint(1, 1000000)

            while (report_id, arch_id) in uniq_ids:
                report_id = random.randint(1, 1000000)
                arch_id = random.randint(1, 1000000)

            uniq_ids.add((report_id, arch_id))

            file.write(f'{report_id}|{arch_id}\n')
