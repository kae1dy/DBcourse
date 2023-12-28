
import random
from random import randrange, uniform
import re
from country_list import countries_for_language

def generate_surnames_and_names(num):
    surnames = ['Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor', 'Kools', 'Rotor', 'Cooke', 'Parry',
    'Burgess',
    'Walton',
    'Bishop',
    'Henderson',
    'Nicholson',
    'Burns',
    'Shepherd',
    'Morozov',
    'Protopopov',
    'Mitrofanov',
    'Artamonov'
    ]
    spec = [
                        'Field', 
                        'Anthropologist',
                        'Ceramologist',
                        'Archaeozoologist',
                        'Marine'
    ]
    qual = [
                        'Assistant',
                        'Senior Assistant',
                        'Researcher',
                        'Junior Researcher',
                        'Senior Researcher',
                        'Leading Researcher'
    ]
    names = ['John', 'Michael', 'David', 'James', 'Robert', 'William', 'Joseph', 'Charles', 'Thomas', 'Daniel', 'Ilya', 'Nikolay', 'Steven', 'Julia', 'Victoria', 'Sofia', 'Ivan']
    
    surnames_and_names = []
    father_names = ['Andrew', 'Benjamin', 'Christopher', 'Daniel', 'Edward', 'Frank', 'George', 'Henry', 'Isaac', 'Jacob', 'Petr', 'Fedor', 'Ivan', 'Michael']

    
    for _ in range(num):
        surname = random.choice(surnames)
        name = random.choice(names)
        qul = random.choice(qual)
        print(f"('{surname}', '{name}', '{random.choice(father_names)}', {(qual.index(qul) + 1) * uniform(2000, 6000):0.2f}, '{random.choice(spec)}', '{qul}',")

# Generate 30 surnames and names
# generate_surnames_and_names(30)

def parse(text_file):
    with open(text_file, 'r') as f:
        l = f.readline()
        l = re.sub('[- ]', '', l)
        print(*l.split(','), sep='\n')

def random_number(num): 
    l = ['P', 'R', 'A']
    alp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    for _ in range(num):
        s = random.choice(l)
        for i in range(11):
            s += random.choice(alp)
        print(s)

# random_number(30)
 
def gen_date(num):
    s = []
    while num:
        x = random.randint(1, 19)
        y = random.randint(1, 30)
        if ((x, y) not in s):
            print(f"({x}, {y}),")
            num -= 1
            s.append((x, y))

# gen_date(84)

def gen_find(num):
    for _ in range(num):
        c = random.randint(0, 10)
        y = random.randint(1980, 2019)
        m = random.randint(1, 12)
        d = random.randint(1, 28)
        print(f"({c}, '', '{y}-{m:02}-{d:02}', {random.randint(1, 10)}, {random.randint(1, 10)}, {random.randint(1, 10)}),")

# gen_find(30)

def gen_country():
    countries = dict(countries_for_language('en'))
    for i, country in enumerate(countries.values(), 1):
        print(f"{i} : ('{country}'),")


def gen_coords(text_file):

    with open(text_file, 'r') as f:
        for line in f.readlines():
            l = line.split(', ')
            x = uniform(-90, 90)
            y = uniform(-180, 180)
            l[1] = f"point({x:0.6f}, {y:0.6f})"
            print(", ".join(l), end='')

gen_coords("./test.txt")





