import sqlite3
import random
import csv
from datetime import datetime, timedelta

# Database connection
db_conn = sqlite3.connect("data/ticketSystem.sqlite")

# Rooms
letters = ("A", "B", "C", "D", "E", "F")
rooms = list()

for letter in letters:
    for i in range(3):
        for j in range(12):
            room = letters[i] + str(i) + str(j)
            rooms.append(room)

# Error constants
types = ("software", "hardware")
errors_software = ("startet nicht", "stuerzt ab", "haengt nach XY", "fehlermeldung xy")
errors_hardware = ("funktioniert nicht", "brennt", "explodiert")
devices_hardware = ("drucker", "PC-00", "PC-01", "PC-02", "PC-03", "PC-04", "PC-05", "PC-06", "beamer")
devices_software = ("excel", "word", "powerpoint", "visio", "teams", "outlook")


def generate_random_errors(n):
    errors = list()

    for i in range(1, n+1):
        error_type = random.choice(types)
        # description and device
        if error_type == "software":
            error_description = random.choice(errors_software)
            error_device = random.choice(devices_software)
        else:
            error_description = random.choice(errors_hardware)
            error_device = random.choice(devices_hardware)

        generated_error = (i, error_type, error_description, error_device)
        errors.append(generated_error)

    return errors


def generate_random_tickets(n):
    tickets = list()

    for i in range(1, n+1):
        raum = random.choice(rooms)
        status = random.choice(("erstellt", "in Bearbeitung", "behoben"))
        einsteller = get_random_name()
        bearbeiter = None  # Entweder Null oder random Name
        datum_erstellt = generate_random_datetime()  # Immer ein Datum
        datum_geschlossen = None  # Entweder Null oder random, wenn status = fertig

        if status == "behoben":
            while True:
                bearbeiter = get_random_name()
                datum_geschlossen = generate_random_datetime()
                if bearbeiter != einsteller and datum_erstellt < datum_geschlossen:
                    break
        elif status == "in Bearbeitung":
            while True:
                bearbeiter = get_random_name()
                if bearbeiter != einsteller:
                    break

        generated_ticket = (i, raum, status, i, einsteller, bearbeiter, datum_erstellt, datum_geschlossen)
        tickets.append(generated_ticket)

    return tickets


def generate_random_datetime(min_year=2020, max_year=2021):
    start_date = datetime(min_year, 1, 1, 00, 00, 00)
    years_difference = max_year - min_year + 1
    end_date = start_date + timedelta(days=365 * years_difference)
    return start_date + (end_date - start_date) * random.random()


def insert_random_data(n=20):
    db_conn.executemany("INSERT INTO tbl_fehler VALUES(?,?,?,?)", generate_random_errors(n))
    db_conn.executemany("INSERT INTO tbl_ticket VALUES(?,?,?,?,?,?,?,?)", generate_random_tickets(n))


with open("data/namen.csv") as file:
    reader = csv.reader(file)
    names = list(reader)


def get_random_name():
    random_name = random.choice(names)
    return "{}, {}".format(random_name[1], random_name[0])


insert_random_data(50000)

db_conn.commit()
db_conn.close()
