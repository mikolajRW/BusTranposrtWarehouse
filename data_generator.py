import csv
from faker import Faker
import random
from datetime import datetime, timedelta


def find_index(arr, number_of_bus):
    for x in range(len(arr)):
        if arr[x][0] == number_of_bus:
            return x


def find_in_csv(csv_file, buses_line):
    for x in range(len(csv_file)):
        if csv_file[x][2] == buses_line:
            return x


def find_stop(arr_stops_with_index, name_of_bus_stop):
    for x in range(len(arr_stops_with_index)):
        if arr_stops_with_index[x][1] == name_of_bus_stop:
            return x

def find_stop_name(arr_stops_with_index, stationsID):
    for x in range(len(arr_stops_with_index)):
        if arr_stops_with_index[x][0] == stationsID:
            return arr_stops_with_index[x][1]


def check_how_many_stops(array, course_nr):
    how_many_stops = 0
    for x in range(len(array)):
        if array[x][0] == course_nr:
            how_many_stops = how_many_stops + 1

    return how_many_stops


def find_index_for_course(array, bus_number, number_of_courses):
    for x in range(number_of_courses):
        if array[x][1] == bus_number and array[x][8] and not array[x][5] and not array[x][9]:
            return x


def find_index_for_array_with_stops(array, course):
    for x in range(len(array)):
        if array[x][0] == course:
            return x


def check_failure_action(course_info, course_id):
    if course_info[course_id][5]:
        return "Give"
    elif course_info[course_id][9]:
        return "Take"
    else:
        return "None"


def gen_stops_and_courses(stops_name_with_index, start, drivers, buses):
    end_number = 0
    courses = []
    output = []
    tmp = []

    for x in range(75):
        tmp.append([f.unique.bothify(text="?##", letters="N1111111"), stops_name_with_index[random.randint(0, len(stops_name_with_index) - 1)][1],
                    stops_name_with_index[random.randint(0, len(stops_name_with_index) - 1)][1]])

    if start > 110:
        iterator = 3000
    else:
        iterator = 45000

    need_continuity = False
    for x in range(iterator):  # 40k
        temp = []
        if need_continuity:
            temp.append(start + x)
            temp.append(tmp[index_of_bus][0])
            temp.append(route)
            temp.append(beg_stop)
            temp.append(fin_stop)
            temp.append(False)
            driv = drivers[random.randint(0, len(drivers) - 1)][0]
            bus = buses[random.randint(0, len(buses) - 1)][0]
            temp.append(driv)
            temp.append(bus)
            temp.append(False)  # n bool oznacza czy juz do tego kursu przydzielilem przystanki
            temp.append(True)  # ten bool oznacza czy to jest kontynuacja kursu czy nie przyda sie przy csv
            output.append([None, tmp[index_of_bus][0], route, "False", driv, bus, "True", None])
            courses.append(temp)
            need_continuity = False
        else:
            temp.append(start + x)
            index_of_bus = random.randint(0,74)
            temp.append(tmp[index_of_bus][0])
            beg_stop = tmp[index_of_bus][1]
            fin_stop = tmp[index_of_bus][2]
            route = beg_stop + ' -> ' + fin_stop
            temp.append(route)
            temp.append(beg_stop)
            temp.append(fin_stop)
            if random.choice(range(0, 15)) <= 1:
                temp.append(True)
                helper = "True"
                need_continuity = True
            else:
                temp.append(False)
                helper = "False"
            driv = drivers[random.randint(0, len(drivers) - 1)][0]
            bus = buses[random.randint(0, len(buses) - 1)][0]
            temp.append(driv)
            temp.append(bus)
            temp.append(False)  # ten bool oznacza czy juz do tego kursu przydzielilem przystanki
            temp.append(False)  # ten bool oznacza czy to jest kontynuacja kursu czy nie przyda sie przy csv
            output.append([None, tmp[index_of_bus][0], route, helper, driv, bus, "False", None])
            courses.append(temp)

    array_helper = []
    stops_during_one_course = []  # tablica z przystankami podczas jednego kursu
    array_with_bus_numbers = []  # tablica z numerami autbusow
    for x in range(len(courses)):
        if [courses[x][1]] not in array_helper:
            if courses[x][1][0] == 'N':
                start_hour = [random.randint(0, 6), random.randint(0, 6), random.randint(0, 6),
                              random.randint(0, 6)]
            else:
                start_hour = [random.randint(6, 19), random.randint(6, 19), random.randint(6, 19),
                              random.randint(6, 19)]
            end_hour = [start_hour[0] + 1, start_hour[1] + 1, start_hour[2] + 1, start_hour[3] + 1, ]
            array_helper.append([courses[x][1]])
            array_with_bus_numbers.append([courses[x][1], False, start_hour, end_hour, False, False, False,
                                           False, stops_name_with_index[find_stop(stops_name_with_index, courses[x][3])][0],
                                           stops_name_with_index[find_stop(stops_name_with_index, courses[x][4])][0], None, [],[],[],[]])  # zeby nie bylo wiecej niz jednego autbusu

    for x in range(len(array_with_bus_numbers)):
        number_of_stops = random.randint(15, 30)
        bus_number_route = []
        bus_number_route.append(array_with_bus_numbers[x][8])
        for i in range(1, number_of_stops):
            bus_stop_id = stops_name_with_index[random.choice(range(len(stops_name_with_index)))][0]
            if bus_stop_id not in bus_number_route and bus_stop_id != array_with_bus_numbers[x][9]:
                bus_number_route.append(bus_stop_id)
        bus_number_route.append(array_with_bus_numbers[x][9])
        array_with_bus_numbers[x][10] = bus_number_route

    for x in range(len(array_with_bus_numbers)):
        clean_duration = 0
        start_date = datetime(2015, 1, 1)
        end_date = datetime(2024, 12, 31)
        random_days = random.randint(0, (end_date - start_date).days)
        beg_hour = 0
        for _ in range(4):
            clean_hour = array_with_bus_numbers[x][2][0+beg_hour]
            tmp = []
            for i in range(len(array_with_bus_numbers[x][10])):
                date = start_date + timedelta(days=random_days)
                current_trip_duration = random.randint(1, 5)
                clean_duration += current_trip_duration
                if clean_duration > 59:
                    clean_duration -= 60
                    clean_hour += 1
                if clean_hour == 24:
                    clean_hour = 0
                date_planned = datetime.strptime(f"{clean_hour}:{clean_duration}:{0}", "%H:%M:%S").time()
                tmp.append(datetime.combine(date, date_planned))
            array_with_bus_numbers[x][11 + beg_hour] = tmp
            beg_hour += 1

    index_of_last_course = len(courses)
    need_continuity = False
    for x in range(len(courses)):
        number_of_stops = 0
        cruise_nr = courses[x][1]  # Numer autobusu w kursie
        index = find_index(array_with_bus_numbers, cruise_nr)
        if need_continuity:
            for i in range(len(array_with_bus_numbers[index][10]) - shorter_route, len(array_with_bus_numbers[index][10])):
                stops_during_one_course.append([courses[x][0], array_with_bus_numbers[index][10][i]])
                number_of_stops+=1
            output[x][7] = number_of_stops
            need_continuity = False
        else:
            if not courses[x][5]:
                for i in range(len(array_with_bus_numbers[index][10])):
                    stops_during_one_course.append([courses[x][0], array_with_bus_numbers[index][10][i]])
                    number_of_stops += 1
                output[x][7] = number_of_stops
            else:
                shorter_route = random.randint(4, 6)
                for i in range(len(array_with_bus_numbers[index][10]) - shorter_route):
                    stops_during_one_course.append([courses[x][0], array_with_bus_numbers[index][10][i]])
                    number_of_stops += 1
                output[x][7] = number_of_stops
                need_continuity = True

    return [stops_during_one_course, array_with_bus_numbers, courses, output, index_of_last_course]


def gen_ztmotion(courses, array_with_bus_numbers, stops_during_one_course):
    timetable = []
    index = find_index(array_with_bus_numbers, courses[0][1])
    new_course = True
    courses_nr = 0
    total_delay = 0
    assign_hour = 0
    which_hour = random.randint(0, 3)
    need_continuity = False
    delay_because_technical_issues = 0
    for x in range(len(stops_during_one_course)):
        csv_file = []
        current_course = stops_during_one_course[x][0]
        if x != 0:
            if current_course != stops_during_one_course[x - 1][0]:
                courses_nr += 1
                cruise_nr = courses[courses_nr][1]  # Numer autobusu w kursie
                index = find_index(array_with_bus_numbers, cruise_nr)
                if not need_continuity:
                    assign_hour = 0
                    which_hour = random.randint(0, 3)
                if need_continuity:
                    delay_because_technical_issues = random.randint(40, 59)
                total_delay = 0

        current_stop_delay = random.randint(-1, 3)
        total_delay += current_stop_delay
        csv_file.append(stops_during_one_course[x][0])
        csv_file.append(stops_during_one_course[x][1])
        csv_file.append(array_with_bus_numbers[index][0])
        csv_file.append(array_with_bus_numbers[index][11+which_hour][assign_hour])
        csv_file.append((current_stop_delay+delay_because_technical_issues) * 60)
        if random.randint(0, 10) <= 1:
            csv_file.append(random.randint(0, 20))
            csv_file.append(True)
        else:
            csv_file.append(random.randint(10, 30))
            csv_file.append(False)
        csv_file.append(check_failure_action(courses, courses_nr))
        assign_hour = assign_hour + 1
        timetable.append(csv_file)
        delay_because_technical_issues = 0
        if need_continuity:
            need_continuity = False
        if courses[courses_nr][5]:
            need_continuity = True


    return timetable


def gendrivers2024(faker_pt):
    drivers = [[faker_pt.unique.pesel(), faker_pt.first_name(), faker_pt.last_name(), faker_pt.unique.email(),
                faker_pt.unique.bothify(text="#########", letters="0123456789")]
               for _ in range(7000)]  # 7k
    with open('drivers2020-2024.csv', 'w', newline='', encoding="UTF-8") as drivers_snapshot2:
        writer = csv.writer(drivers_snapshot2)
        writer.writerows(drivers)
        drivers_snapshot2.close()

    return drivers


def gendrivers2015(faker_pt):
    drivers = [[faker_pt.unique.pesel(), faker_pt.first_name(), faker_pt.last_name(), faker_pt.unique.email(),
                faker_pt.unique.bothify(text="#########", letters="0123456789")]
               for _ in range(70000)]  # 70k
    with open('drivers2015-2020.csv', 'w', newline='', encoding="UTF-8") as drivers_snapshot1:
        writer = csv.writer(drivers_snapshot1)
        writer.writerows(drivers)
        drivers_snapshot1.close()

    return drivers


def genbusesrepairs2015(faker_pt):
    buses = [[faker_pt.unique.vin(), faker_pt.unique.license_plate(), faker_pt.unique.bothify(text="#####"),
              random.choice(range(1, 32))]
             for _ in range(70000)]  # 70k
    with open('buses2015-2020.csv', 'w', newline='') as buses_snapshot1:
        writer = csv.writer(buses_snapshot1)
        writer.writerows(buses)
        buses_snapshot1.close()

    repairs = []
    for _ in range(20000):  # 20k
        lower_bound = faker_pt.date_time_between(datetime(2015, 1, 1), datetime(2019, 12, 31))
        end_rep = faker_pt.date_time_between(lower_bound, datetime(2019, 12, 31))
        repairs.append([None, lower_bound.strftime('%Y-%m-%d %H:%M:%S'), end_rep.strftime('%Y-%m-%d %H:%M:%S'),
                        round(random.uniform(100.00, 29999.99), 2), buses[random.choice(range(700))][0]])
    with open('repairs2015-2020.csv', 'w', newline='') as repairs_snapshot1:
        writer = csv.writer(repairs_snapshot1)
        writer.writerows(repairs)
        repairs_snapshot1.close()
        repairs_snapshot1.close()

    return buses


def genbusesrepairs2024(faker_pt):
    buses = [[faker_pt.unique.vin(), faker_pt.unique.license_plate(), faker_pt.unique.bothify(text="#####"),
              random.choice(range(32, 35))]
             for _ in range(10000)]  # 10k
    with open('buses2020-2024.csv', 'w', newline='') as buses_snapshot2:
        writer = csv.writer(buses_snapshot2)
        writer.writerows(buses)
        buses_snapshot2.close()

    repairs = []
    for _ in range(5000):  # 5k
        # Generate a random date within the specified range
        lower_bound = faker_pt.date_time_between(datetime(2020, 1, 1), datetime(2024, 12, 31))
        end_rep = faker_pt.date_time_between(lower_bound, datetime(2024, 12, 31))
        repairs.append([None, lower_bound.strftime('%Y-%m-%d %H:%M:%S'), end_rep.strftime('%Y-%m-%d %H:%M:%S'),
                        round(random.uniform(1000.00, 39999.99), 2), buses[random.choice(range(100))][0]])

    with open('repairs2020-2024.csv', 'w', newline='') as repairs_snapshot2:
        writer = csv.writer(repairs_snapshot2)
        writer.writerows(repairs)
        repairs_snapshot2.close()

    return buses


def genservices():
    services = ["Oil Change", "Brake Inspection", "Brake Adjustment", "Brake Pad Replacement",
                "Brake Caliper Replacement", "Brake Fluid Flush", "Transmission Fluid Change", "Transmission Flush",
                "Transmission Inspection", "Engine Tune-Up", "Engine Oil Leak Repair", "Engine Belt Replacement",
                "Engine Hose Replacement", "Engine Mount Replacement", "Engine Coolant Flush",
                "Fuel Filter Replacement", "Air Filter Replacement", "Cabin Air Filter Replacement", "Tire Rotation",
                "Tire Replacement", "Wheel Alignment", "Wheel Balancing", "Suspension Inspection",
                "Shock Absorber Replacement", "Strut Replacement", "Steering Rack Replacement",
                "Power Steering Fluid Flush", "Power Steering Pump Replacement", "Battery Testing",
                "Battery Replacement", "Alternator Testing", "Alternator Replacement", "Starter Motor Testing",
                "Starter Motor Replacement", "Ignition System Inspection", "Ignition Coil Replacement",
                "Spark Plug Replacement", "Glow Plug Replacement", "Exhaust System Inspection",
                "Muffler Replacement", "Catalytic Converter Replacement", "Diesel Particulate Filter (DPF) Cleaning",
                "Diesel Exhaust Fluid (DEF) Refill", "Emission Control System Inspection", "EGR Valve Replacement",
                "Turbocharger Inspection", "Turbocharger Replacement", "Fuel Injector Cleaning",
                "Fuel Injector Replacement", "Throttle Body Cleaning", "Throttle Body Replacement",
                "Intake Manifold Gasket Replacement", "Exhaust Manifold Gasket Replacement", "Radiator Inspection",
                "Radiator Flush", "Radiator Hose Replacement", "Heater Core Replacement", "Thermostat Replacement",
                "Water Pump Replacement", "Cooling Fan Inspection", "Cooling Fan Replacement",
                "AC System Inspection", "AC Refrigerant Recharge", "AC Compressor Replacement",
                "AC Condenser Replacement", "Heater System Inspection", "Heater Blower Motor Replacement",
                "HVAC Control Module Replacement", "Wiper Blade Replacement", "Windshield Washer Fluid Refill",
                "Windshield Wiper Motor Replacement", "Headlight Bulb Replacement", "Taillight Bulb Replacement",
                "Turn Signal Bulb Replacement", "Fog Light Bulb Replacement", "Interior Light Bulb Replacement",
                "Exterior Mirror Replacement", "Windshield Replacement", "Side Window Replacement",
                "Door Lock Actuator Replacement", "Power Window Motor Replacement", "Window Regulator Replacement",
                "Door Handle Replacement", "Door Hinge Replacement", "Door Seal Replacement", "Body Panel Repair",
                "Paint Touch-Up", "Rust Prevention Treatment", "Frame Inspection", "Frame Alignment",
                "Frame Repair", "Body Mount Replacement", "Wheel Arch Liner Replacement", "Underbody Coating",
                "Emergency Exit Door Inspection", "Emergency Exit Door Repair", "Handrail Inspection",
                "Handrail Replacement", "Seat Inspection", "Seat Belt Replacement"]

    with open('services2015-2020.csv', 'w', newline='', encoding="UTF-8") as services_snapshot1:
        writer = csv.writer(services_snapshot1)
        for j in range(61):
            writer.writerow([None, services[j], "Description Lorem Ipsum1", random.randint(50, 5000),
                             random.randint(900, 500000), random.randint(0, 19999)])
        services_snapshot1.close()

    with open('services2020-2024.csv', 'w', newline='', encoding="UTF-8") as services_snapshot2:
        writer = csv.writer(services_snapshot2)
        for j in range(61, 100):
            writer.writerow([None, services[j], "Description Lorem Ipsum2", random.randint(500, 6000),
                             random.randint(900, 500000), random.randint(0, 4999)])
        services_snapshot2.close()


def gen_stat_cours_stops_ztm2015(driv2015, bus2015):
    f = Faker(["en_US"])
    stops2015 = [f.unique.street_name() for _ in range(40000)]  # 7k
    stops_name_with_index = []
    file_stop = []

    for x in range(len(stops2015)):
        stops_name_with_index.append([x, stops2015[x]])
        file_stop.append([None, stops2015[x]])

    with open('stations2015-2020.csv', 'w', newline='', encoding="UTF-8") as stations_snapshot1:
        writer = csv.writer(stations_snapshot1)
        writer.writerows(file_stop)
        stations_snapshot1.close()

    [stops_during_one_course, array_with_bus_numbers, courses, output, lastind] = \
    (gen_stops_and_courses(stops_name_with_index, 0, driv2015, bus2015))

    timetable = gen_ztmotion(courses, array_with_bus_numbers, stops_during_one_course)

    with open('ZTMotion.csv', 'w', newline='', encoding="UTF-8") as ZTM:
        writer = csv.writer(ZTM)
        writer.writerows(timetable)
        ZTM.close()


    with open('stops2015-2020.csv', 'w', newline='', encoding="UTF-8") as stops_snapshot1:
        writer = csv.writer(stops_snapshot1)
        writer.writerows(stops_during_one_course)
        stops_snapshot1.close()

    with open('courses2015-2020.csv', 'w', newline='', encoding="UTF-8") as courses_snapshot1:
        writer = csv.writer(courses_snapshot1)
        writer.writerows(output)
        courses_snapshot1.close()

    return [stops2015, lastind]


def gen_stat_cours_stops_ztm2024(driv2024, bus2024, stops2015, lastind):
    f = Faker(["en_GB"])
    stops2024 = [[f.unique.street_name()] for _ in range(10000)]  # 7k
    file_stops = []
    stops_name_with_index = []
    for x in range(len(stops2024)):
        stops_name_with_index.append([x + len(stops2015), stops2024[x][0]])
        file_stops.append([None, stops2024[x][0]])

    with open('stations2020-2024.csv', 'w', newline='', encoding="UTF-8") as stations_snapshot2:
        writer = csv.writer(stations_snapshot2)
        writer.writerows(file_stops)
        stations_snapshot2.close()

    [stops_during_one_course, array_with_bus_numbers, courses, output, lastind] = (
        gen_stops_and_courses(stops_name_with_index, lastind, driv2024, bus2024))

    with open('stops2020-2024.csv', 'w', newline='', encoding="UTF-8") as stops_snapshot2:
        writer = csv.writer(stops_snapshot2)
        writer.writerows(stops_during_one_course)
        stops_snapshot2.close()

    with open('courses2020-2024.csv', 'w', newline='', encoding="UTF-8") as courses_snapshot2:
        writer = csv.writer(courses_snapshot2)
        writer.writerows(output)
        courses_snapshot2.close()
    timetable = gen_ztmotion(courses, array_with_bus_numbers, stops_during_one_course)

    with open('ZTMotion.csv', 'a', newline='', encoding="UTF-8") as ZTM:
        writer = csv.writer(ZTM)
        writer.writerows(timetable)
        ZTM.close()


if __name__ == '__main__':
    f = Faker(["pl_PL"])
    genservices()
    drivers2015 = gendrivers2015(f)
    buses2015 = genbusesrepairs2015(f)
    [stops2015, lastind] = gen_stat_cours_stops_ztm2015(drivers2015, buses2015)
    drivers2024 = gendrivers2024(f)
    buses2024 = genbusesrepairs2024(f)
    gen_stat_cours_stops_ztm2024(drivers2024, buses2024, stops2015, lastind)
