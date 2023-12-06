import re
mapper={}
seeds=[]


def find_location(value):
    mapname="seed"
    map = mapper[mapname]
    while 1:
        found=-1
        for elem in map['data']:
            if value >= elem[1] and value < (elem[1] + elem[2]):
                found = value + elem[0]  - elem[1]
                break
        if found==-1:
            found=value
        value=found
        mapname=map['destin']
        if mapname=="location":
              return value   # This is the value of location
        map=mapper[mapname]

def fix_map():
    newmap={}
    for key in mapper.keys():
        map=mapper[key]
        newmap[map['destin']]=mapper[key]
    print("new",newmap)
    return newmap

def find_seed(maps, value):
    mapname="location"
    map = maps[mapname]
    while 1:
        found=-1
        for elem in map['data']:
            if value >= elem[0] and value < (elem[0] + elem[2]):
                found = value + elem[1]  - elem[0]
                break
        if found==-1:
            found=value
        value=found
        mapname=map['source']
        if mapname=="seed":
              return value   # This is the value of location
        map=maps[mapname]

def parse_file(filename):
    counter=1
    current = ""
    for line in open(filename, "r").readlines():
        if counter==1:
            cols=line[:-1].split("seeds: ")
            seedstr=cols[1].split(" ")
            for s in range(0,len(seedstr),2):
                seeds.append((int(seedstr[s]),int(seedstr[s])+int(seedstr[s+1])))
            counter = counter + 1
            continue
        counter = counter + 1
        line=line[:-1]
        x = re.search("\d+", line)
        if x is None:
            cols=line.split(" ")
            nn=cols[0].split("-to-")
            if len(nn)>1:
                print(nn)
                current=nn[0]
                mapper[nn[0]]={
                    'source': nn[0],
                    'destin': nn[1],
                    'data':[]
                }
        else:

            numbs = line.split(" ")
            numm=[]
            for s in numbs:
                if len(s)>0:
                    numm.append(int(s))
            mapper[current]['data'].append(numm)


    print(mapper)
    bestloc=-1

    for s in seeds:
        for i in range(s[0], s[1]):
            loc=find_location(i)
            if bestloc==-1 or loc<bestloc:
                bestloc=loc
    print("Best loc ", bestloc)
    return
    maps=fix_map()
    locs=maps['location']
    loclist=[]
    print(seeds)
    for l in locs['data']:
        print(l)
        for x in range(l[1], l[1] + l[2]):
            z = find_seed(maps, x)
            print(x, z)
        for x in range(0, l[1]):
            z = find_seed(maps, x)
            print(x, z)


    for i in range(100):
        x=find_seed(maps, i)
        for s in seeds:
            if x>=s[0] and x<s[1]:
                print("Found range ", i, x, s[0], s[1])
        print(i, x)

if __name__ == '__main__':
    parse_file("./input.txt")

