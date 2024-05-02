def is_armstrong_number(number):
    armstrong = 0
    for digit in str(number):
        armstrong += int(digit) ** int(len(str(number)))
    if armstrong == number:
        return True
    else:
        return False