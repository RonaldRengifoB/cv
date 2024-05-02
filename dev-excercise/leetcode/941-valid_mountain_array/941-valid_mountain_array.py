class Solution:
    def numRescueBoats(self, people: List[int], limit: int) -> int:
        people.sort()
        heavyP = len(people)-1
        lightP = 0
        boats = 0
        while (heavyP >= lightP):
            if (heavyP == lightP):
                boats += 1
                break    
            if(people[heavyP]+people[lightP]<=limit):
                lightP += 1
            boats += 1
            heavyP -= 1 
        return boats