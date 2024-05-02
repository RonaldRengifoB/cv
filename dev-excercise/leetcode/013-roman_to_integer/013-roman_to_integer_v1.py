class Solution(object):
    def romanToInt(self, s):
        """
        :type s: str
        :rtype: int
        """
        number = 0
        pos = 0
        for pos in s:
            if pos == "M": 
                number += 1000
            elif pos == "D":
                number += 500
            elif pos == "C":
                number += 100
            elif pos == "L":
                number += 50
            elif pos == "X":
                number += 10
            elif pos == "V":
                number += 5
            elif pos == "I":
                number += 1
        if "CM" in s:
            number -=200
        if "CD" in s:
            number -=200
        if "XL" in s:
            number -=20
        if "XC" in s:
            number -=20
        if "IV" in s:
            number -=2
        if "IX" in s:
            number -=2
        return number

