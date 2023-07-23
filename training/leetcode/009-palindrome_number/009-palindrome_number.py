class Solution(object):
    def isPalindrome(self, x):
        num=str(x)
        numlen=len(num)-1
        palindrome=True
        for i in range(len(num)):
         if num[i]!=num[numlen-i]:
                palindrome=False
        return palindrome
