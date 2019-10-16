import urllib.request
from html.parser import HTMLParser

class MyHTMLParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        print("Encountered a start tag:", tag)

    def handle_endtag(self, tag):
        print("Encountered an end tag :", tag)

    def handle_data(self, data):
        print("Encountered some data  :", data)

parser = MyHTMLParser()

file = open("out.txt", "w")

url = "http://annarboradulthockey.com/master_sched_league.php?day="


d = input("Enter The Day: ")
m = input("Enter The Month: ")
y = input("Enter The Year: ")

url += d+"&month="+m+"&year="+y

print(url)

req = urllib.request.Request(
    url,
    data=None,
    headers={
        'User-Agent': 'Mozilla/5.0'
    }
)

f = urllib.request.urlopen(req)
htmlstr = (f.read().decode('utf-8'))

array1 = [""]

#get the schedule table from url and write it to out.txt
def getTable(mystr):
    #remove unneeded html
    mystr = mystr[mystr.find("<div id=\"sched\">"):]
    mystr = mystr[:mystr.find("</div></div>")]

    while(1==1):
        y = mystr.find("</a>")
        if(y == -1):
            break
        array1.append(mystr[:y])
        mystr = mystr[y+4:]

    array1.pop(0)

def formatLine(line):
    visitor = line[line.find("- ") + 2:line.find(" (")]
    home = line[line.find("@&nbsp;") + 7:line[line.find("@&nbsp;"):].find(" (") + line.find("@&nbsp;")]
    location = line[len(line) - 12:len(line) - 5]
    line = visitor + "," + home + "," + location
    return line
    #print(line)

def sortarr(arr):
    oc = 0
    sc = 0
    vc = 0
    olympicT = []
    stadiumT = []
    varsityT = []
    for x in arr:
        if(x.find("Olympic") != -1):
            olympicT.append(x[:len(x) - 8])
        if(x.find("Stadium") != -1):
            stadiumT.append(x[:len(x) - 8])
        if(x.find("Varsity") != -1):
            varsityT.append(x[:len(x) - 8])

    result = []
    result.append(olympicT)
    result.append(stadiumT)
    result.append(varsityT)

    return result

#main calls
getTable(htmlstr)
i= 0
for x in array1:
    array1[i] = formatLine(x)
    i += 1

#write to out.txt
array1 = sortarr(array1)
for x in array1:
    file.write(str(len(x)) + "\n")

for x in array1:
    for y in x:
        file.write(y + "\n")
    file.write("\n")

file.close()
