class Solution(object):
    def longestCommonPrefix(self, strs):
        """
        :type strs: List[str]
        :rtype: str
        """
        
        if len(strs)>1:
            string=strs[0]
            count = 0
            verifychar = ""
            prefix = ""
            while count < len(string):    
                for nextstring in range(1,len(strs),1):
                    stringcomp=strs[nextstring]
                    if count < len(string) and count < len(stringcomp):
                        if string[count] == stringcomp[count]:
                            verifychar = string[count]
                        else:
                            return prefix
                    else:
                        return prefix
                prefix += verifychar
                count += 1
            return prefix
        else:
            return strs[0]