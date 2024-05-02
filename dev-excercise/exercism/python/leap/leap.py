def leap_year(year):
    return bool(year % 4 == 0 and (not year % 100 == 0 or year % 400 == 0))
